//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`timescale 1ns/1ps 

`ifndef FMCW_RAMP_GEN_SUBSYSTEM_PKG__SV          
    `define FMCW_RAMP_GEN_SUBSYSTEM_PKG__SV      
                                                     
    package fmcw_ramp_gen_subsystem_pkg;               
                                                     
        import uvm_pkg::*;                           
        import file_agent_pkg::*;                    
        import svr_pkg::*;
        import axi_pkg::*;
                                                     
        `include "uvm_macros.svh"                  
                                                     
        `include "fmcw_ramp_gen_config.sv"           
        `include "fmcw_ramp_gen_reference_model.sv"  
        `include "fmcw_ramp_gen_scoreboard.sv"       
        `include "fmcw_ramp_gen_subsystem_monitor.sv"
        `include "fmcw_ramp_gen_virtual_sequencer.sv"
        `include "fmcw_ramp_gen_pkg_sequence_lib.sv" 
        `include "fmcw_ramp_gen_env.sv"              
                                                     
    endpackage                                       
                                                     
`endif                                               
