//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef FMCW_RAMP_GEN_SUBSYSTEM_MONITOR_SV
`define FMCW_RAMP_GEN_SUBSYSTEM_MONITOR_SV

`uvm_analysis_imp_decl(_svr_slave_sync_trigger)
`uvm_analysis_imp_decl(_svr_slave_dac_stream)
`uvm_analysis_imp_decl(_axi_wtr_s_axi_control)
`uvm_analysis_imp_decl(_axi_rtr_s_axi_control)

class fmcw_ramp_gen_subsystem_monitor extends uvm_component;

    fmcw_ramp_gen_reference_model refm;
    fmcw_ramp_gen_scoreboard scbd;

    `uvm_component_utils_begin(fmcw_ramp_gen_subsystem_monitor)
    `uvm_component_utils_end

    uvm_analysis_imp_svr_slave_sync_trigger#(svr_pkg::svr_transfer#(1), fmcw_ramp_gen_subsystem_monitor) svr_slave_sync_trigger_imp;
    uvm_analysis_imp_svr_slave_dac_stream#(svr_pkg::svr_transfer#(41), fmcw_ramp_gen_subsystem_monitor) svr_slave_dac_stream_imp;
    uvm_analysis_imp_axi_wtr_s_axi_control#(axi_pkg::axi_transfer, fmcw_ramp_gen_subsystem_monitor) s_axi_control_wtr_imp;
    uvm_analysis_imp_axi_rtr_s_axi_control#(axi_pkg::axi_transfer, fmcw_ramp_gen_subsystem_monitor) s_axi_control_rtr_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(fmcw_ramp_gen_reference_model)::get(this, "", "refm", refm))
            `uvm_fatal(this.get_full_name(), "No refm from high level")
        `uvm_info(this.get_full_name(), "get reference model by uvm_config_db", UVM_MEDIUM)
        scbd = fmcw_ramp_gen_scoreboard::type_id::create("scbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
        svr_slave_sync_trigger_imp = new("svr_slave_sync_trigger_imp", this);
        svr_slave_dac_stream_imp = new("svr_slave_dac_stream_imp", this);
        s_axi_control_wtr_imp = new("s_axi_control_wtr_imp", this);
        s_axi_control_rtr_imp = new("s_axi_control_rtr_imp", this);
    endfunction

    virtual function void write_svr_slave_sync_trigger(svr_transfer#(1) tr);
        refm.write_svr_slave_sync_trigger(tr);
        scbd.write_svr_slave_sync_trigger(tr);
    endfunction

    virtual function void write_svr_slave_dac_stream(svr_transfer#(41) tr);
        refm.write_svr_slave_dac_stream(tr);
        scbd.write_svr_slave_dac_stream(tr);
    endfunction

    virtual function void write_axi_wtr_s_axi_control(axi_transfer tr);
        refm.write_axi_wtr_s_axi_control(tr);
        scbd.write_axi_wtr_s_axi_control(tr);
    endfunction

    virtual function void write_axi_rtr_s_axi_control(axi_transfer tr);
        refm.write_axi_rtr_s_axi_control(tr);
        scbd.write_axi_rtr_s_axi_control(tr);
    endfunction
endclass
`endif
