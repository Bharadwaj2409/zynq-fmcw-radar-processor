#include <stdio.h>
#include <string.h>
#include <math.h>

/* Xilinx Includes */
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"

/* FreeRTOS Includes */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

/* lwIP Includes */
#include "lwip/opt.h"
#include "lwip/api.h"
#include "lwip/sys.h"
#include "lwip/tcpip.h"
#include "lwip/ip_addr.h"
#include "netif/xadapter.h"

/* Network Configuration */
#define IP_ADDR          "192.168.1.10"
#define IP_NETMASK       "255.255.255.0"
#define IP_GATEWAY       "192.168.1.1"
#define TELNET_PORT      23

/* Signal & FFT Definitions */
#define FS_HZ            40000000.0f  // 40 MSPS ADC Clock
#define FFT_POINTS       1024
#define V_FULL_SCALE     2.0f         // +/- 1.0V (High-gain mode)
#define ADC_MAX_CODE     16383.0f     // 14-bit ADC resolution

/* Task Priorities and Stack Sizes */
#define MAIN_TASK_PRIORITY     (tskIDLE_PRIORITY + 1)
#define TELNET_TASK_PRIORITY   (tskIDLE_PRIORITY + 2)
#define THREAD_STACK_SIZE      2048

static struct netif server_netif;

/* External or DMA-accessible buffers */
int16_t raw_adc_buffer[FFT_POINTS];
float   fft_mag_buffer[FFT_POINTS / 2];

/* --- Dummy ADC Signal Generator --- */
static void populate_test_signal(void) {
    for (int i = 0; i < FFT_POINTS; i++) {
        int16_t sample = (int16_t)((i % 128) * 94 - 6000);
        raw_adc_buffer[i] = sample;
    }
    for (int i = 0; i < FFT_POINTS / 2; i++) {
        fft_mag_buffer[i] = 10.0f;
    }
    int expected_bin = 384; // ~15.0 MHz bin at 40 MSPS
    fft_mag_buffer[expected_bin - 1] = 450.0f;
    fft_mag_buffer[expected_bin]     = 1850.0f;
    fft_mag_buffer[expected_bin + 1] = 620.0f;
}

/* --- High-Precision Frequency & Peak-to-Peak Estimator --- */
static void calculate_adc_metrics(float *out_freq_hz, float *out_vpp) {
    int16_t min_val = 32767;
    int16_t max_val = -32768;

    for (int i = 0; i < FFT_POINTS; i++) {
        int16_t sample = raw_adc_buffer[i];
        if (sample < min_val) min_val = sample;
        if (sample > max_val) max_val = sample;
    }
    *out_vpp = (((float)(max_val - min_val)) / ADC_MAX_CODE) * V_FULL_SCALE;

    int peak_idx = 1;
    float peak_val = fft_mag_buffer[1];

    for (int i = 2; i < (FFT_POINTS / 2) - 1; i++) {
        if (fft_mag_buffer[i] > peak_val) {
            peak_val = fft_mag_buffer[i];
            peak_idx = i;
        }
    }

    float alpha = fft_mag_buffer[peak_idx - 1];
    float beta  = fft_mag_buffer[peak_idx];
    float gamma = fft_mag_buffer[peak_idx + 1];

    float delta = 0.0f;
    float denom = (alpha - (2.0f * beta) + gamma);
    if (fabsf(denom) > 1e-6f) {
        delta = 0.5f * (alpha - gamma) / denom;
    }

    float exact_bin = (float)peak_idx + delta;
    *out_freq_hz = exact_bin * (FS_HZ / (float)FFT_POINTS);
}

