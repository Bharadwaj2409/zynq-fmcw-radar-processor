
################################################################
# This is a generated script based on design: DAC
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source DAC_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# sawtooth_ramp_gen

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART digilentinc.com:eclypse-z7:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name DAC

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
digilent.com:user:ZmodAWGController:1.1\
xilinx.com:inline_hdl:ilconstant:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wiz:6.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
sawtooth_ramp_gen\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set sZmodDAC_CS_0 [ create_bd_port -dir O sZmodDAC_CS_0 ]
  set sZmodDAC_SCLK_0 [ create_bd_port -dir O sZmodDAC_SCLK_0 ]
  set sZmodDAC_SDIO_0 [ create_bd_port -dir IO sZmodDAC_SDIO_0 ]
  set sZmodDAC_Reset_0 [ create_bd_port -dir O -type rst sZmodDAC_Reset_0 ]
  set ZmodDAC_ClkIO_0 [ create_bd_port -dir O -type clk ZmodDAC_ClkIO_0 ]
  set ZmodDAC_ClkIn_0 [ create_bd_port -dir O -type clk ZmodDAC_ClkIn_0 ]
  set dZmodDAC_Data_0 [ create_bd_port -dir O -from 13 -to 0 dZmodDAC_Data_0 ]
  set sZmodDAC_SetFS1_0 [ create_bd_port -dir O sZmodDAC_SetFS1_0 ]
  set sZmodDAC_SetFS2_0 [ create_bd_port -dir O sZmodDAC_SetFS2_0 ]
  set sZmodDAC_EnOut_0 [ create_bd_port -dir O sZmodDAC_EnOut_0 ]
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 125000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.0} \
 ] $sys_clock
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl

  # Create instance: ZmodAWGController_0, and set properties
  set ZmodAWGController_0 [ create_bd_cell -type ip -vlnv digilent.com:user:ZmodAWGController:1.1 ZmodAWGController_0 ]
  set_property -dict [list \
    CONFIG.kCh1ScaleStatic {1} \
    CONFIG.kCh2ScaleStatic {1} \
    CONFIG.kExtScaleConfigEn {false} \
  ] $ZmodAWGController_0


  # Create instance: DAC_EN, and set properties
  set DAC_EN [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 DAC_EN ]

  # Create instance: ilconstant_0, and set properties
  set ilconstant_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $ilconstant_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: sawtooth_ramp_gen_0, and set properties
  set block_name sawtooth_ramp_gen
  set block_cell_name sawtooth_ramp_gen_0
  if { [catch {set sawtooth_ramp_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sawtooth_ramp_gen_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.RAMP_MAX {0x0000} \
    CONFIG.RAMP_MIN {0x1FFF} \
    CONFIG.RAMP_STEP {0x0001} \
  ] $sawtooth_ramp_gen_0


  # Create instance: ilconstant_1, and set properties
  set ilconstant_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_1 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT2_JITTER {124.615} \
    CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
    CONFIG.CLKOUT2_REQUESTED_PHASE {90} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
    CONFIG.MMCM_CLKOUT1_PHASE {90.000} \
    CONFIG.NUM_OUT_CLKS {2} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $clk_wiz_0


  # Create interface connections
  connect_bd_intf_net -intf_net sawtooth_ramp_gen_0_m_axis [get_bd_intf_pins sawtooth_ramp_gen_0/m_axis] [get_bd_intf_pins ZmodAWGController_0/InputDataStream]

  # Create port connections
  connect_bd_net -net DAC_EN_dout  [get_bd_pins DAC_EN/dout] \
  [get_bd_pins ZmodAWGController_0/sDAC_EnIn]
  connect_bd_net -net Net  [get_bd_ports sZmodDAC_SDIO_0] \
  [get_bd_pins ZmodAWGController_0/sZmodDAC_SDIO]
  connect_bd_net -net ZmodAWGController_0_ZmodDAC_ClkIO  [get_bd_pins ZmodAWGController_0/ZmodDAC_ClkIO] \
  [get_bd_ports ZmodDAC_ClkIO_0]
  connect_bd_net -net ZmodAWGController_0_ZmodDAC_ClkIn  [get_bd_pins ZmodAWGController_0/ZmodDAC_ClkIn] \
  [get_bd_ports ZmodDAC_ClkIn_0]
  connect_bd_net -net ZmodAWGController_0_dZmodDAC_Data  [get_bd_pins ZmodAWGController_0/dZmodDAC_Data] \
  [get_bd_ports dZmodDAC_Data_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_CS  [get_bd_pins ZmodAWGController_0/sZmodDAC_CS] \
  [get_bd_ports sZmodDAC_CS_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_EnOut  [get_bd_pins ZmodAWGController_0/sZmodDAC_EnOut] \
  [get_bd_ports sZmodDAC_EnOut_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_Reset  [get_bd_pins ZmodAWGController_0/sZmodDAC_Reset] \
  [get_bd_ports sZmodDAC_Reset_0] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_SCLK  [get_bd_pins ZmodAWGController_0/sZmodDAC_SCLK] \
  [get_bd_ports sZmodDAC_SCLK_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_SetFS1  [get_bd_pins ZmodAWGController_0/sZmodDAC_SetFS1] \
  [get_bd_ports sZmodDAC_SetFS1_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_SetFS2  [get_bd_pins ZmodAWGController_0/sZmodDAC_SetFS2] \
  [get_bd_ports sZmodDAC_SetFS2_0]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins sawtooth_ramp_gen_0/clk] \
  [get_bd_pins ZmodAWGController_0/DAC_InIO_Clk] \
  [get_bd_pins ZmodAWGController_0/SysClk100] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out2  [get_bd_pins clk_wiz_0/clk_out2] \
  [get_bd_pins ZmodAWGController_0/DAC_Clk]
  connect_bd_net -net clk_wiz_0_locked  [get_bd_pins clk_wiz_0/locked] \
  [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net ilconstant_0_dout  [get_bd_pins ilconstant_0/dout] \
  [get_bd_pins ZmodAWGController_0/sTestMode]
  connect_bd_net -net ilconstant_1_dout  [get_bd_pins ilconstant_1/dout] \
  [get_bd_pins sawtooth_ramp_gen_0/enable]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins ZmodAWGController_0/aRst_n] \
  [get_bd_pins sawtooth_ramp_gen_0/rst_n]
  connect_bd_net -net reset_rtl_1  [get_bd_ports reset_rtl] \
  [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net sys_clock_1  [get_bd_ports sys_clock] \
  [get_bd_pins clk_wiz_0/clk_in1]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

