//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef SV_MODULE_TOP_SV
`define SV_MODULE_TOP_SV


`timescale 1ns/1ps


`include "uvm_macros.svh"
import uvm_pkg::*;
import file_agent_pkg::*;
import svr_pkg::*;
import fmcw_ramp_gen_subsystem_pkg::*;
`include "fmcw_ramp_gen_subsys_test_sequence_lib.sv"
`include "fmcw_ramp_gen_test_lib.sv"


module sv_module_top;


    misc_interface              misc_if ( .clock(apatb_fmcw_ramp_gen_top.AESL_clock), .reset(apatb_fmcw_ramp_gen_top.AESL_reset) );
    assign misc_if.dut2tb_ap_ready = apatb_fmcw_ramp_gen_top.AESL_inst_fmcw_ramp_gen.ap_ready;
    assign misc_if.dut2tb_ap_done_kernel = apatb_fmcw_ramp_gen_top.AESL_inst_fmcw_ramp_gen.ap_done;
    initial begin
        uvm_config_db #(virtual misc_interface)::set(null, "uvm_test_top.top_env.*", "misc_if", misc_if);
    end


    svr_if #(1)  svr_sync_trigger_if    (.clk  (apatb_fmcw_ramp_gen_top.AESL_clock), .rst(apatb_fmcw_ramp_gen_top.AESL_reset));
    assign svr_sync_trigger_if.data[0:0] = apatb_fmcw_ramp_gen_top.sync_trigger;
    assign svr_sync_trigger_if.valid = misc_if.dut2tb_ap_done;
    assign svr_sync_trigger_if.ready = misc_if.dut2tb_ap_done;
    initial begin
        uvm_config_db #( virtual svr_if#(1) )::set(null, "uvm_test_top.top_env.env_slave_svr_sync_trigger.*", "vif", svr_sync_trigger_if);
    end


    svr_if #(41)  svr_dac_stream_if    (.clk  (apatb_fmcw_ramp_gen_top.AESL_clock), .rst(apatb_fmcw_ramp_gen_top.AESL_reset));
    assign apatb_fmcw_ramp_gen_top.dac_stream_TREADY = svr_dac_stream_if.ready;
    assign svr_dac_stream_if.valid = apatb_fmcw_ramp_gen_top.dac_stream_TVALID;
    assign svr_dac_stream_if.data[31:0] = apatb_fmcw_ramp_gen_top.dac_stream_TDATA;
    assign svr_dac_stream_if.data[35:32] = apatb_fmcw_ramp_gen_top.dac_stream_TKEEP;
    assign svr_dac_stream_if.data[39:36] = apatb_fmcw_ramp_gen_top.dac_stream_TSTRB;
    assign svr_dac_stream_if.data[40:40] = apatb_fmcw_ramp_gen_top.dac_stream_TLAST;
    initial begin
        uvm_config_db #( virtual svr_if#(41) )::set(null, "uvm_test_top.top_env.env_slave_svr_dac_stream.*", "vif", svr_dac_stream_if);
    end


    axi_if #(6,4,4,3,1)  axi_s_axi_control_if (.clk  (apatb_fmcw_ramp_gen_top.AESL_clock), .rst(apatb_fmcw_ramp_gen_top.AESL_reset));
    assign apatb_fmcw_ramp_gen_top.s_axi_control_AWADDR = axi_s_axi_control_if.AWADDR;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_AWVALID = axi_s_axi_control_if.AWVALID;
    assign axi_s_axi_control_if.AWREADY = apatb_fmcw_ramp_gen_top.s_axi_control_AWREADY;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_WVALID = axi_s_axi_control_if.WVALID;
    assign axi_s_axi_control_if.WREADY = apatb_fmcw_ramp_gen_top.s_axi_control_WREADY;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_WDATA = axi_s_axi_control_if.WDATA;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_WSTRB = axi_s_axi_control_if.WSTRB;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_ARADDR = axi_s_axi_control_if.ARADDR;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_ARVALID = axi_s_axi_control_if.ARVALID;
    assign axi_s_axi_control_if.ARREADY = apatb_fmcw_ramp_gen_top.s_axi_control_ARREADY;
    assign axi_s_axi_control_if.RVALID = apatb_fmcw_ramp_gen_top.s_axi_control_RVALID;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_RREADY = axi_s_axi_control_if.RREADY;
    assign axi_s_axi_control_if.RDATA = apatb_fmcw_ramp_gen_top.s_axi_control_RDATA;
    assign axi_s_axi_control_if.RRESP = apatb_fmcw_ramp_gen_top.s_axi_control_RRESP;
    assign axi_s_axi_control_if.BVALID = apatb_fmcw_ramp_gen_top.s_axi_control_BVALID;
    assign apatb_fmcw_ramp_gen_top.s_axi_control_BREADY = axi_s_axi_control_if.BREADY;
    assign axi_s_axi_control_if.BRESP = apatb_fmcw_ramp_gen_top.s_axi_control_BRESP;
    assign axi_s_axi_control_if.BID = 0;
    assign axi_s_axi_control_if.RID = 0;
    assign axi_s_axi_control_if.RLAST = 1;
    initial begin
        uvm_config_db #( virtual axi_if#(6,4,4,3,1) )::set(null, "uvm_test_top.top_env.axi_lite_s_axi_control.*", "vif", axi_s_axi_control_if);
    end


    initial begin
        run_test();
    end
endmodule
`endif