/* --- Telnet Server Worker Task (Per Connected Client) --- */
static void telnet_worker_task(void *pvParameters) {
    struct netconn *conn = (struct netconn *)pvParameters;
    struct netbuf *inbuf;
    char *buf;
    u16_t buflen;
    err_t err;

    const char *welcome = 
        "\r\n==============================================\r\n"
        " Eclypse Z7 FMCW Radar Signal Analyzer\r\n"
        " Commands:\r\n"
        "   'S' / 's' : Acquire & Display Frequency & Vp-p\r\n"
        "   'Q' / 'q' : Close Connection\r\n"
        "==============================================\r\n> ";

    netconn_write(conn, welcome, strlen(welcome), NETCONN_COPY);

    while (1) {
        err = netconn_recv(conn, &inbuf);
        if (err != ERR_OK) {
            break;
        }

        netbuf_data(inbuf, (void **)&buf, &buflen);

        if (buflen > 0) {
            char cmd = buf[0];

            if (cmd == 'S' || cmd == 's') {
                populate_test_signal();

                float freq_hz = 0.0f;
                float vpp = 0.0f;
                calculate_adc_metrics(&freq_hz, &vpp);

                char response[128];
                if (freq_hz >= 1000000.0f) {
                    snprintf(response, sizeof(response),
                             "\r\n[RESULT] Detected: %8.4f MHz | Peak-to-Peak: %.3f V\r\n> ",
                             freq_hz / 1e6f, vpp);
                } else {
                    snprintf(response, sizeof(response),
                             "\r\n[RESULT] Detected: %8.3f kHz | Peak-to-Peak: %.3f V\r\n> ",
                             freq_hz / 1e3f, vpp);
                }

                netconn_write(conn, response, strlen(response), NETCONN_COPY);
            } 
            else if (cmd == 'Q' || cmd == 'q') {
                const char *bye = "\r\nClosing session...\r\n";
                netconn_write(conn, bye, strlen(bye), NETCONN_COPY);
                netbuf_delete(inbuf);
                break;
            } 
            else if (cmd != '\r' && cmd != '\n') {
                const char *unknown = "\r\nUnknown key. Press 'S' to acquire or 'Q' to quit.\r\n> ";
                netconn_write(conn, unknown, strlen(unknown), NETCONN_COPY);
            }
        }
        netbuf_delete(inbuf);
    }

    netconn_close(conn);
    netconn_delete(conn);
    vTaskDelete(NULL);
}

/* --- Telnet Master Listener Task --- */
static void telnet_listener_task(void *pvParameters) {
    (void)pvParameters;
    struct netconn *listener;
    struct netconn *newconn;
    err_t err;

    listener = netconn_new(NETCONN_TCP);
    if (listener == NULL) {
        xil_printf("[ERROR] Failed to allocate listener socket\r\n");
        vTaskDelete(NULL);
        return;
    }

    netconn_bind(listener, IP_ADDR_ANY, TELNET_PORT);
    netconn_listen(listener);
    xil_printf("Telnet Server Listening on %s:%d\r\n", IP_ADDR, TELNET_PORT);

    while (1) {
        err = netconn_accept(listener, &newconn);
        if (err == ERR_OK) {
            xil_printf("Telnet client connected!\r\n");
            sys_thread_new("telnet_worker", telnet_worker_task, (void *)newconn,
                           THREAD_STACK_SIZE, TELNET_TASK_PRIORITY);
        }
    }
}

/* --- Callback Triggered Once lwIP Core is Ready --- */
static void tcpip_init_done_cb(void *arg) {
    (void)arg;
    ip_addr_t ipaddr, netmask, gw;
    unsigned char mac_addr[] = { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

    /* Native lwIP string to IP parser */
    ipaddr_aton(IP_ADDR, &ipaddr);
    ipaddr_aton(IP_NETMASK, &netmask);
    ipaddr_aton(IP_GATEWAY, &gw);

    if (!xemac_add(&server_netif, &ipaddr, &netmask, &gw, mac_addr, XPAR_XEMACPS_0_BASEADDR)) {
        xil_printf("[ERROR] Failed to add xemac network interface\r\n");
        return;
    }

    netif_set_default(&server_netif);
    netif_set_up(&server_netif);

    xil_printf("Network Interface Ready!\r\n");
    xil_printf("  Static IP: %s\r\n", IP_ADDR);

    /* Launch the Telnet listener thread */
    sys_thread_new("telnet_listener", telnet_listener_task, NULL,
                   THREAD_STACK_SIZE, TELNET_TASK_PRIORITY);
}

/* --- Main Task: Running in Scheduler Context --- */
static void prvMainTask(void *pvParameters) {
    (void)pvParameters;
    xil_printf("\r\n--- Initializing FreeRTOS lwIP Stack ---\r\n");

    /* Initialize TCP/IP stack cleanly within task context */
    tcpip_init(tcpip_init_done_cb, NULL);

    /* Self-terminate setup task */
    vTaskDelete(NULL);
}

int main(void) {
    Xil_ICacheEnable();
    Xil_DCacheEnable();

    xil_printf("\r\n=== FreeRTOS ADC Telnet Server Booting ===\r\n");

    /* Create initial task */
    xTaskCreate(prvMainTask, "prvMain", 4096, NULL, MAIN_TASK_PRIORITY, NULL);

    /* Start FreeRTOS scheduler */
    vTaskStartScheduler();

    while (1);
    return 0;
}