// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xfmcw_ramp_gen.h"

extern XFmcw_ramp_gen_Config XFmcw_ramp_gen_ConfigTable[];

#ifdef SDT
XFmcw_ramp_gen_Config *XFmcw_ramp_gen_LookupConfig(UINTPTR BaseAddress) {
	XFmcw_ramp_gen_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XFmcw_ramp_gen_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XFmcw_ramp_gen_ConfigTable[Index].S_axi_control_BaseAddress == BaseAddress) {
			ConfigPtr = &XFmcw_ramp_gen_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XFmcw_ramp_gen_Initialize(XFmcw_ramp_gen *InstancePtr, UINTPTR BaseAddress) {
	XFmcw_ramp_gen_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XFmcw_ramp_gen_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XFmcw_ramp_gen_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XFmcw_ramp_gen_Config *XFmcw_ramp_gen_LookupConfig(u16 DeviceId) {
	XFmcw_ramp_gen_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XFMCW_RAMP_GEN_NUM_INSTANCES; Index++) {
		if (XFmcw_ramp_gen_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XFmcw_ramp_gen_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XFmcw_ramp_gen_Initialize(XFmcw_ramp_gen *InstancePtr, u16 DeviceId) {
	XFmcw_ramp_gen_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XFmcw_ramp_gen_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XFmcw_ramp_gen_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

