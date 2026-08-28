//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FMCW_RAMP_GEN_ENV__SV                                                                                   
    `define FMCW_RAMP_GEN_ENV__SV                                                                               
                                                                                                                    
                                                                                                                    
    class fmcw_ramp_gen_env extends uvm_env;                                                                          
                                                                                                                    
        fmcw_ramp_gen_virtual_sequencer fmcw_ramp_gen_virtual_sqr;                                                      
        fmcw_ramp_gen_config fmcw_ramp_gen_cfg;                                                                         
                                                                                                                    
        svr_pkg::svr_env#(1) env_slave_svr_sync_trigger;
        svr_pkg::svr_env#(41) env_slave_svr_dac_stream;
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_s_axi_control;
                                                                                                                    
        fmcw_ramp_gen_reference_model   refm;                                                                         
                                                                                                                    
        fmcw_ramp_gen_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(fmcw_ramp_gen_env)                                                                 
        `uvm_field_object (env_slave_svr_sync_trigger,  UVM_DEFAULT | UVM_REFERENCE)
        `uvm_field_object (env_slave_svr_dac_stream,  UVM_DEFAULT | UVM_REFERENCE)
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (fmcw_ramp_gen_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (fmcw_ramp_gen_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "fmcw_ramp_gen_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void fmcw_ramp_gen_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        fmcw_ramp_gen_cfg = fmcw_ramp_gen_config::type_id::create("fmcw_ramp_gen_cfg", this);                           
                                                                                                                    
        fmcw_ramp_gen_cfg.port_sync_trigger_cfg.svr_type = svr_pkg::SVR_SLAVE ;
        env_slave_svr_sync_trigger  = svr_env#(1)::type_id::create("env_slave_svr_sync_trigger", this);
        uvm_config_db#(svr_pkg::svr_config)::set(this, "env_slave_svr_sync_trigger*", "cfg", fmcw_ramp_gen_cfg.port_sync_trigger_cfg);
        fmcw_ramp_gen_cfg.port_sync_trigger_cfg.prt_type = svr_pkg::AP_NONE;
        fmcw_ramp_gen_cfg.port_sync_trigger_cfg.is_active = svr_pkg::SVR_ACTIVE;
        fmcw_ramp_gen_cfg.port_sync_trigger_cfg.spec_cfg = svr_pkg::NORMAL;
        fmcw_ramp_gen_cfg.port_sync_trigger_cfg.reset_level = svr_pkg::RESET_LEVEL_LOW;
 
        fmcw_ramp_gen_cfg.port_dac_stream_cfg.svr_type = svr_pkg::SVR_SLAVE ;
        env_slave_svr_dac_stream  = svr_env#(41)::type_id::create("env_slave_svr_dac_stream", this);
        uvm_config_db#(svr_pkg::svr_config)::set(this, "env_slave_svr_dac_stream*", "cfg", fmcw_ramp_gen_cfg.port_dac_stream_cfg);
        fmcw_ramp_gen_cfg.port_dac_stream_cfg.prt_type = svr_pkg::AXIS;
        fmcw_ramp_gen_cfg.port_dac_stream_cfg.is_active = svr_pkg::SVR_ACTIVE;
        fmcw_ramp_gen_cfg.port_dac_stream_cfg.spec_cfg = svr_pkg::NORMAL;
        fmcw_ramp_gen_cfg.port_dac_stream_cfg.reset_level = svr_pkg::RESET_LEVEL_LOW;
 

        fmcw_ramp_gen_cfg.s_axi_control_cfg.set_default();
        fmcw_ramp_gen_cfg.s_axi_control_cfg.drv_type = axi_pkg::MASTER;
        fmcw_ramp_gen_cfg.s_axi_control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_s_axi_control*", "cfg", fmcw_ramp_gen_cfg.s_axi_control_cfg);
        axi_lite_s_axi_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_s_axi_control", this);



        refm = fmcw_ramp_gen_reference_model::type_id::create("refm", this);


        uvm_config_db#(fmcw_ramp_gen_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = fmcw_ramp_gen_subsystem_monitor::type_id::create("subsys_mon", this);


        fmcw_ramp_gen_virtual_sqr = fmcw_ramp_gen_virtual_sequencer::type_id::create("fmcw_ramp_gen_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void fmcw_ramp_gen_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        fmcw_ramp_gen_virtual_sqr.svr_port_sync_trigger_sqr = env_slave_svr_sync_trigger.s_agt.sqr;
        env_slave_svr_sync_trigger.s_agt.mon.item_collect_port.connect(subsys_mon.svr_slave_sync_trigger_imp);
 
        fmcw_ramp_gen_virtual_sqr.svr_port_dac_stream_sqr = env_slave_svr_dac_stream.s_agt.sqr;
        env_slave_svr_dac_stream.s_agt.mon.item_collect_port.connect(subsys_mon.svr_slave_dac_stream_imp);
 
        if(fmcw_ramp_gen_cfg.s_axi_control_cfg.drv_type==axi_pkg::MASTER ||fmcw_ramp_gen_cfg.s_axi_control_cfg.drv_type==axi_pkg::SLAVE)
            fmcw_ramp_gen_virtual_sqr.s_axi_control_sqr = axi_lite_s_axi_control.vsqr;
        axi_lite_s_axi_control.item_wtr_port.connect(subsys_mon.s_axi_control_wtr_imp);
        axi_lite_s_axi_control.item_rtr_port.connect(subsys_mon.s_axi_control_rtr_imp);
        refm.fmcw_ramp_gen_cfg = fmcw_ramp_gen_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task fmcw_ramp_gen_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "fmcw_ramp_gen_env is running", UVM_LOW)
    endtask


`endif
