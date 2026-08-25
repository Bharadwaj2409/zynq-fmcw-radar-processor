#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xil_cache.h"
#include "xil_types.h"

// Radar & FFT Configuration
#define NUM_BINS            1024
#define HALF_BINS           (NUM_BINS / 2)
#define SAMPLING_FREQ_MHZ   40.0f                       // Eclypse Z7 Zmod Scope ADC clock
#define BYTES_PER_SAMPLE    4                           // 16-bit I + 16-bit Q = 4 bytes per bin
#define DMA_BUFFER_SIZE     (NUM_BINS * BYTES_PER_SAMPLE)
#define MIN_VALID_SNR_DB    10.0f                       // Threshold to distinguish real signal from noise floor

#if defined(XPAR_AXIDMA_0_DEVICE_ID)
    #define DMA_DEV_ID      XPAR_AXIDMA_0_DEVICE_ID
#else
    #define DMA_DEV_ID      0
#endif

// 64-byte aligned buffer in DDR to match Zynq cache line boundary
static int16_t rx_fft_buffer[NUM_BINS * 2] __attribute__((aligned(64)));
static float mag_array[HALF_BINS];

static XAxiDma AxiDma;

void process_and_display_spectrum(const int16_t *buffer, int num_bins) {
    int peak_bin = 2;
    float peak_mag = 0.0f;
    float sum_mag = 0.0f;

    // 1. Process positive half of the Nyquist spectrum (Bins 0 to HALF_BINS - 1)
    for (int i = 0; i < HALF_BINS; i++) {
        int32_t real = (int32_t)buffer[2 * i];
        int32_t imag = (int32_t)buffer[2 * i + 1];

        // Complex magnitude: |X[k]| = sqrt(Re^2 + Im^2)
        float mag = sqrtf((float)(real * real + imag * imag));
        mag_array[i] = mag;
        sum_mag += mag;

        // Ignore DC offset and sub-bin bleed (Bins 0 and 1) when finding spectral peak
        if (i >= 2 && mag > peak_mag) {
            peak_mag = mag;
            peak_bin = i;
        }
    }

    float avg_noise_floor = sum_mag / (float)HALF_BINS;
    float snr_db = 20.0f * log10f((peak_mag + 1e-6f) / (avg_noise_floor + 1e-6f));

    // 2. Parabolic Interpolation around peak_bin to eliminate bin quantization jitter
    float delta = 0.0f;
    if (peak_bin > 1 && peak_bin < (HALF_BINS - 1)) {
        float alpha = mag_array[peak_bin - 1];
        float beta  = mag_array[peak_bin];
        float gamma = mag_array[peak_bin + 1];
        float denom = (alpha - (2.0f * beta) + gamma);
        if (fabsf(denom) > 1e-6f) {
            delta = 0.5f * (alpha - gamma) / denom;
        }
    }

    float exact_bin = (float)peak_bin + delta;
    float detected_freq_mhz = (exact_bin * SAMPLING_FREQ_MHZ) / (float)num_bins;

    // 3. Formatted Spectrum Display
    printf("========================================\r\n");
    printf(" Live PL FFT Capture Status\r\n");
    printf("========================================\r\n");
    printf("Peak Bin Index : %d (Interpolated: %.2f) / %d\r\n", peak_bin, exact_bin, num_bins);
    printf("Peak Magnitude : %.2f\r\n", peak_mag);
    printf("Avg Noise Floor: %.2f\r\n", avg_noise_floor);
    printf("SNR Estimate   : %.2f dB\r\n", snr_db);

    if (snr_db >= MIN_VALID_SNR_DB) {
        if (detected_freq_mhz >= 1.0f) {
            printf("Detected Freq  : %.4f MHz\r\n", detected_freq_mhz);
        } else {
            printf("Detected Freq  : %.3f kHz\r\n", detected_freq_mhz * 1000.0f);
        }
    } else {
        printf("Detected Freq  : [NO SIGNAL / NOISE ONLY]\r\n");
    }
    printf("\r\n");
}

int init_dma_subsystem(void) {
    XAxiDma_Config *cfg_ptr;
    int status;

    cfg_ptr = XAxiDma_LookupConfig(DMA_DEV_ID);
    if (!cfg_ptr) {
        xil_printf("ERROR: No DMA configuration found for ID %d\r\n", DMA_DEV_ID);
        return XST_FAILURE;
    }

    status = XAxiDma_CfgInitialize(&AxiDma, cfg_ptr);
    if (status != XST_SUCCESS) {
        xil_printf("ERROR: DMA Initialization failed with status %d\r\n", status);
        return XST_FAILURE;
    }

    if (XAxiDma_HasSg(&AxiDma)) {
        xil_printf("ERROR: DMA configured in Scatter-Gather mode. Direct register mode required.\r\n");
        return XST_FAILURE;
    }

    // Disable all S2MM interrupts for polling mode
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);

    // Hardware Reset DMA engine to clean internal FIFO pointers
    XAxiDma_Reset(&AxiDma);
    while (!XAxiDma_ResetIsDone(&AxiDma)) {
        // Wait for reset
    }

    return XST_SUCCESS;
}

int main(void) {
    init_platform();

    printf("\r\n========================================\r\n");
    printf(" Eclypse Z7 FMCW Radar Signal Processor\r\n");
    printf("========================================\r\n");

    if (init_dma_subsystem() != XST_SUCCESS) {
        printf("Halting execution due to DMA failure.\r\n");
        cleanup_platform();
        return -1;
    }

    printf("AXI DMA Initialized in Simple Transfer Mode.\r\n");
    printf("Starting live capture loop from FPGA PL...\r\n\r\n");

    // Perform an initial throwaway capture to synchronize TLAST boundary
    Xil_DCacheInvalidateRange((UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE);
    XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE, XAXIDMA_DEVICE_TO_DMA);
    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA));
    Xil_DCacheInvalidateRange((UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE);

    while (1) {
        // 1. Invalidate cache before DMA transfers new data into DDR
        Xil_DCacheInvalidateRange((UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE);

        // 2. Launch DMA S2MM transfer (PL FFT Stream -> DDR)
        int status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE, XAXIDMA_DEVICE_TO_DMA);
        if (status != XST_SUCCESS) {
            printf("DMA Simple Transfer failed to initiate! Status: %d. Resetting DMA...\r\n", status);
            XAxiDma_Reset(&AxiDma);
            while (!XAxiDma_ResetIsDone(&AxiDma));
            continue;
        }

        // 3. Poll until full 1024-point packet transfer completes
        uint32_t timeout = 5000000;
        while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA) && --timeout);

        if (timeout == 0) {
            printf("DMA Transfer Timeout! Resetting DMA engine...\r\n");
            XAxiDma_Reset(&AxiDma);
            while (!XAxiDma_ResetIsDone(&AxiDma));
            continue;
        }

        // 4. Invalidate cache again so Cortex-A9 reads the fresh DDR contents
        Xil_DCacheInvalidateRange((UINTPTR)rx_fft_buffer, DMA_BUFFER_SIZE);

        // 5. Compute peak magnitude & analyze spectrum
        process_and_display_spectrum(rx_fft_buffer, NUM_BINS);

        // 6. Tight throttle delay (~20-30 ms) to keep UART clean without causing FIFO overflow
        for (volatile uint32_t delay = 0; delay < 1000000; delay++);
    }

    cleanup_platform();
    return 0;
}