//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FMCW_RAMP_GEN_SCOREBOARD__SV                                                       
    `define FMCW_RAMP_GEN_SCOREBOARD__SV                                                   
                                                                                               
    `define AUTOTB_TVOUT_sync_trigger_sync_trigger_wrapc  "../tv/rtldatafile/rtl.fmcw_ramp_gen.autotvout_sync_trigger.dat"
    `define AUTOTB_TVOUT_dac_stream_dac_stream_TDATA_wrapc  "../tv/rtldatafile/rtl.fmcw_ramp_gen.autotvout_dac_stream_V_data_V.dat"
    `define AUTOTB_TVOUT_dac_stream_dac_stream_TKEEP_wrapc  "../tv/rtldatafile/rtl.fmcw_ramp_gen.autotvout_dac_stream_V_keep_V.dat"
    `define AUTOTB_TVOUT_dac_stream_dac_stream_TSTRB_wrapc  "../tv/rtldatafile/rtl.fmcw_ramp_gen.autotvout_dac_stream_V_strb_V.dat"
    `define AUTOTB_TVOUT_dac_stream_dac_stream_TLAST_wrapc  "../tv/rtldatafile/rtl.fmcw_ramp_gen.autotvout_dac_stream_V_last_V.dat"
    `define STREAM_SIZE_OUT_dac_stream_dac_stream_TDATA  "../tv/stream_size/stream_size_out_dac_stream_V_data_V.dat"
    `define STREAM_SIZE_OUT_dac_stream_dac_stream_TKEEP  "../tv/stream_size/stream_size_out_dac_stream_V_keep_V.dat"
    `define STREAM_SIZE_OUT_dac_stream_dac_stream_TSTRB  "../tv/stream_size/stream_size_out_dac_stream_V_strb_V.dat"
    `define STREAM_SIZE_OUT_dac_stream_dac_stream_TLAST  "../tv/stream_size/stream_size_out_dac_stream_V_last_V.dat"
                                                                                               
    class fmcw_ramp_gen_scoreboard extends uvm_component;                                        
                                                                                               
        fmcw_ramp_gen_reference_model refm;                                                      
                                                                                               
        typedef integer TRANS_SIZE_QUEUE_TYPE [$];                                      
        TRANS_SIZE_QUEUE_TYPE TVOUT_transaction_size_queue;                                
        int write_file_done_sync_trigger_sync_trigger;                                                          
        int write_file_done_dac_stream_dac_stream_TDATA;                                                          
        int write_file_done_dac_stream_dac_stream_TKEEP;                                                          
        int write_file_done_dac_stream_dac_stream_TSTRB;                                                          
        int write_file_done_dac_stream_dac_stream_TLAST;                                                          
        int write_section_done_sync_trigger_sync_trigger = 0;                                                   
        int write_section_done_dac_stream_dac_stream_TDATA = 0;                                                   
        int write_section_done_dac_stream_dac_stream_TKEEP = 0;                                                   
        int write_section_done_dac_stream_dac_stream_TSTRB = 0;                                                   
        int write_section_done_dac_stream_dac_stream_TLAST = 0;                                                   
                                                                                           
        file_agent_pkg::file_read_agent#(32) file_rd_TVOUT_transaction_size;               
                                                                                           
        file_agent_pkg::file_write_agent#(1) file_wr_port_sync_trigger_sync_trigger;
        file_agent_pkg::file_write_agent#(32) file_wr_port_dac_stream_dac_stream_TDATA;
        file_agent_pkg::file_write_agent#(4) file_wr_port_dac_stream_dac_stream_TKEEP;
        file_agent_pkg::file_write_agent#(4) file_wr_port_dac_stream_dac_stream_TSTRB;
        file_agent_pkg::file_write_agent#(1) file_wr_port_dac_stream_dac_stream_TLAST;
                                                                                               
        `uvm_component_utils_begin(fmcw_ramp_gen_scoreboard)                                     
        `uvm_field_object(refm  , UVM_DEFAULT)                                                 
        `uvm_field_object(file_rd_TVOUT_transaction_size, UVM_DEFAULT)
        `uvm_field_queue_int(TVOUT_transaction_size_queue, UVM_DEFAULT)                    
        `uvm_field_object(file_wr_port_sync_trigger_sync_trigger, UVM_DEFAULT)
        `uvm_field_int(write_file_done_sync_trigger_sync_trigger, UVM_DEFAULT)
        `uvm_field_int(write_section_done_sync_trigger_sync_trigger, UVM_DEFAULT)
        `uvm_field_object(file_wr_port_dac_stream_dac_stream_TDATA, UVM_DEFAULT)
        `uvm_field_int(write_file_done_dac_stream_dac_stream_TDATA, UVM_DEFAULT)
        `uvm_field_int(write_section_done_dac_stream_dac_stream_TDATA, UVM_DEFAULT)
        `uvm_field_object(file_wr_port_dac_stream_dac_stream_TKEEP, UVM_DEFAULT)
        `uvm_field_int(write_file_done_dac_stream_dac_stream_TKEEP, UVM_DEFAULT)
        `uvm_field_int(write_section_done_dac_stream_dac_stream_TKEEP, UVM_DEFAULT)
        `uvm_field_object(file_wr_port_dac_stream_dac_stream_TSTRB, UVM_DEFAULT)
        `uvm_field_int(write_file_done_dac_stream_dac_stream_TSTRB, UVM_DEFAULT)
        `uvm_field_int(write_section_done_dac_stream_dac_stream_TSTRB, UVM_DEFAULT)
        `uvm_field_object(file_wr_port_dac_stream_dac_stream_TLAST, UVM_DEFAULT)
        `uvm_field_int(write_file_done_dac_stream_dac_stream_TLAST, UVM_DEFAULT)
        `uvm_field_int(write_section_done_dac_stream_dac_stream_TLAST, UVM_DEFAULT)
        `uvm_component_utils_end                                                               
                                                                                               
        virtual function void build_phase(uvm_phase phase);                                    
            if (!uvm_config_db #(fmcw_ramp_gen_reference_model)::get(this, "", "refm", refm))
                `uvm_fatal(this.get_full_name(), "No refm from high level")                  
            `uvm_info(this.get_full_name(), "get reference model by uvm_config_db", UVM_MEDIUM) 
            file_rd_TVOUT_transaction_size = file_agent_pkg::file_read_agent#(32)::type_id::create("file_rd_TVOUT_transaction_size", this);
                                                                                               
            file_wr_port_sync_trigger_sync_trigger = file_agent_pkg::file_write_agent#(1)::type_id::create("file_wr_port_sync_trigger_sync_trigger", this);
            file_wr_port_dac_stream_dac_stream_TDATA = file_agent_pkg::file_write_agent#(32)::type_id::create("file_wr_port_dac_stream_dac_stream_TDATA", this);
            file_wr_port_dac_stream_dac_stream_TKEEP = file_agent_pkg::file_write_agent#(4)::type_id::create("file_wr_port_dac_stream_dac_stream_TKEEP", this);
            file_wr_port_dac_stream_dac_stream_TSTRB = file_agent_pkg::file_write_agent#(4)::type_id::create("file_wr_port_dac_stream_dac_stream_TSTRB", this);
            file_wr_port_dac_stream_dac_stream_TLAST = file_agent_pkg::file_write_agent#(1)::type_id::create("file_wr_port_dac_stream_dac_stream_TLAST", this);
        endfunction                                                                            
                                                                                               
        function new (string name = "", uvm_component parent = null);                        
            super.new(name, parent);                                                           
            write_file_done_sync_trigger_sync_trigger = 0;                                                          
            write_file_done_dac_stream_dac_stream_TDATA = 0;                                                          
            write_file_done_dac_stream_dac_stream_TKEEP = 0;                                                          
            write_file_done_dac_stream_dac_stream_TSTRB = 0;                                                          
            write_file_done_dac_stream_dac_stream_TLAST = 0;                                                          
        endfunction                                                                            
                                                                                               
        virtual task run_phase(uvm_phase phase);                                               
            create_TVOUT_transaction_size_queue_by_depth(1);
            file_wr_port_sync_trigger_sync_trigger.config_file(   
                    `AUTOTB_TVOUT_sync_trigger_sync_trigger_wrapc,
                    TVOUT_transaction_size_queue                            
                );                                                          
                                                                            
            create_TVOUT_transaction_size_queue_by_file(`STREAM_SIZE_OUT_dac_stream_dac_stream_TDATA);
            file_wr_port_dac_stream_dac_stream_TDATA.config_file(   
                    `AUTOTB_TVOUT_dac_stream_dac_stream_TDATA_wrapc,
                    TVOUT_transaction_size_queue                            
                );                                                          
                                                                            
            create_TVOUT_transaction_size_queue_by_file(`STREAM_SIZE_OUT_dac_stream_dac_stream_TKEEP);
            file_wr_port_dac_stream_dac_stream_TKEEP.config_file(   
                    `AUTOTB_TVOUT_dac_stream_dac_stream_TKEEP_wrapc,
                    TVOUT_transaction_size_queue                            
                );                                                          
                                                                            
            create_TVOUT_transaction_size_queue_by_file(`STREAM_SIZE_OUT_dac_stream_dac_stream_TSTRB);
            file_wr_port_dac_stream_dac_stream_TSTRB.config_file(   
                    `AUTOTB_TVOUT_dac_stream_dac_stream_TSTRB_wrapc,
                    TVOUT_transaction_size_queue                            
                );                                                          
                                                                            
            create_TVOUT_transaction_size_queue_by_file(`STREAM_SIZE_OUT_dac_stream_dac_stream_TLAST);
            file_wr_port_dac_stream_dac_stream_TLAST.config_file(   
                    `AUTOTB_TVOUT_dac_stream_dac_stream_TLAST_wrapc,
                    TVOUT_transaction_size_queue                            
                );                                                          
                                                                            

            fork                                                                               
                forever begin
                    @refm.allaxilite_write_data_finish;
                    `uvm_info(this.get_full_name(), "receive allaxilite_write_finish axilite write_mem_page_process", UVM_LOW)
                    void'(refm.mem_blk_pages_s_axi_control_min_val.pages.pop_front());
                    void'(refm.mem_blk_pages_s_axi_control_max_val.pages.pop_front());
                    void'(refm.mem_blk_pages_s_axi_control_step_size.pages.pop_front());
                    void'(refm.mem_blk_pages_s_axi_control_enable.pages.pop_front());
                end
                                                                                               
                forever begin
                    @refm.dut2tb_ap_done;
                    `uvm_info(this.get_full_name(), "receive dut2tb_ap_done and do axim dump", UVM_LOW)
                    file_wr_port_sync_trigger_sync_trigger.receive_ap_done();
                    file_wr_port_dac_stream_dac_stream_TDATA.receive_ap_done();
                    file_wr_port_dac_stream_dac_stream_TKEEP.receive_ap_done();
                    file_wr_port_dac_stream_dac_stream_TSTRB.receive_ap_done();
                    file_wr_port_dac_stream_dac_stream_TLAST.receive_ap_done();
                end                                                                            
                begin                                                                          
                    @refm.finish;                                                              
                    `uvm_info(this.get_full_name(), "receive FINISH", UVM_LOW)               
                    file_wr_port_sync_trigger_sync_trigger.wait_write_file_done();
                    file_wr_port_dac_stream_dac_stream_TDATA.wait_write_file_done();
                    file_wr_port_dac_stream_dac_stream_TKEEP.wait_write_file_done();
                    file_wr_port_dac_stream_dac_stream_TSTRB.wait_write_file_done();
                    file_wr_port_dac_stream_dac_stream_TLAST.wait_write_file_done();
                end                                                                            
                begin                                                                      
                    forever begin                                                              
                        wait(write_section_done_sync_trigger_sync_trigger && write_section_done_dac_stream_dac_stream_TDATA && write_section_done_dac_stream_dac_stream_TKEEP && write_section_done_dac_stream_dac_stream_TSTRB && write_section_done_dac_stream_dac_stream_TLAST);                          
                        write_section_done_sync_trigger_sync_trigger = 0;                                               
                        write_section_done_dac_stream_dac_stream_TDATA = 0;                                               
                        write_section_done_dac_stream_dac_stream_TKEEP = 0;                                               
                        write_section_done_dac_stream_dac_stream_TSTRB = 0;                                               
                        write_section_done_dac_stream_dac_stream_TLAST = 0;                                               
                        -> refm.allsvr_output_done;                                         
                    end                                                                        
                end                                                                        
            join                                                                               
        endtask                                                                                
                                                                                               
        virtual function void create_TVOUT_transaction_size_queue_by_depth(integer depth); 
            integer i;                                                                     
            TVOUT_transaction_size_queue.delete();                                         
            for (i = 0; i < 100; i++)                                    
                TVOUT_transaction_size_queue.push_back(depth);                             
        endfunction                                                                        
                                                                                           
         virtual function void create_TVOUT_transaction_size_queue_by_file(string TVOUT_file); 
             typedef bit [31: 0] DATA_QUEUE_TYPE [$];                                     
             DATA_QUEUE_TYPE TV_Queue [$];                                                  
             DATA_QUEUE_TYPE TV;                                                               
             string file_queue [$];                                                         
             integer bitwidth_queue [$];                                                    
             file_queue.push_back(TVOUT_file);                                                 
             bitwidth_queue.push_back(32);                                                     
                                                                                               
             file_rd_TVOUT_transaction_size.config_file(                                       
                 file_queue,                                                                   
                 bitwidth_queue                                                                
             );                                                                                
                                                                                               
             file_rd_TVOUT_transaction_size.read_TVIN_file();                                  
                                                                                               
             TV_Queue = file_rd_TVOUT_transaction_size.TV_Queue;                               
             TVOUT_transaction_size_queue.delete();                                            
             while (TV_Queue.size() > 0) begin                                                 
                 TV = TV_Queue.pop_front();                                                    
                 if (TV.size() != 1)                                                           
                         `uvm_fatal(this.get_full_name(), $sformatf("number of each transaction size should be 1, read %0d in file %0s   ", TV.size(), TVOUT_file))
                 `uvm_info(this.get_full_name(), $sformatf("get transaction size %0d", TV[0]), UVM_MEDIUM)
                 TVOUT_transaction_size_queue.push_back(TV.pop_front());                       
             end                                                                               
         endfunction                                                                           
                                                                                               
        virtual function void write_svr_slave_sync_trigger(svr_transfer#(1) tr);
            `uvm_info(this.get_full_name(), "port sync_trigger collected one pkt", UVM_DEBUG);          
            file_wr_port_sync_trigger_sync_trigger.write_TVOUT_data(tr.data[0: 0]);
            write_file_done_sync_trigger_sync_trigger = file_wr_port_sync_trigger_sync_trigger.is_write_file_done();
            write_section_done_sync_trigger_sync_trigger = file_wr_port_sync_trigger_sync_trigger.is_write_section_done();
            if(write_section_done_sync_trigger_sync_trigger) 
                `uvm_info("sync_trigger rx data done", "signal name:sync_trigger", UVM_MEDIUM)
        endfunction
                   
        virtual function void write_svr_slave_dac_stream(svr_transfer#(41) tr);
            `uvm_info(this.get_full_name(), "port dac_stream collected one pkt", UVM_DEBUG);          
            file_wr_port_dac_stream_dac_stream_TDATA.write_TVOUT_data(tr.data[31: 0]);
            write_file_done_dac_stream_dac_stream_TDATA = file_wr_port_dac_stream_dac_stream_TDATA.is_write_file_done();
            write_section_done_dac_stream_dac_stream_TDATA = file_wr_port_dac_stream_dac_stream_TDATA.is_write_section_done();
            if(write_section_done_dac_stream_dac_stream_TDATA) 
                `uvm_info("dac_stream rx data done", "signal name:dac_stream_TDATA", UVM_MEDIUM)
            file_wr_port_dac_stream_dac_stream_TKEEP.write_TVOUT_data(tr.data[35: 32]);
            write_file_done_dac_stream_dac_stream_TKEEP = file_wr_port_dac_stream_dac_stream_TKEEP.is_write_file_done();
            write_section_done_dac_stream_dac_stream_TKEEP = file_wr_port_dac_stream_dac_stream_TKEEP.is_write_section_done();
            if(write_section_done_dac_stream_dac_stream_TKEEP) 
                `uvm_info("dac_stream rx data done", "signal name:dac_stream_TKEEP", UVM_MEDIUM)
            file_wr_port_dac_stream_dac_stream_TSTRB.write_TVOUT_data(tr.data[39: 36]);
            write_file_done_dac_stream_dac_stream_TSTRB = file_wr_port_dac_stream_dac_stream_TSTRB.is_write_file_done();
            write_section_done_dac_stream_dac_stream_TSTRB = file_wr_port_dac_stream_dac_stream_TSTRB.is_write_section_done();
            if(write_section_done_dac_stream_dac_stream_TSTRB) 
                `uvm_info("dac_stream rx data done", "signal name:dac_stream_TSTRB", UVM_MEDIUM)
            file_wr_port_dac_stream_dac_stream_TLAST.write_TVOUT_data(tr.data[40: 40]);
            write_file_done_dac_stream_dac_stream_TLAST = file_wr_port_dac_stream_dac_stream_TLAST.is_write_file_done();
            write_section_done_dac_stream_dac_stream_TLAST = file_wr_port_dac_stream_dac_stream_TLAST.is_write_section_done();
            if(write_section_done_dac_stream_dac_stream_TLAST) 
                `uvm_info("dac_stream rx data done", "signal name:dac_stream_TLAST", UVM_MEDIUM)
        endfunction
                   
        virtual function void write_axi_wtr_s_axi_control(axi_pkg::axi_transfer tr);
        endfunction

        virtual function void write_axi_rtr_s_axi_control(axi_pkg::axi_transfer tr);
        endfunction

    endclass                                                                                   
                                                                                               
`endif                                                                                         
