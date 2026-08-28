# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_s_axi_control {
min_val { 
	dir I
	width 14
	depth 1
	mode ap_none
	offset 16
	offset_end 23
}
max_val { 
	dir I
	width 14
	depth 1
	mode ap_none
	offset 24
	offset_end 31
}
step_size { 
	dir I
	width 14
	depth 1
	mode ap_none
	offset 32
	offset_end 39
}
enable { 
	dir I
	width 1
	depth 1
	mode ap_none
	offset 40
	offset_end 47
}
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
interrupt {
}
}
dict set axilite_register_dict s_axi_control $port_s_axi_control


