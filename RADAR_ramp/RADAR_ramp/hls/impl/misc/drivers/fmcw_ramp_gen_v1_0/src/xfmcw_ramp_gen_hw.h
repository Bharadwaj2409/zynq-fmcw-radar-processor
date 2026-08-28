// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// s_axi_control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of min_val
//        bit 13~0 - min_val[13:0] (Read/Write)
//        others   - reserved
// 0x14 : reserved
// 0x18 : Data signal of max_val
//        bit 13~0 - max_val[13:0] (Read/Write)
//        others   - reserved
// 0x1c : reserved
// 0x20 : Data signal of step_size
//        bit 13~0 - step_size[13:0] (Read/Write)
//        others   - reserved
// 0x24 : reserved
// 0x28 : Data signal of enable
//        bit 0  - enable[0] (Read/Write)
//        others - reserved
// 0x2c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL        0x00
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_GIE            0x04
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_IER            0x08
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_ISR            0x0c
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_MIN_VAL_DATA   0x10
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_BITS_MIN_VAL_DATA   14
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_MAX_VAL_DATA   0x18
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_BITS_MAX_VAL_DATA   14
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_STEP_SIZE_DATA 0x20
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_BITS_STEP_SIZE_DATA 14
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_ENABLE_DATA    0x28
#define XFMCW_RAMP_GEN_S_AXI_CONTROL_BITS_ENABLE_DATA    1

