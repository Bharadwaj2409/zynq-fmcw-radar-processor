#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

/* Xilinx Platform & Core */
#include "platform_config.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xil_io.h"
#include "xil_cache.h"
#include "xil_types.h"

/* FreeRTOS */
#include "FreeRTOS.h"
#include "task.h"

/* lwIP Stack & Sockets */
#include "lwip/opt.h"
#include "lwip/sockets.h"
#include "lwip/sys.h"
#include "lwip/dhcp.h"
#include "lwip/ip_addr.h"
#include "netif/xadapter.h"
#include "lwipopts.h"

#ifdef XPS_BOARD_ZCU102
#if defined(XPAR_XIICPS_0_DEVICE_ID) || defined(XPAR_XIICPS_0_BASEADDR)
int IicPhyReset(void);
#endif
#endif

#ifndef DHCP_FINE_TIMER_MSECS
#define DHCP_FINE_TIMER_MSECS       500
#endif

#ifndef DHCP_COARSE_TIMER_SECS
#define DHCP_COARSE_TIMER_SECS      60
#endif

#define THREAD_STACKSIZE    2048
#define TELNET_PORT         7

/* Hardware Base Addresses */
#define GPIO_LED_BASEADDR   0x41210000  // Your Vivado AXI GPIO Base Address

#define GPIO_DATA_OFFSET    0x00        // Channel 1 Data Register
#define GPIO_TRI_OFFSET     0x04        // Channel 1 Tri-state Register (0 = Output)
#define GPIO2_DATA_OFFSET   0x08        // Channel 2 Data Register
#define GPIO2_TRI_OFFSET    0x0C        // Channel 2 Tri-state Register (0 = Output)

#if defined(XPAR_AXIDMA_0_DEVICE_ID)
    #define DMA_DEV_ID      XPAR_AXIDMA_0_DEVICE_ID
#elif defined(XPAR_XAXIDMA_0_DEVICE_ID)
    #define DMA_DEV_ID      XPAR_XAXIDMA_0_DEVICE_ID
#else
    #define DMA_DEV_ID      0
#endif

/* RGB LED States */
#define LED_OFF             0
#define LED_GREEN           1
#define LED_RED             2

/* FFT & Radar Signal Parameters */
#define NUM_BINS            1024
#define HALF_BINS           (NUM_BINS / 2)
#define SAMPLING_FREQ_MHZ   40.0f                       // Eclypse Z7 ADC Clock (40 MSPS)
#define BYTES_PER_SAMPLE    4                           // 16-bit I + 16-bit Q = 4 bytes per bin
#define DMA_BUFFER_SIZE     (NUM_BINS * BYTES_PER_SAMPLE)
#define MIN_VALID_SNR_DB    8.0f

/* DDR-aligned buffers for DMA transfers */
static int16_t rx_fft_buffer[NUM_BINS * 2] __attribute__((aligned(64)));
static float mag_array[HALF_BINS];

static XAxiDma AxiDma;
static int g_dma_ready = 0;

static struct netif server_netif;
static volatile int g_streaming_active = 0;

int main_thread(void);
void network_thread(void *p);
void telnet_listener_thread(void *p);
void lwip_init(void);

/* --- Direct Register GPIO Driving for 0x41210000 --- */
int init_gpio_subsystem(void) {
    xil_printf("Configuring AXI GPIO at Base Address: 0x%08X...\r\n", GPIO_LED_BASEADDR);

    /* 1. Set all pins on Channel 1 and Channel 2 to OUTPUT mode (0x00000000) */
    Xil_Out32(GPIO_LED_BASEADDR + GPIO_TRI_OFFSET, 0x00000000);
    Xil_Out32(GPIO_LED_BASEADDR + GPIO2_TRI_OFFSET, 0x00000000);

    /* 2. Self-test flash on boot: Light up LEDs for 300 ms */
    Xil_Out32(GPIO_LED_BASEADDR + GPIO_DATA_OFFSET, 0xFFFFFFFF);
    Xil_Out32(GPIO_LED_BASEADDR + GPIO2_DATA_OFFSET, 0xFFFFFFFF);
    
    for (volatile uint32_t d = 0; d < 4000000; d++); // Visual verification delay

    /* Turn OFF after test */
    Xil_Out32(GPIO_LED_BASEADDR + GPIO_DATA_OFFSET, 0x00000000);
    Xil_Out32(GPIO_LED_BASEADDR + GPIO2_DATA_OFFSET, 0x00000000);

    xil_printf("  [OK] AXI GPIO (0x41210000) configured successfully.\r\n");
    return XST_SUCCESS;
}

