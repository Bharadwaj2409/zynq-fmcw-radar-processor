set moduleName fmcw_ramp_gen
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set restart_counter_num 0
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 2
set C_modelName {fmcw_ramp_gen}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ dac_stream_V_data_V int 32 regular {axi_s 1 volatile  { dac_stream Data } }  }
	{ dac_stream_V_keep_V int 4 regular {axi_s 1 volatile  { dac_stream Keep } }  }
	{ dac_stream_V_strb_V int 4 regular {axi_s 1 volatile  { dac_stream Strb } }  }
	{ dac_stream_V_last_V int 1 regular {axi_s 1 volatile  { dac_stream Last } }  }
	{ sync_trigger int 1 regular {pointer 1}  }
	{ min_val int 14 regular {axi_slave 0}  }
	{ max_val int 14 regular {axi_slave 0}  }
	{ step_size int 14 regular {axi_slave 0}  }
	{ enable int 1 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "dac_stream_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dac_stream_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dac_stream_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "dac_stream_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "sync_trigger", "interface" : "wire", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "min_val", "interface" : "axi_slave", "bundle":"s_axi_control","type":"ap_none","bitwidth" : 14, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":23}} , 
 	{ "Name" : "max_val", "interface" : "axi_slave", "bundle":"s_axi_control","type":"ap_none","bitwidth" : 14, "direction" : "READONLY", "offset" : {"in":24}, "offset_end" : {"in":31}} , 
 	{ "Name" : "step_size", "interface" : "axi_slave", "bundle":"s_axi_control","type":"ap_none","bitwidth" : 14, "direction" : "READONLY", "offset" : {"in":32}, "offset_end" : {"in":39}} , 
 	{ "Name" : "enable", "interface" : "axi_slave", "bundle":"s_axi_control","type":"ap_none","bitwidth" : 1, "direction" : "READONLY", "offset" : {"in":40}, "offset_end" : {"in":47}} ]}
# RTL Port declarations: 
set portNum 27
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ dac_stream_TDATA sc_out sc_lv 32 signal 0 } 
	{ dac_stream_TVALID sc_out sc_logic 1 outvld 3 } 
	{ dac_stream_TREADY sc_in sc_logic 1 outacc 3 } 
	{ dac_stream_TKEEP sc_out sc_lv 4 signal 1 } 
	{ dac_stream_TSTRB sc_out sc_lv 4 signal 2 } 
	{ dac_stream_TLAST sc_out sc_lv 1 signal 3 } 
	{ sync_trigger sc_out sc_lv 1 signal 4 } 
	{ s_axi_s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "s_axi_control", "role": "AWADDR" },"address":[{"name":"fmcw_ramp_gen","role":"start","value":"0","valid_bit":"0"},{"name":"fmcw_ramp_gen","role":"continue","value":"0","valid_bit":"4"},{"name":"fmcw_ramp_gen","role":"auto_start","value":"0","valid_bit":"7"},{"name":"min_val","role":"data","value":"16"},{"name":"max_val","role":"data","value":"24"},{"name":"step_size","role":"data","value":"32"},{"name":"enable","role":"data","value":"40"}] },
	{ "name": "s_axi_s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "AWVALID" } },
	{ "name": "s_axi_s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "AWREADY" } },
	{ "name": "s_axi_s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "WVALID" } },
	{ "name": "s_axi_s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "WREADY" } },
	{ "name": "s_axi_s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_axi_control", "role": "WDATA" } },
	{ "name": "s_axi_s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "s_axi_control", "role": "WSTRB" } },
	{ "name": "s_axi_s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "s_axi_control", "role": "ARADDR" },"address":[{"name":"fmcw_ramp_gen","role":"start","value":"0","valid_bit":"0"},{"name":"fmcw_ramp_gen","role":"done","value":"0","valid_bit":"1"},{"name":"fmcw_ramp_gen","role":"idle","value":"0","valid_bit":"2"},{"name":"fmcw_ramp_gen","role":"ready","value":"0","valid_bit":"3"},{"name":"fmcw_ramp_gen","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "ARVALID" } },
	{ "name": "s_axi_s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "ARREADY" } },
	{ "name": "s_axi_s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "RVALID" } },
	{ "name": "s_axi_s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "RREADY" } },
	{ "name": "s_axi_s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_axi_control", "role": "RDATA" } },
	{ "name": "s_axi_s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "s_axi_control", "role": "RRESP" } },
	{ "name": "s_axi_s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "BVALID" } },
	{ "name": "s_axi_s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "BREADY" } },
	{ "name": "s_axi_s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "s_axi_control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_axi_control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "dac_stream_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dac_stream_V_data_V", "role": "default" }} , 
 	{ "name": "dac_stream_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "dac_stream_V_last_V", "role": "default" }} , 
 	{ "name": "dac_stream_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "dac_stream_V_last_V", "role": "default" }} , 
 	{ "name": "dac_stream_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dac_stream_V_keep_V", "role": "default" }} , 
 	{ "name": "dac_stream_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dac_stream_V_strb_V", "role": "default" }} , 
 	{ "name": "dac_stream_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dac_stream_V_last_V", "role": "default" }} , 
 	{ "name": "sync_trigger", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sync_trigger", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	fmcw_ramp_gen {
		dac_stream_V_data_V {Type O LastRead -1 FirstWrite 0}
		dac_stream_V_keep_V {Type O LastRead -1 FirstWrite 0}
		dac_stream_V_strb_V {Type O LastRead -1 FirstWrite 0}
		dac_stream_V_last_V {Type O LastRead -1 FirstWrite 0}
		sync_trigger {Type O LastRead -1 FirstWrite 0}
		min_val {Type I LastRead 0 FirstWrite -1}
		max_val {Type I LastRead 0 FirstWrite -1}
		step_size {Type I LastRead 0 FirstWrite -1}
		enable {Type I LastRead 0 FirstWrite -1}
		current_val {Type IO LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "1"}
	, {"Name" : "Interval", "Min" : "2", "Max" : "2"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	dac_stream_V_data_V { axis {  { dac_stream_TDATA out_data 1 32 } } }
	dac_stream_V_keep_V { axis {  { dac_stream_TKEEP out_data 1 4 } } }
	dac_stream_V_strb_V { axis {  { dac_stream_TSTRB out_data 1 4 } } }
	dac_stream_V_last_V { axis {  { dac_stream_TVALID out_vld 1 1 }  { dac_stream_TREADY out_acc 0 1 }  { dac_stream_TLAST out_data 1 1 } } }
	sync_trigger { ap_none {  { sync_trigger out_data 1 1 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
