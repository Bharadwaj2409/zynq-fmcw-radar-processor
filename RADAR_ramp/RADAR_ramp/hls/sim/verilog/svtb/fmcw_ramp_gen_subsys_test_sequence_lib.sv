//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FMCW_RAMP_GEN_SUBSYS_TEST_SEQUENCE_LIB__SV                                              
    `define FMCW_RAMP_GEN_SUBSYS_TEST_SEQUENCE_LIB__SV                                          
                                                                                                    
                                                                                                    
    `include "uvm_macros.svh"                                                                     
                                                                                                    
    class fmcw_ramp_gen_subsys_test_sequence_lib extends uvm_sequence;                                
                                                                                                    
        function new (string name = "fmcw_ramp_gen_subsys_test_sequence_lib");                      
            super.new(name);                                                                        
            `uvm_info(this.get_full_name(), "new is called", UVM_LOW)                             
        endfunction                                                                                 
                                                                                                    
        `uvm_object_utils(fmcw_ramp_gen_subsys_test_sequence_lib)                                     
        `uvm_declare_p_sequencer(fmcw_ramp_gen_virtual_sequencer)                                     
                                                                                                    
        virtual task body();                                                                        
            uvm_phase starting_phase;                                                               
            virtual interface misc_interface misc_if;                                               
            fmcw_ramp_gen_reference_model refm;                                                       
                                                                                                    
            svr_pkg::svr_slave_sequence #(1) svr_port_sync_trigger_seq;            

            svr_pkg::svr_slave_sequence #(41) svr_port_dac_stream_seq;            

            axi_pkg::axi_busdatas_master_sequence#(6, 32) axi_master_wr_s_axi_control_seq;
            axi_pkg::axi_busdatas_master_sequence#(6, 32) axi_master_poll_s_axi_control_seq;

            if (!uvm_config_db#(fmcw_ramp_gen_reference_model)::get(p_sequencer,"", "refm", refm))
                `uvm_fatal(this.get_full_name(), "No reference model")
            `uvm_info(this.get_full_name(), "get reference model by uvm_config_db", UVM_LOW)

            `uvm_info(this.get_full_name(), "body is called", UVM_LOW)
            starting_phase = this.get_starting_phase();
            if (starting_phase != null) begin
                `uvm_info(this.get_full_name(), "starting_phase not null", UVM_LOW)
                starting_phase.raise_objection(this);
            end
            else
                `uvm_info(this.get_full_name(), "starting_phase null" , UVM_LOW)

            misc_if = refm.misc_if;


            //phase_done.set_drain_time(this, 0ns);
            wait(refm.misc_if.reset === 1);
            ->refm.misc_if.initialed_evt;

            fork
                begin
                    fork
                        begin
                            string keystr_delay;
                            `uvm_create_on(svr_port_sync_trigger_seq, p_sequencer.svr_port_sync_trigger_sqr);
                            svr_port_sync_trigger_seq.misc_if = refm.misc_if;
                            svr_port_sync_trigger_seq.ap_done  = refm.ap_done_for_nexttrans ;
                            svr_port_sync_trigger_seq.ap_ready = refm.ap_ready_for_nexttrans;
                            svr_port_sync_trigger_seq.finish   = refm.finish;
                            svr_port_sync_trigger_seq.isusr_delay = svr_pkg::NO_DELAY;
                            `uvm_send(svr_port_sync_trigger_seq);     
                        end                                               
                        begin
                            string keystr_delay;
                            `uvm_create_on(svr_port_dac_stream_seq, p_sequencer.svr_port_dac_stream_sqr);
                            svr_port_dac_stream_seq.misc_if = refm.misc_if;
                            svr_port_dac_stream_seq.ap_done  = refm.ap_done_for_nexttrans ;
                            svr_port_dac_stream_seq.ap_ready = refm.ap_ready_for_nexttrans;
                            svr_port_dac_stream_seq.finish   = refm.finish;
                            svr_port_dac_stream_seq.isusr_delay = svr_pkg::NO_DELAY;
                            `uvm_send(svr_port_dac_stream_seq);     
                        end                                               
                        begin
                            int s_axi_control_page_idx_bak;
                            `uvm_create_on(axi_master_wr_s_axi_control_seq, p_sequencer.s_axi_control_sqr);
                            axi_master_wr_s_axi_control_seq.misc_if = refm.misc_if;
                            axi_master_wr_s_axi_control_seq.ap_done    = refm.ap_done_for_nexttrans   ;
                            axi_master_wr_s_axi_control_seq.ap_ready   = refm.ap_ready_for_nexttrans  ;
                            axi_master_wr_s_axi_control_seq.finish     = refm.finish ;
                            axi_master_wr_s_axi_control_seq.isusr_delay = axi_pkg::NO_DELAY;
                            for(int i=0; i<100; i++) begin
                                logic[63:0] data64bit_min_val[$];
                                logic[32-1:0] databusbit_min_val[$];
                                logic[63:0] data64bit_max_val[$];
                                logic[32-1:0] databusbit_max_val[$];
                                logic[63:0] data64bit_step_size[$];
                                logic[32-1:0] databusbit_step_size[$];
                                logic[63:0] data64bit_enable[$];
                                logic[32-1:0] databusbit_enable[$];
                                data64bit_min_val.delete(); databusbit_min_val.delete();
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=0;
                                refm.mem_blk_pages_s_axi_control_min_val.tobusdata(data64bit_min_val, refm.mem_blk_pages_s_axi_control_min_val.rd_page_idx, 32);
                                foreach(data64bit_min_val[s]) databusbit_min_val[s]=data64bit_min_val[s][32-1:0];
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=1;
                                axi_master_wr_s_axi_control_seq.datamerge_inavg(databusbit_min_val, 0, 16, 1);
                                data64bit_max_val.delete(); databusbit_max_val.delete();
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=0;
                                refm.mem_blk_pages_s_axi_control_max_val.tobusdata(data64bit_max_val, refm.mem_blk_pages_s_axi_control_max_val.rd_page_idx, 32);
                                foreach(data64bit_max_val[s]) databusbit_max_val[s]=data64bit_max_val[s][32-1:0];
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=1;
                                axi_master_wr_s_axi_control_seq.datamerge_inavg(databusbit_max_val, 0, 24, 1);
                                data64bit_step_size.delete(); databusbit_step_size.delete();
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=0;
                                refm.mem_blk_pages_s_axi_control_step_size.tobusdata(data64bit_step_size, refm.mem_blk_pages_s_axi_control_step_size.rd_page_idx, 32);
                                foreach(data64bit_step_size[s]) databusbit_step_size[s]=data64bit_step_size[s][32-1:0];
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=1;
                                axi_master_wr_s_axi_control_seq.datamerge_inavg(databusbit_step_size, 0, 32, 1);
                                data64bit_enable.delete(); databusbit_enable.delete();
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=0;
                                refm.mem_blk_pages_s_axi_control_enable.tobusdata(data64bit_enable, refm.mem_blk_pages_s_axi_control_enable.rd_page_idx, 32);
                                foreach(data64bit_enable[s]) databusbit_enable[s]=data64bit_enable[s][32-1:0];
                                axi_master_wr_s_axi_control_seq.StableAxiliteNoUpdate=1;
                                axi_master_wr_s_axi_control_seq.datamerge_inavg(databusbit_enable, 0, 40, 1);
                                `uvm_send(axi_master_wr_s_axi_control_seq);
                                refm.write_data_finish_s_axi_control = 1;
                                `uvm_info("s_axi_control data writting thread", $sformatf("%0dth(total 100): waiting for all write data finish event",i), UVM_LOW)
                                wait(refm.allaxilite_write_data_finish.triggered);
                                refm.write_data_finish_s_axi_control = 0;
                                fork
                                    begin // configure start to enable DUT
                                        axi_master_wr_s_axi_control_seq.wr_addr_data.push_back( (1<<0)+(0<<32) );
                                        `uvm_info("s_axi_control start dut by axilite", $sformatf("%0dth(total 100): begin to set start bit",i), UVM_LOW)
                                        `uvm_send(axi_master_wr_s_axi_control_seq);
                                    end
                                    begin
                                        `uvm_info("s_axi_control wait for ap_ready for next trans", $sformatf("%0dth(total 100): begin to wait",i), UVM_LOW)
                                        wait(refm.dut2tb_ap_ready.triggered);
                                        wait(refm.ap_done_for_nexttrans.triggered);
                                        #0.01; //make sure mem incr_rd_page_idx is called first
                                    end
                                join
                            end
                        end
                        begin
                            for(int j=0; j<100; j=j+refm.ap_done_cnt) begin
                                wait(misc_if.dut2tb_ap_done_kernel == 1);
                                `uvm_info("test finish control", $sformatf("ap_done of kernel is triggered"), UVM_LOW)
                                @(posedge misc_if.clock);
                                fork
                                    forever begin
                                        `uvm_create_on(axi_master_poll_s_axi_control_seq, p_sequencer.s_axi_control_sqr);
                                        axi_master_poll_s_axi_control_seq.isusr_delay = axi_pkg::NO_DELAY;
                                        axi_master_poll_s_axi_control_seq.misc_if = refm.misc_if;
                                        axi_master_poll_s_axi_control_seq.rd_addr.push_back(0);
                                        `uvm_send(axi_master_poll_s_axi_control_seq)
                                        repeat(2) @(posedge misc_if.clock);
                                    end
                                    begin
                                        `uvm_info("test finish control", $sformatf("%0dth(total 100) ap_done_for_nexttrans begin to wait",j), UVM_LOW)
                                        @refm.dut2tb_ap_done;
                                    end
                                join_any
                                disable fork;
                                wait(refm.ap_ready_for_nexttrans.triggered);
                            end
                        end
                    join
                end

                begin
                    for(int j=0; j<100; j=j+refm.ap_done_cnt) @refm.ap_done_for_nexttrans;
                    `uvm_info(this.get_full_name(), "autotb finished", UVM_LOW)
                    -> refm.finish;
                    refm.misc_if.finished = 1;
                    @(posedge refm.misc_if.clock);
                    refm.misc_if.finished = 0;
                    @(posedge refm.misc_if.clock);
                    -> refm.misc_if.finished_evt;
                end
            join_any
            repeat(5) @(posedge refm.misc_if.clock); //5 cycles delay for finish stuff. 5 is haphazard value

            p_sequencer.svr_port_sync_trigger_sqr.stop_sequences();
            p_sequencer.svr_port_dac_stream_sqr.stop_sequences();
            p_sequencer.s_axi_control_sqr.stop_sequences();
            disable fork;
                                                                                                    
            starting_phase.drop_objection(this);                                                    
                                                                                                    
        endtask                                                                                     
    endclass                                                                                        
                                                                                                    
`endif                                                                                              