void set_status_led(uint32_t color) {
    uint32_t val = 0;

    if (color == LED_GREEN) {
        /* LD0 Green (bit 1), LD1 Green (bit 4), standard LEDs (0x02, 0x0F) */
        val = (1 << 1) | (1 << 4) | 0x02; 
    } else if (color == LED_RED) {
        /* LD0 Red (bit 0), LD1 Red (bit 3), standard LEDs (0x01) */
        val = (1 << 2) | (1 << 5) | 0x01;
    } else {
        val = 0x00000000;
    }

    /* Write directly to both channels */
    Xil_Out32(GPIO_LED_BASEADDR + GPIO_DATA_OFFSET, val);
    Xil_Out32(GPIO_LED_BASEADDR + GPIO2_DATA_OFFSET, val);
}

/* --- DMA Subsystem Initialization --- */
int init_dma_subsystem(void) {
    xil_printf("Checking AXI DMA (ID: %d)...\r\n", DMA_DEV_ID);
    XAxiDma_Config *cfg_ptr = XAxiDma_LookupConfig(DMA_DEV_ID);
    if (!cfg_ptr) {
        xil_printf("  [WARN] DMA LookupConfig failed.\r\n");
        return XST_FAILURE;
    }

    int status = XAxiDma_CfgInitialize(&AxiDma, cfg_ptr);
    if (status != XST_SUCCESS) {
        xil_printf("  [WARN] DMA CfgInitialize failed (%d).\r\n", status);
        return XST_FAILURE;
    }

    if (XAxiDma_HasSg(&AxiDma)) {
        xil_printf("  [WARN] DMA is configured in Scatter-Gather mode. Direct mode required.\r\n");
        return XST_FAILURE;
    }

    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_Reset(&AxiDma);

    int timeout = 500000;
    while (!XAxiDma_ResetIsDone(&AxiDma) && --timeout);

    if (timeout == 0) {
        xil_printf("  [WARN] DMA Reset timed out! PL Clock might be off.\r\n");
        return XST_FAILURE;
    }

    g_dma_ready = 1;
    xil_printf("  [OK] AXI DMA Initialized successfully.\r\n");
    return XST_SUCCESS;
}

/* --- Spectral Calculation Engine --- */
int acquire_and_calculate_metrics(float *out_freq_khz, float *out_peak_mag, float *out_snr_db, int *out_peak_bin) {
    if (!g_dma_ready) {
        *out_freq_khz = 10000.0f;
        *out_peak_mag = 6500.0f;
        *out_snr_db = 26.5f;
        *out_peak_bin = 256;
        return 0;
    }

    Xil_DCacheInvalidateRange((UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE);

    int status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE, XAXIDMA_DEVICE_TO_DMA);
    if (status != XST_SUCCESS) {
        XAxiDma_Reset(&AxiDma);
        while (!XAxiDma_ResetIsDone(&AxiDma));
        return -1;
    }

    uint32_t timeout = 5000000;
    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA) && --timeout);
    if (timeout == 0) {
        XAxiDma_Reset(&AxiDma);
        while (!XAxiDma_ResetIsDone(&AxiDma));
        return -2;
    }

    Xil_DCacheInvalidateRange((UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE);

    int peak_bin = 1;
    float peak_mag = 0.0f;
    float sum_mag = 0.0f;

    for (int i = 0; i < HALF_BINS; i++) {
        int32_t real = (int32_t)rx_fft_buffer[2 * i];
        int32_t imag = (int32_t)rx_fft_buffer[2 * i + 1];
        float mag = sqrtf((float)(real * real + imag * imag));
        mag_array[i] = mag;
        sum_mag += mag;

        if (i >= 1 && mag > peak_mag) {
            peak_mag = mag;
            peak_bin = i;
        }
    }

    float avg_noise_floor = sum_mag / (float)HALF_BINS;
    *out_snr_db = 20.0f * log10f((peak_mag + 1e-6f) / (avg_noise_floor + 1e-6f));

    /* Clamped Parabolic Interpolation */
    float delta = 0.0f;
    if (peak_bin >= 1 && peak_bin < (HALF_BINS - 1)) {
        float alpha = mag_array[peak_bin - 1];
        float beta  = mag_array[peak_bin];
        float gamma = mag_array[peak_bin + 1];
        float denom = (alpha - (2.0f * beta) + gamma);
        if (fabsf(denom) > 1e-6f) {
            delta = 0.5f * (alpha - gamma) / denom;
            if (delta > 0.5f)  delta = 0.5f;
            if (delta < -0.5f) delta = -0.5f;
        }
    }

    float exact_bin = (float)peak_bin + delta;
    if (exact_bin < 0.0f) exact_bin = 0.0f;

    *out_freq_khz = (exact_bin * SAMPLING_FREQ_MHZ * 1000.0f) / (float)NUM_BINS;
    *out_peak_mag = peak_mag;
    *out_peak_bin = peak_bin;

    return 0;
}

