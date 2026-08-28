// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XFMCW_RAMP_GEN_H
#define XFMCW_RAMP_GEN_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xfmcw_ramp_gen_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 S_axi_control_BaseAddress;
} XFmcw_ramp_gen_Config;
#endif

typedef struct {
    u64 S_axi_control_BaseAddress;
    u32 IsReady;
} XFmcw_ramp_gen;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XFmcw_ramp_gen_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XFmcw_ramp_gen_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XFmcw_ramp_gen_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XFmcw_ramp_gen_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XFmcw_ramp_gen_Initialize(XFmcw_ramp_gen *InstancePtr, UINTPTR BaseAddress);
XFmcw_ramp_gen_Config* XFmcw_ramp_gen_LookupConfig(UINTPTR BaseAddress);
#else
int XFmcw_ramp_gen_Initialize(XFmcw_ramp_gen *InstancePtr, u16 DeviceId);
XFmcw_ramp_gen_Config* XFmcw_ramp_gen_LookupConfig(u16 DeviceId);
#endif
int XFmcw_ramp_gen_CfgInitialize(XFmcw_ramp_gen *InstancePtr, XFmcw_ramp_gen_Config *ConfigPtr);
#else
int XFmcw_ramp_gen_Initialize(XFmcw_ramp_gen *InstancePtr, const char* InstanceName);
int XFmcw_ramp_gen_Release(XFmcw_ramp_gen *InstancePtr);
#endif

void XFmcw_ramp_gen_Start(XFmcw_ramp_gen *InstancePtr);
u32 XFmcw_ramp_gen_IsDone(XFmcw_ramp_gen *InstancePtr);
u32 XFmcw_ramp_gen_IsIdle(XFmcw_ramp_gen *InstancePtr);
u32 XFmcw_ramp_gen_IsReady(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_EnableAutoRestart(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_DisableAutoRestart(XFmcw_ramp_gen *InstancePtr);

void XFmcw_ramp_gen_Set_min_val(XFmcw_ramp_gen *InstancePtr, u32 Data);
u32 XFmcw_ramp_gen_Get_min_val(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_Set_max_val(XFmcw_ramp_gen *InstancePtr, u32 Data);
u32 XFmcw_ramp_gen_Get_max_val(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_Set_step_size(XFmcw_ramp_gen *InstancePtr, u32 Data);
u32 XFmcw_ramp_gen_Get_step_size(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_Set_enable(XFmcw_ramp_gen *InstancePtr, u32 Data);
u32 XFmcw_ramp_gen_Get_enable(XFmcw_ramp_gen *InstancePtr);

void XFmcw_ramp_gen_InterruptGlobalEnable(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_InterruptGlobalDisable(XFmcw_ramp_gen *InstancePtr);
void XFmcw_ramp_gen_InterruptEnable(XFmcw_ramp_gen *InstancePtr, u32 Mask);
void XFmcw_ramp_gen_InterruptDisable(XFmcw_ramp_gen *InstancePtr, u32 Mask);
void XFmcw_ramp_gen_InterruptClear(XFmcw_ramp_gen *InstancePtr, u32 Mask);
u32 XFmcw_ramp_gen_InterruptGetEnabled(XFmcw_ramp_gen *InstancePtr);
u32 XFmcw_ramp_gen_InterruptGetStatus(XFmcw_ramp_gen *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
