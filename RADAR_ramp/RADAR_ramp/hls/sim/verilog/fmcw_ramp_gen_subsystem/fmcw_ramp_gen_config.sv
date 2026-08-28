//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FMCW_RAMP_GEN_CONFIG__SV                        
    `define FMCW_RAMP_GEN_CONFIG__SV                    
                                                            
    class fmcw_ramp_gen_config extends uvm_object;            
                                                            
        int check_ena;                                      
        int cover_ena;                                      
        svr_pkg::svr_config port_sync_trigger_cfg;
        svr_pkg::svr_config port_dac_stream_cfg;
        axi_pkg::axi_cfg s_axi_control_cfg;

        `uvm_object_utils_begin(fmcw_ramp_gen_config)         
        `uvm_field_object(port_sync_trigger_cfg, UVM_DEFAULT)
        `uvm_field_object(port_dac_stream_cfg, UVM_DEFAULT)
        `uvm_field_object(s_axi_control_cfg, UVM_DEFAULT);
        `uvm_field_int   (check_ena , UVM_DEFAULT)          
        `uvm_field_int   (cover_ena , UVM_DEFAULT)          
        `uvm_object_utils_end                               

        function new (string name = "fmcw_ramp_gen_config");
            super.new(name);                                
            port_sync_trigger_cfg = svr_pkg::svr_config::type_id::create("port_sync_trigger_cfg");
            port_dac_stream_cfg = svr_pkg::svr_config::type_id::create("port_dac_stream_cfg");
            s_axi_control_cfg = axi_pkg::axi_cfg::type_id::create("s_axi_control_cfg");
        endfunction                                         
                                                            
    endclass                                                
                                                            
`endif                                                      