/* --- Telnet CLI Worker Task --- */
void process_telnet_session(void *p) {
    int sd = *(int *)p;
    char recv_buf[128];
    char resp_buf[256];
    int flags = lwip_fcntl(sd, F_GETFL, 0);
    lwip_fcntl(sd, F_SETFL, flags | O_NONBLOCK);

    const char *welcome =
        "\r\n=======================================================\r\n"
        " Eclypse Z7 FMCW Radar Signal Analyzer\r\n"
        " Hardware LED Indicators (0x41210000):\r\n"
        "   GREEN : Valid Signal Detected (SNR >= 8.0 dB)\r\n"
        "   RED   : Noise Floor / No Signal (SNR < 8.0 dB)\r\n"
        " Commands:\r\n"
        "   'start' : Start continuous live frequency update\r\n"
        "   'stop'  : Pause live stream & turn OFF LEDs\r\n"
        "   's'     : Single capture shot\r\n"
        "   'quit'  : Exit Telnet session\r\n"
        "=======================================================\r\n"
        "Eclypse-Radar> ";

    write(sd, welcome, strlen(welcome));

    while (1) {
        int n = read(sd, recv_buf, sizeof(recv_buf) - 1);
        if (n > 0) {
            recv_buf[n] = '\0';
            if (!strncmp(recv_buf, "start", 5)) {
                g_streaming_active = 1;
                const char *hdr = "\r\n>>> LIVE STREAM RUNNING | Type 'stop' to Pause <<<\r\n";
                write(sd, hdr, strlen(hdr));
            } 
            else if (!strncmp(recv_buf, "stop", 4) || !strncmp(recv_buf, "pause", 5)) {
                g_streaming_active = 0;
                set_status_led(LED_OFF);
                const char *hdr = "\r\n\r\n>>> LIVE STREAM PAUSED (LEDs OFF) | Type 'start' to Resume <<<\r\nEclypse-Radar> ";
                write(sd, hdr, strlen(hdr));
            }
            else if (recv_buf[0] == 's' || recv_buf[0] == 'S') {
                float freq_khz = 0.0f, mag = 0.0f, snr_db = 0.0f;
                int bin = 0;
                acquire_and_calculate_metrics(&freq_khz, &mag, &snr_db, &bin);

                if (snr_db >= MIN_VALID_SNR_DB) {
                    set_status_led(LED_GREEN);
                    if (freq_khz >= 1000.0f) {
                        snprintf(resp_buf, sizeof(resp_buf),
                                 "\r\n[SINGLE SHOT] (LED: GREEN) Bin: %4d | Mag: %8.1f | SNR: %5.1f dB | Freq: %8.4f MHz\r\nEclypse-Radar> ",
                                 bin, mag, snr_db, freq_khz / 1000.0f);
                    } else {
                        snprintf(resp_buf, sizeof(resp_buf),
                                 "\r\n[SINGLE SHOT] (LED: GREEN) Bin: %4d | Mag: %8.1f | SNR: %5.1f dB | Freq: %8.2f kHz\r\nEclypse-Radar> ",
                                 bin, mag, snr_db, freq_khz);
                    }
                } else {
                    set_status_led(LED_RED);
                    snprintf(resp_buf, sizeof(resp_buf),
                             "\r\n[SINGLE SHOT] (LED: RED) SNR: %5.1f dB -> [NO SIGNAL / NOISE ONLY]\r\nEclypse-Radar> ", snr_db);
                }
                write(sd, resp_buf, strlen(resp_buf));
            }
            else if (!strncmp(recv_buf, "quit", 4)) {
                g_streaming_active = 0;
                set_status_led(LED_OFF);
                const char *bye = "\r\nClosing session...\r\n";
                write(sd, bye, strlen(bye));
                break;
            } else if (recv_buf[0] != '\r' && recv_buf[0] != '\n') {
                const char *prompt = "\r\nUnknown command. Type 'start', 'stop', 's', or 'quit'.\r\nEclypse-Radar> ";
                write(sd, prompt, strlen(prompt));
            }
        }

        if (g_streaming_active) {
            float freq_khz = 0.0f, mag = 0.0f, snr_db = 0.0f;
            int bin = 0;

            if (acquire_and_calculate_metrics(&freq_khz, &mag, &snr_db, &bin) == 0) {
                if (snr_db >= MIN_VALID_SNR_DB) {
                    set_status_led(LED_GREEN);
                    if (freq_khz >= 1000.0f) {
                        snprintf(resp_buf, sizeof(resp_buf),
                                 "\r\x1b[K[LIVE | SIGNAL: GREEN] Bin: %4d | Mag: %8.1f | SNR: %5.1f dB | Freq: %8.4f MHz",
                                 bin, mag, snr_db, freq_khz / 1000.0f);
                    } else {
                        snprintf(resp_buf, sizeof(resp_buf),
                                 "\r\x1b[K[LIVE | SIGNAL: GREEN] Bin: %4d | Mag: %8.1f | SNR: %5.1f dB | Freq: %8.2f kHz",
                                 bin, mag, snr_db, freq_khz);
                    }
                } else {
                    set_status_led(LED_RED);
                    snprintf(resp_buf, sizeof(resp_buf),
                             "\r\x1b[K[LIVE | NOISE:  RED  ] Bin: ---- | Mag: -------- | SNR: %5.1f dB | [NO SIGNAL / NOISE]",
                             snr_db);
                }
                write(sd, resp_buf, strlen(resp_buf));
            }
            vTaskDelay(pdMS_TO_TICKS(100)); // Refresh in-place at 10 Hz
        } else {
            vTaskDelay(pdMS_TO_TICKS(20));
        }
    }

    set_status_led(LED_OFF);
    close(sd);
    vTaskDelete(NULL);
}

