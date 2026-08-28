// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xfmcw_ramp_gen.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XFmcw_ramp_gen_CfgInitialize(XFmcw_ramp_gen *InstancePtr, XFmcw_ramp_gen_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->S_axi_control_BaseAddress = ConfigPtr->S_axi_control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XFmcw_ramp_gen_Start(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL) & 0x80;
    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XFmcw_ramp_gen_IsDone(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XFmcw_ramp_gen_IsIdle(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XFmcw_ramp_gen_IsReady(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XFmcw_ramp_gen_EnableAutoRestart(XFmcw_ramp_gen *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XFmcw_ramp_gen_DisableAutoRestart(XFmcw_ramp_gen *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_AP_CTRL, 0);
}

void XFmcw_ramp_gen_Set_min_val(XFmcw_ramp_gen *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_MIN_VAL_DATA, Data);
}

u32 XFmcw_ramp_gen_Get_min_val(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_MIN_VAL_DATA);
    return Data;
}

void XFmcw_ramp_gen_Set_max_val(XFmcw_ramp_gen *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_MAX_VAL_DATA, Data);
}

u32 XFmcw_ramp_gen_Get_max_val(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_MAX_VAL_DATA);
    return Data;
}

void XFmcw_ramp_gen_Set_step_size(XFmcw_ramp_gen *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_STEP_SIZE_DATA, Data);
}

u32 XFmcw_ramp_gen_Get_step_size(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_STEP_SIZE_DATA);
    return Data;
}

void XFmcw_ramp_gen_Set_enable(XFmcw_ramp_gen *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_ENABLE_DATA, Data);
}

u32 XFmcw_ramp_gen_Get_enable(XFmcw_ramp_gen *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_ENABLE_DATA);
    return Data;
}

void XFmcw_ramp_gen_InterruptGlobalEnable(XFmcw_ramp_gen *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_GIE, 1);
}

void XFmcw_ramp_gen_InterruptGlobalDisable(XFmcw_ramp_gen *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_GIE, 0);
}

void XFmcw_ramp_gen_InterruptEnable(XFmcw_ramp_gen *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_IER);
    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_IER, Register | Mask);
}

void XFmcw_ramp_gen_InterruptDisable(XFmcw_ramp_gen *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_IER);
    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_IER, Register & (~Mask));
}

void XFmcw_ramp_gen_InterruptClear(XFmcw_ramp_gen *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFmcw_ramp_gen_WriteReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_ISR, Mask);
}

u32 XFmcw_ramp_gen_InterruptGetEnabled(XFmcw_ramp_gen *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_IER);
}

u32 XFmcw_ramp_gen_InterruptGetStatus(XFmcw_ramp_gen *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XFmcw_ramp_gen_ReadReg(InstancePtr->S_axi_control_BaseAddress, XFMCW_RAMP_GEN_S_AXI_CONTROL_ADDR_ISR);
}

