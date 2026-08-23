FPGA FMCW Radar Signal Processing Engine

A real-time, hardware-accelerated FMCW (Frequency-Modulated Continuous Wave) radar signal processing pipeline built on the Digilent Eclypse Z7 (AMD Zynq-7020 SoC).

This project implements a heterogeneous architecture to process radar data: the FPGA fabric handles high-throughput 1D Range FFTs in real time, while the ARM Cortex-A9 processor manages DMA transfers, slow-time Doppler processing, and data streaming.
Overview

FMCW radar signal processing requires fast Fourier transforms on incoming beat frequencies (fast-time) across multiple chirps, followed by a second FFT across the chirps (slow-time) to generate a Range-Doppler map.

To prevent the processor from bottlenecking at high sampling rates, the fast-time Range FFT runs directly in programmable logic (PL). The resulting spectral frames are pushed into DDR3 memory using AXI DMA, allowing the processing system (PS) to perform Doppler extraction and downstream analytics.
Technical Highlights

    ADC Ingestion: Digilent Zmod Scope (SYZYGY) acquiring 14-bit samples at 40 MSPS.

    FPGA DSP Pipeline:

        1024-point pipelined streaming FFT (xfft_range) running synchronously at 40 MHz.

        Custom AXI4-Stream data formatting and scaling to prevent overflow.

        Asynchronous AXI Stream FIFO bridging the 40 MHz DSP clock domain to the 100 MHz AXI interconnect.

    Memory Architecture: AXI DMA (Direct Register Mode) streaming Range FFT frames directly into DDR memory through the Zynq High-Performance (HP0) port.

    Firmware & Cache Management: Baremetal C driver running on ARM Cortex-A9 managing DMA buffer descriptors, cache line flushes/invalidations (Xil_DCacheInvalidateRange), and spectral peak detection.

Hardware & Tools

    Board: Digilent Eclypse Z7 (XC7Z020CLG484-1)

    Expansion: Digilent Zmod Scope 1410-105

    EDA Tools: AMD Vivado Design Suite 2025.2 / 2026.x

    Software: AMD Vitis Unified IDE

Project Structure

    hw/ - Vivado Block Design reconstruction scripts (design_1.tcl), timing constraints, and Digilent IP repos.

    sw/ - Vitis application source code (main.c, platform.c, CMakeLists.txt) for DMA handling and FFT analytics.

    scripts/ - Host-side Python utilities for serial logging and Range-Doppler visualization.

How to Build and Run
1. Generate Hardware in Vivado

    Clone the repository:
    Bash

    git clone https://github.com/Bharadwaj2409/FPGA-FMCW-RADAR-DSP-Acceleration.git
    cd FPGA-FMCW-RADAR-DSP-Acceleration

    In the Vivado TCL console, run:
    Tcl

    source hw/design_1.tcl

    Generate the top-level wrapper, run synthesis/implementation, and generate the bitstream.

    Export the hardware platform as .xsa (include bitstream).

2. Build and Run Firmware in Vitis

    Open Vitis and create a platform component using your exported .xsa.

    Create an application component targeting standalone_ps7_cortexa9_0 using the files in sw/.

    In CMakeLists.txt, ensure standard math libraries are linked:
    CMake

    target_link_libraries(hello_world.elf PRIVATE -lm)

    Build the application and program the board over JTAG/USB.

    Open a serial terminal at 115200 baud to view real-time FFT output and peak detection logs.