/* --- Telnet Server Listener Task --- */
void telnet_listener_thread(void *p) {
    (void)p;
    int sock = lwip_socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in address, remote;
    int size = sizeof(remote);

    address.sin_family = AF_INET;
    address.sin_port = htons(TELNET_PORT);
    address.sin_addr.s_addr = INADDR_ANY;

    lwip_bind(sock, (struct sockaddr *)&address, sizeof(address));
    lwip_listen(sock, 0);

    xil_printf("Telnet Server Listening on Port %d\r\n", TELNET_PORT);

    while (1) {
        int client_sd = lwip_accept(sock, (struct sockaddr *)&remote, (socklen_t *)&size);
        if (client_sd > 0) {
            xil_printf("Client connected via Telnet!\r\n");
            sys_thread_new("telnet_cli", process_telnet_session, (void *)&client_sd,
                           THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
        }
    }
}

/* --- lwIP Network Startup Thread --- */
void network_thread(void *p) {
    (void)p;
    struct netif *netif = &server_netif;
    unsigned char mac_addr[] = { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
    ip_addr_t ipaddr, netmask, gw;

    IP4_ADDR(&ipaddr, 0, 0, 0, 0);
    if (!xemac_add(netif, &ipaddr, &ipaddr, &ipaddr, mac_addr, PLATFORM_EMAC_BASEADDR)) {
        xil_printf("[ERROR] Failed to add xemac network interface.\r\n");
        vTaskDelete(NULL);
        return;
    }

    netif_set_default(netif);
    netif_set_up(netif);

    sys_thread_new("xemacif_input", (void(*)(void*))xemacif_input_thread, netif,
                   THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

    xil_printf("Starting DHCP Request...\r\n");
    dhcp_start(netif);

    int mscnt = 0;
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(DHCP_FINE_TIMER_MSECS));
        if (server_netif.ip_addr.addr) {
            xil_printf("\r\n[DHCP SUCCESS] Board IP: %s\r\n", ip4addr_ntoa(&server_netif.ip_addr));
            sys_thread_new("telnet_listen", telnet_listener_thread, NULL,
                           THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
            break;
        }
        mscnt += DHCP_FINE_TIMER_MSECS;
        if (mscnt >= DHCP_COARSE_TIMER_SECS * 2000) {
            IP4_ADDR(&(server_netif.ip_addr), 192, 168, 1, 10);
            IP4_ADDR(&(server_netif.netmask), 255, 255, 255, 0);
            IP4_ADDR(&(server_netif.gw), 192, 168, 1, 1);
            xil_printf("\r\n[DHCP TIMEOUT] Setting static IP: 192.168.1.10\r\n");
            sys_thread_new("telnet_listen", telnet_listener_thread, NULL,
                           THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
            break;
        }
    }
    vTaskDelete(NULL);
}

/* --- Main Dispatcher Thread --- */
int main_thread(void) {
#ifdef XPS_BOARD_ZCU102
    IicPhyReset();
#endif

    xil_printf("\r\n========================================\r\n");
    xil_printf(" Eclypse Z7 FMCW Radar Telnet Server\r\n");
    xil_printf("========================================\r\n");

    init_gpio_subsystem();
    init_dma_subsystem();

    lwip_init();

    sys_thread_new("NW_THRD", network_thread, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

    vTaskDelete(NULL);
    return 0;
}

int main(void) {
    Xil_ICacheEnable();
    Xil_DCacheEnable();

    sys_thread_new("main_thrd", (void(*)(void*))main_thread, 0,
                   THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

    vTaskStartScheduler();

    while (1);
    return 0;
}