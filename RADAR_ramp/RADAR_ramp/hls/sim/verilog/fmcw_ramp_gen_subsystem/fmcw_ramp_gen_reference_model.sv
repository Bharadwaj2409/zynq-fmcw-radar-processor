//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef FMCW_RAMP_GEN_REFERENCE_MODEL_SV
`define FMCW_RAMP_GEN_REFERENCE_MODEL_SV

class fmcw_ramp_gen_reference_model extends uvm_component;
`define TV_IN_min_val "../tv/cdatafile/c.fmcw_ramp_gen.autotvin_min_val.dat"
`define TV_OUT_min_val ""
`define TV_IN_max_val "../tv/cdatafile/c.fmcw_ramp_gen.autotvin_max_val.dat"
`define TV_OUT_max_val ""
`define TV_IN_step_size "../tv/cdatafile/c.fmcw_ramp_gen.autotvin_step_size.dat"
`define TV_OUT_step_size ""
`define TV_IN_enable "../tv/cdatafile/c.fmcw_ramp_gen.autotvin_enable.dat"
`define TV_OUT_enable ""
    bit  write_data_finish_s_axi_control;
    event allaxilite_write_data_finish;
    event allaxilite_write_one_transaction_finish;
    event allsvr_input_done;
    event allsvr_output_done;
    event write_start_finish;
    int trans_num_total = 100;
    int trans_num_idx;
    int ap_done_cnt=1;
    event dut2tb_ap_ready;
    event dut2tb_ap_done;
    event ap_ready_for_nexttrans;
    event ap_done_for_nexttrans;
    event finish;
    fmcw_ramp_gen_config fmcw_ramp_gen_cfg;
    virtual interface misc_interface misc_if;

    mem_model_pages#(14,8) mem_blk_pages_s_axi_control_min_val;
    mem_model_pages#(14,8) mem_blk_pages_s_axi_control_max_val;
    mem_model_pages#(14,8) mem_blk_pages_s_axi_control_step_size;
    mem_model_pages#(1,8) mem_blk_pages_s_axi_control_enable;
    int svr_dac_stream_delay;
    covergroup svr_dac_stream_cov;
        delay: coverpoint svr_dac_stream_delay
        {
            bins norm[2] = { [0 : 1] };
        }
    endgroup
    
    `uvm_component_utils_begin(fmcw_ramp_gen_reference_model)
        `uvm_field_int (trans_num_idx, UVM_DEFAULT)
    `uvm_component_utils_end

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual misc_interface)::get(this, "", "misc_if", misc_if))
            `uvm_fatal(this.get_full_name(), "No misc_if from high level")
    endfunction

    function new (string name = "", uvm_component parent = null);
        super.new (name, parent);
        svr_dac_stream_cov = new;
        trans_num_idx= 0;
    endfunction

    virtual task run_phase(uvm_phase phase);
        string fpath[$];
misc_if.dut2tb_ap_done = 0;

        fpath.push_back(`TV_IN_min_val);
        mem_blk_pages_s_axi_control_min_val = mem_model_pages#(14,8)::type_id::create("mem_blk_pages_s_axi_control_min_val");
        mem_blk_pages_s_axi_control_min_val.tvinload_pagechk_atinit(fpath, 1*((16+7)/8), 0, 16);
        fpath.delete;


        fpath.push_back(`TV_IN_max_val);
        mem_blk_pages_s_axi_control_max_val = mem_model_pages#(14,8)::type_id::create("mem_blk_pages_s_axi_control_max_val");
        mem_blk_pages_s_axi_control_max_val.tvinload_pagechk_atinit(fpath, 1*((16+7)/8), 0, 24);
        fpath.delete;


        fpath.push_back(`TV_IN_step_size);
        mem_blk_pages_s_axi_control_step_size = mem_model_pages#(14,8)::type_id::create("mem_blk_pages_s_axi_control_step_size");
        mem_blk_pages_s_axi_control_step_size.tvinload_pagechk_atinit(fpath, 1*((16+7)/8), 0, 32);
        fpath.delete;


        fpath.push_back(`TV_IN_enable);
        mem_blk_pages_s_axi_control_enable = mem_model_pages#(1,8)::type_id::create("mem_blk_pages_s_axi_control_enable");
        mem_blk_pages_s_axi_control_enable.tvinload_pagechk_atinit(fpath, 1*((1+7)/8), 0, 40);
        fpath.delete;

        fork
            forever begin
                wait(write_data_finish_s_axi_control);
                `uvm_info("", "trigger_allaxilite_data_write_finish", UVM_LOW)
                @(posedge misc_if.clock);
                write_data_finish_s_axi_control = 0;
                -> allaxilite_write_data_finish;
            end
            forever begin
                //this is non-pipeline case
                forever begin
                    @(negedge misc_if.clock);
                    if(misc_if.dut2tb_ap_done===1) break;
                end
                @(posedge misc_if.clock);
                @allaxilite_write_data_finish;
                @(posedge misc_if.clock);
                -> ap_ready_for_nexttrans;
                `uvm_info(this.get_full_name(), "trigger event ap_ready_for_nexttrans", UVM_LOW)
                fork
                    begin
                        misc_if.ap_ready_for_nexttrans = 1;
                        @(posedge misc_if.clock);
                        misc_if.ap_ready_for_nexttrans = 0;
                    end
                join_none
            end
            forever begin
                forever begin
                    @(negedge misc_if.clock);
                    if(misc_if.dut2tb_ap_done===1) break;
                end
                @(posedge misc_if.clock);
                fork
                    begin
                        @(negedge misc_if.clock);
                        -> misc_if.dut2tb_ap_done_evt;
                        #0;
                        -> misc_if.dut2tb_ap_ready_evt;
                    end
                join_none
                -> ap_done_for_nexttrans;
                `uvm_info(this.get_full_name(), "trigger event ap_done_for_nexttrans", UVM_LOW)
                fork
                    begin
                        misc_if.ap_done_for_nexttrans = 1;
                        @(posedge misc_if.clock);
                        misc_if.ap_done_for_nexttrans = 0;
                    end
                join_none
            end

            forever begin
                forever begin
                    @(negedge misc_if.clock);
                    if (misc_if.dut2tb_ap_ready === 1)   break;
                end
                @(posedge misc_if.clock);
                `uvm_info(this.get_full_name(), "trigger event DUT2TB_AP_READY", UVM_LOW)
                -> dut2tb_ap_ready;
                 misc_if.tb2dut_ap_start = 0;
            end
            forever begin
                forever begin
                    @(negedge misc_if.clock);
                    if (misc_if.dut2tb_ap_done_kernel === 1)   break;
                end
                @(posedge misc_if.clock);
                fork
                    begin
                        @(negedge misc_if.clock);
                        `uvm_info(this.get_full_name(), "trigger event dut2tb_ap_done_kernel_evt", UVM_LOW)
                        -> misc_if.dut2tb_ap_done_kernel_evt;
                    end
                join_none
            end
        join
    endtask

    virtual function void write_svr_slave_sync_trigger(svr_transfer#(1) tr);
    //  trans_size++;
        `uvm_info(this.get_full_name(), "port a collected one pkt", UVM_DEBUG);
    endfunction

    virtual function void write_svr_slave_dac_stream(svr_transfer#(41) tr);
    //  trans_size++;
        svr_dac_stream_delay = tr.delay;
        svr_dac_stream_cov.sample();
        `uvm_info(this.get_full_name(), "port a collected one pkt", UVM_DEBUG);
    endfunction

    virtual function void write_axi_wtr_s_axi_control(axi_pkg::axi_transfer tr);
        if(tr.addr == 0 && tr.len == 0 && tr.data[0][0]==1) begin //addr 0 and bit 0 are parameter
            -> write_start_finish;
            misc_if.tb2dut_ap_start = 1;
        end
    endfunction
    virtual function void write_axi_rtr_s_axi_control(axi_pkg::axi_transfer tr);
            `uvm_info("receive axi read data", tr.sprint(), UVM_HIGH)
        if(tr.addr == 0 && tr.len == 0) begin
            if(tr.data[0][1]==1) begin  //bit 1 is parameter
                `uvm_info("status polling", "ap_done is polled", UVM_LOW);
                fork
                    begin
                        misc_if.dut2tb_ap_done = 1;
                        @(posedge misc_if.clock);
                        #0;
                        misc_if.dut2tb_ap_done = 0;
                        misc_if.tb2dut_ap_continue = 0;
                        -> dut2tb_ap_done;
                    end
                join_none
            end
            begin
                misc_if.dut2tb_ap_idle = tr.data[0][2];
            end
        end else begin
        end
    endfunction
endclass
`endif
