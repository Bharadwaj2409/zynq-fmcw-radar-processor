//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FMCW_RAMP_GEN_VIRTUAL_SEQUENCER__SV                        
    `define FMCW_RAMP_GEN_VIRTUAL_SEQUENCER__SV                    
                                                                       
    class fmcw_ramp_gen_virtual_sequencer extends uvm_sequencer;         
        svr_slave_sequencer#(1) svr_port_sync_trigger_sqr;
        svr_slave_sequencer#(41) svr_port_dac_stream_sqr;
        axi_pkg::axi_virtual_sequencer s_axi_control_sqr; 
 
        function new (string name, uvm_component parent);              
            super.new(name, parent);                                   
            //`uvm_info(this.get_full_name(), "new is called", UVM_LOW)
        endfunction                                                    
                                                                       
        `uvm_component_utils_begin(fmcw_ramp_gen_virtual_sequencer)      
        `uvm_component_utils_end                                       
                                                                       
    endclass

`endif
