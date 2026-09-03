
################################################################
# This is a generated script based on design: design_1
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
# source design_1_script.tcl


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
set design_name design_1

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
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wiz:6.0\
digilent.com:user:ZmodScopeController:1.2\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:xfft:9.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:dist_mem_gen:8.0\
xilinx.com:ip:mult_gen:12.0\
xilinx.com:inline_hdl:ilslice:1.0\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:inline_hdl:ilconcat:1.0\
xilinx.com:inline_hdl:ilconstant:1.0\
digilent.com:user:ZmodAWGController:1.1\
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
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set btn_2bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btn_2bits ]

  set btn_2bits_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btn_2bits_0 ]


  # Create ports
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 125000000 sys_clock ]
  set ZmodAdcClkIn_n_0 [ create_bd_port -dir O ZmodAdcClkIn_n_0 ]
  set ZmodAdcClkIn_p_0 [ create_bd_port -dir O ZmodAdcClkIn_p_0 ]
  set ZmodDcoClk_0 [ create_bd_port -dir I -type clk -freq_hz 40000000 ZmodDcoClk_0 ]
  set dZmodADC_Data_0 [ create_bd_port -dir I -from 13 -to 0 dZmodADC_Data_0 ]
  set iZmodSync_0 [ create_bd_port -dir O iZmodSync_0 ]
  set sZmodADC_CS_0 [ create_bd_port -dir O sZmodADC_CS_0 ]
  set sZmodADC_SDIO_0 [ create_bd_port -dir IO sZmodADC_SDIO_0 ]
  set sZmodADC_Sclk_0 [ create_bd_port -dir O sZmodADC_Sclk_0 ]
  set sZmodCh1CouplingH_0 [ create_bd_port -dir O sZmodCh1CouplingH_0 ]
  set sZmodCh1CouplingL_0 [ create_bd_port -dir O sZmodCh1CouplingL_0 ]
  set sZmodCh1GainH_0 [ create_bd_port -dir O sZmodCh1GainH_0 ]
  set sZmodCh1GainL_0 [ create_bd_port -dir O sZmodCh1GainL_0 ]
  set sZmodCh2CouplingH_0 [ create_bd_port -dir O sZmodCh2CouplingH_0 ]
  set sZmodCh2CouplingL_0 [ create_bd_port -dir O sZmodCh2CouplingL_0 ]
  set sZmodCh2GainH_0 [ create_bd_port -dir O sZmodCh2GainH_0 ]
  set sZmodCh2GainL_0 [ create_bd_port -dir O sZmodCh2GainL_0 ]
  set sZmodRelayComH_0 [ create_bd_port -dir O sZmodRelayComH_0 ]
  set sZmodRelayComL_0 [ create_bd_port -dir O sZmodRelayComL_0 ]
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl
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

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [list \
    CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
    CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
    CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
    CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
    CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
    CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
    CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
    CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
    CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
    CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
    CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
    CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
    CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
    CONFIG.PCW_CLK0_FREQ {100000000} \
    CONFIG.PCW_CLK1_FREQ {10000000} \
    CONFIG.PCW_CLK2_FREQ {10000000} \
    CONFIG.PCW_CLK3_FREQ {10000000} \
    CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
    CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
    CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
    CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
    CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
    CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
    CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
    CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
    CONFIG.PCW_DM_WIDTH {4} \
    CONFIG.PCW_DQS_WIDTH {4} \
    CONFIG.PCW_DQ_WIDTH {32} \
    CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
    CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
    CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
    CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
    CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
    CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
    CONFIG.PCW_ENET0_RESET_ENABLE {1} \
    CONFIG.PCW_ENET0_RESET_IO {MIO 9} \
    CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_ENET_RESET_ENABLE {1} \
    CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
    CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_EN_4K_TIMER {0} \
    CONFIG.PCW_EN_CAN0 {0} \
    CONFIG.PCW_EN_CAN1 {0} \
    CONFIG.PCW_EN_CLK0_PORT {1} \
    CONFIG.PCW_EN_CLK1_PORT {0} \
    CONFIG.PCW_EN_CLK2_PORT {0} \
    CONFIG.PCW_EN_CLK3_PORT {0} \
    CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
    CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
    CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
    CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
    CONFIG.PCW_EN_DDR {1} \
    CONFIG.PCW_EN_EMIO_CAN0 {0} \
    CONFIG.PCW_EN_EMIO_CAN1 {0} \
    CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
    CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
    CONFIG.PCW_EN_EMIO_ENET0 {0} \
    CONFIG.PCW_EN_EMIO_ENET1 {0} \
    CONFIG.PCW_EN_EMIO_GPIO {0} \
    CONFIG.PCW_EN_EMIO_I2C0 {0} \
    CONFIG.PCW_EN_EMIO_I2C1 {0} \
    CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
    CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
    CONFIG.PCW_EN_EMIO_PJTAG {0} \
    CONFIG.PCW_EN_EMIO_SDIO0 {0} \
    CONFIG.PCW_EN_EMIO_SDIO1 {0} \
    CONFIG.PCW_EN_EMIO_SPI0 {1} \
    CONFIG.PCW_EN_EMIO_SPI1 {0} \
    CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
    CONFIG.PCW_EN_EMIO_TRACE {0} \
    CONFIG.PCW_EN_EMIO_TTC0 {1} \
    CONFIG.PCW_EN_EMIO_TTC1 {0} \
    CONFIG.PCW_EN_EMIO_UART0 {0} \
    CONFIG.PCW_EN_EMIO_UART1 {0} \
    CONFIG.PCW_EN_EMIO_WDT {0} \
    CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
    CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
    CONFIG.PCW_EN_ENET0 {1} \
    CONFIG.PCW_EN_ENET1 {0} \
    CONFIG.PCW_EN_GPIO {1} \
    CONFIG.PCW_EN_I2C0 {0} \
    CONFIG.PCW_EN_I2C1 {1} \
    CONFIG.PCW_EN_MODEM_UART0 {0} \
    CONFIG.PCW_EN_MODEM_UART1 {0} \
    CONFIG.PCW_EN_PJTAG {0} \
    CONFIG.PCW_EN_PTP_ENET0 {0} \
    CONFIG.PCW_EN_PTP_ENET1 {0} \
    CONFIG.PCW_EN_QSPI {1} \
    CONFIG.PCW_EN_RST0_PORT {1} \
    CONFIG.PCW_EN_RST1_PORT {0} \
    CONFIG.PCW_EN_RST2_PORT {0} \
    CONFIG.PCW_EN_RST3_PORT {0} \
    CONFIG.PCW_EN_SDIO0 {0} \
    CONFIG.PCW_EN_SDIO1 {0} \
    CONFIG.PCW_EN_SMC {0} \
    CONFIG.PCW_EN_SPI0 {1} \
    CONFIG.PCW_EN_SPI1 {0} \
    CONFIG.PCW_EN_TRACE {0} \
    CONFIG.PCW_EN_TTC0 {1} \
    CONFIG.PCW_EN_TTC1 {0} \
    CONFIG.PCW_EN_UART0 {1} \
    CONFIG.PCW_EN_UART1 {0} \
    CONFIG.PCW_EN_USB0 {1} \
    CONFIG.PCW_EN_USB1 {0} \
    CONFIG.PCW_EN_WDT {0} \
    CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
    CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {1} \
    CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
    CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
    CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {1} \
    CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
    CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
    CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
    CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
    CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
    CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_I2C0_RESET_ENABLE {0} \
    CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
    CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
    CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
    CONFIG.PCW_I2C1_I2C1_IO {MIO 12 .. 13} \
    CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_I2C_RESET_ENABLE {1} \
    CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
    CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
    CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
    CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_0_PULLUP {enabled} \
    CONFIG.PCW_MIO_0_SLEW {slow} \
    CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_10_PULLUP {disabled} \
    CONFIG.PCW_MIO_10_SLEW {slow} \
    CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_11_PULLUP {disabled} \
    CONFIG.PCW_MIO_11_SLEW {slow} \
    CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_12_PULLUP {enabled} \
    CONFIG.PCW_MIO_12_SLEW {slow} \
    CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_13_PULLUP {enabled} \
    CONFIG.PCW_MIO_13_SLEW {slow} \
    CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_14_PULLUP {enabled} \
    CONFIG.PCW_MIO_14_SLEW {slow} \
    CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_15_PULLUP {enabled} \
    CONFIG.PCW_MIO_15_SLEW {slow} \
    CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_16_PULLUP {enabled} \
    CONFIG.PCW_MIO_16_SLEW {fast} \
    CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_17_PULLUP {enabled} \
    CONFIG.PCW_MIO_17_SLEW {fast} \
    CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_18_PULLUP {enabled} \
    CONFIG.PCW_MIO_18_SLEW {fast} \
    CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_19_PULLUP {enabled} \
    CONFIG.PCW_MIO_19_SLEW {fast} \
    CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_1_PULLUP {enabled} \
    CONFIG.PCW_MIO_1_SLEW {slow} \
    CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_20_PULLUP {enabled} \
    CONFIG.PCW_MIO_20_SLEW {fast} \
    CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_21_PULLUP {enabled} \
    CONFIG.PCW_MIO_21_SLEW {fast} \
    CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_22_PULLUP {enabled} \
    CONFIG.PCW_MIO_22_SLEW {fast} \
    CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_23_PULLUP {enabled} \
    CONFIG.PCW_MIO_23_SLEW {fast} \
    CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_24_PULLUP {enabled} \
    CONFIG.PCW_MIO_24_SLEW {fast} \
    CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_25_PULLUP {enabled} \
    CONFIG.PCW_MIO_25_SLEW {fast} \
    CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_26_PULLUP {enabled} \
    CONFIG.PCW_MIO_26_SLEW {fast} \
    CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_27_PULLUP {enabled} \
    CONFIG.PCW_MIO_27_SLEW {fast} \
    CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_28_PULLUP {enabled} \
    CONFIG.PCW_MIO_28_SLEW {fast} \
    CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_29_PULLUP {enabled} \
    CONFIG.PCW_MIO_29_SLEW {fast} \
    CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_2_SLEW {slow} \
    CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_30_PULLUP {enabled} \
    CONFIG.PCW_MIO_30_SLEW {fast} \
    CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_31_PULLUP {enabled} \
    CONFIG.PCW_MIO_31_SLEW {fast} \
    CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_32_PULLUP {enabled} \
    CONFIG.PCW_MIO_32_SLEW {fast} \
    CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_33_PULLUP {enabled} \
    CONFIG.PCW_MIO_33_SLEW {fast} \
    CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_34_PULLUP {enabled} \
    CONFIG.PCW_MIO_34_SLEW {fast} \
    CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_35_PULLUP {enabled} \
    CONFIG.PCW_MIO_35_SLEW {fast} \
    CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_36_PULLUP {enabled} \
    CONFIG.PCW_MIO_36_SLEW {fast} \
    CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_37_PULLUP {enabled} \
    CONFIG.PCW_MIO_37_SLEW {fast} \
    CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_38_PULLUP {enabled} \
    CONFIG.PCW_MIO_38_SLEW {fast} \
    CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_39_PULLUP {enabled} \
    CONFIG.PCW_MIO_39_SLEW {fast} \
    CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_3_SLEW {slow} \
    CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_40_PULLUP {enabled} \
    CONFIG.PCW_MIO_40_SLEW {slow} \
    CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_41_PULLUP {enabled} \
    CONFIG.PCW_MIO_41_SLEW {slow} \
    CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_42_PULLUP {enabled} \
    CONFIG.PCW_MIO_42_SLEW {slow} \
    CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_43_PULLUP {enabled} \
    CONFIG.PCW_MIO_43_SLEW {slow} \
    CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_44_PULLUP {enabled} \
    CONFIG.PCW_MIO_44_SLEW {slow} \
    CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_45_PULLUP {enabled} \
    CONFIG.PCW_MIO_45_SLEW {slow} \
    CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_46_PULLUP {enabled} \
    CONFIG.PCW_MIO_46_SLEW {slow} \
    CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_47_PULLUP {enabled} \
    CONFIG.PCW_MIO_47_SLEW {slow} \
    CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_48_PULLUP {enabled} \
    CONFIG.PCW_MIO_48_SLEW {slow} \
    CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_49_PULLUP {enabled} \
    CONFIG.PCW_MIO_49_SLEW {slow} \
    CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_4_SLEW {slow} \
    CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_50_PULLUP {enabled} \
    CONFIG.PCW_MIO_50_SLEW {slow} \
    CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_51_PULLUP {enabled} \
    CONFIG.PCW_MIO_51_SLEW {slow} \
    CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_52_PULLUP {enabled} \
    CONFIG.PCW_MIO_52_SLEW {slow} \
    CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_53_PULLUP {enabled} \
    CONFIG.PCW_MIO_53_SLEW {slow} \
    CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_5_SLEW {slow} \
    CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_6_SLEW {slow} \
    CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_7_SLEW {slow} \
    CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_8_SLEW {slow} \
    CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_9_PULLUP {enabled} \
    CONFIG.PCW_MIO_9_SLEW {slow} \
    CONFIG.PCW_MIO_PRIMITIVE {54} \
    CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#ENET Reset#GPIO#GPIO#I2C 1#I2C 1#UART 0#UART 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#USB Reset#GPIO#GPIO#GPIO#GPIO#GPIO#Enet\
0#Enet 0} \
    CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#reset#gpio[10]#gpio[11]#scl#sda#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#gpio[40]#gpio[41]#gpio[42]#gpio[43]#gpio[44]#gpio[45]#reset#gpio[47]#gpio[48]#gpio[49]#gpio[50]#gpio[51]#mdc#mdio}\
\
    CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
    CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
    CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
    CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
    CONFIG.PCW_NAND_CYCLES_T_AR {1} \
    CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
    CONFIG.PCW_NAND_CYCLES_T_RC {11} \
    CONFIG.PCW_NAND_CYCLES_T_REA {1} \
    CONFIG.PCW_NAND_CYCLES_T_RR {1} \
    CONFIG.PCW_NAND_CYCLES_T_WC {11} \
    CONFIG.PCW_NAND_CYCLES_T_WP {1} \
    CONFIG.PCW_NOR_CS0_T_CEOE {1} \
    CONFIG.PCW_NOR_CS0_T_PC {1} \
    CONFIG.PCW_NOR_CS0_T_RC {11} \
    CONFIG.PCW_NOR_CS0_T_TR {1} \
    CONFIG.PCW_NOR_CS0_T_WC {11} \
    CONFIG.PCW_NOR_CS0_T_WP {1} \
    CONFIG.PCW_NOR_CS0_WE_TIME {0} \
    CONFIG.PCW_NOR_CS1_T_CEOE {1} \
    CONFIG.PCW_NOR_CS1_T_PC {1} \
    CONFIG.PCW_NOR_CS1_T_RC {11} \
    CONFIG.PCW_NOR_CS1_T_TR {1} \
    CONFIG.PCW_NOR_CS1_T_WC {11} \
    CONFIG.PCW_NOR_CS1_T_WP {1} \
    CONFIG.PCW_NOR_CS1_WE_TIME {0} \
    CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
    CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
    CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
    CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
    CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
    CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
    CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
    CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
    CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
    CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
    CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
    CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
    CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
    CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
    CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.311} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.311} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.304} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.304} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.202} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.202} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {0.029} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {0.031} \
    CONFIG.PCW_PACKAGE_NAME {clg484} \
    CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
    CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
    CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
    CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
    CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
    CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
    CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
    CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
    CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
    CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
    CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_SDIO_PERIPHERAL_VALID {0} \
    CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
    CONFIG.PCW_SMC_CYCLE_T0 {NA} \
    CONFIG.PCW_SMC_CYCLE_T1 {NA} \
    CONFIG.PCW_SMC_CYCLE_T2 {NA} \
    CONFIG.PCW_SMC_CYCLE_T3 {NA} \
    CONFIG.PCW_SMC_CYCLE_T4 {NA} \
    CONFIG.PCW_SMC_CYCLE_T5 {NA} \
    CONFIG.PCW_SMC_CYCLE_T6 {NA} \
    CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
    CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
    CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
    CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
    CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
    CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
    CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
    CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
    CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
    CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
    CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
    CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
    CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
    CONFIG.PCW_UART0_BAUD_RATE {115200} \
    CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
    CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
    CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
    CONFIG.PCW_UIPARAM_DDR_AL {0} \
    CONFIG.PCW_UIPARAM_DDR_BL {8} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.311} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.311} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.304} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.304} \
    CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {63.2909} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {63.2909} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {49.1639} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {49.1639} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {32.2611} \
    CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {32.2666} \
    CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {44.6376} \
    CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {44.3743} \
    CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.202} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.202} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.029} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.031} \
    CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {32.5236} \
    CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {32.3526} \
    CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {44.4929} \
    CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {44.4683} \
    CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {165.1} \
    CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
    CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
    CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
    CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
    CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
    CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
    CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
    CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
    CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_IO {MIO 46} \
    CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
    CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_USB_RESET_ENABLE {1} \
    CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
    CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
    CONFIG.PCW_USE_AXI_NONSECURE {0} \
    CONFIG.PCW_USE_CORESIGHT {0} \
    CONFIG.PCW_USE_CROSS_TRIGGER {0} \
    CONFIG.PCW_USE_CR_FABRIC {1} \
    CONFIG.PCW_USE_DDR_BYPASS {0} \
    CONFIG.PCW_USE_DEBUG {0} \
    CONFIG.PCW_USE_DMA0 {0} \
    CONFIG.PCW_USE_DMA1 {0} \
    CONFIG.PCW_USE_DMA2 {0} \
    CONFIG.PCW_USE_DMA3 {0} \
    CONFIG.PCW_USE_EXPANDED_IOP {0} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
    CONFIG.PCW_USE_HIGH_OCM {0} \
    CONFIG.PCW_USE_M_AXI_GP0 {1} \
    CONFIG.PCW_USE_M_AXI_GP1 {0} \
    CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
    CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
    CONFIG.PCW_USE_S_AXI_ACP {0} \
    CONFIG.PCW_USE_S_AXI_GP0 {0} \
    CONFIG.PCW_USE_S_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_HP0 {1} \
    CONFIG.PCW_USE_S_AXI_HP1 {0} \
    CONFIG.PCW_USE_S_AXI_HP2 {0} \
    CONFIG.PCW_USE_S_AXI_HP3 {0} \
    CONFIG.PCW_USE_TRACE {0} \
    CONFIG.PCW_VALUE_SILVERSION {3} \
    CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
    CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
    CONFIG.preset {None} \
  ] $processing_system7_0


  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {80.0} \
    CONFIG.CLKOUT1_JITTER {321.613} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {40} \
    CONFIG.CLKOUT2_JITTER {265.121} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
    CONFIG.CLKOUT2_REQUESTED_PHASE {0} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_JITTER {242.716} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {160} \
    CONFIG.CLKOUT3_REQUESTED_PHASE {90} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLKOUT4_JITTER {265.121} \
    CONFIG.CLKOUT4_PHASE_ERROR {265.359} \
    CONFIG.CLKOUT4_REQUESTED_PHASE {90} \
    CONFIG.CLKOUT4_USED {true} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {8} \
    CONFIG.MMCM_CLKOUT1_PHASE {0.000} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {5} \
    CONFIG.MMCM_CLKOUT3_DIVIDE {8} \
    CONFIG.MMCM_CLKOUT3_PHASE {90.000} \
    CONFIG.NUM_OUT_CLKS {4} \
  ] $clk_wiz_0


  # Create instance: rst_clk_wiz_40M, and set properties
  set rst_clk_wiz_40M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_40M ]

  # Create instance: ZmodADC_Controller_0, and set properties
  set ZmodADC_Controller_0 [ create_bd_cell -type ip -vlnv digilent.com:user:ZmodScopeController:1.2 ZmodADC_Controller_0 ]
  set_property -dict [list \
    CONFIG.kExtCalibEn {false} \
    CONFIG.kExtRelayConfigEn {false} \
    CONFIG.kSamplingPeriod {25000} \
  ] $ZmodADC_Controller_0


  # Create instance: const_adc_en, and set properties
  set const_adc_en [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_adc_en ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $const_adc_en


  # Create instance: const_adc_test, and set properties
  set const_adc_test [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_adc_test ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $const_adc_test


  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [list \
    CONFIG.M_HAS_TKEEP {0} \
    CONFIG.M_HAS_TLAST {0} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {4} \
    CONFIG.M_TDEST_WIDTH {0} \
    CONFIG.M_TID_WIDTH {0} \
    CONFIG.M_TUSER_WIDTH {0} \
    CONFIG.S_HAS_TKEEP {0} \
    CONFIG.S_HAS_TLAST {0} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_HAS_TSTRB {0} \
    CONFIG.S_TDATA_NUM_BYTES {4} \
    CONFIG.S_TDEST_WIDTH {0} \
    CONFIG.S_TID_WIDTH {0} \
    CONFIG.S_TUSER_WIDTH {0} \
    CONFIG.TDATA_REMAP {16'b0000000000000000, 2'b00, tdata[13:0]} \
  ] $axis_subset_converter_0

  set_property -dict [list \
    CONFIG.M_HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.M_HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.M_HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.M_HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.M_TID_WIDTH.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.S_HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.S_HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.S_HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.S_TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TID_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
  ] $axis_subset_converter_0


  # Create instance: xfft_range, and set properties
  set xfft_range [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.1 xfft_range ]
  set_property -dict [list \
    CONFIG.aresetn {true} \
    CONFIG.data_format {fixed_point} \
    CONFIG.implementation_options {pipelined_streaming_io} \
    CONFIG.input_width {16} \
    CONFIG.output_ordering {natural_order} \
    CONFIG.rounding_modes {convergent_rounding} \
    CONFIG.scaling_options {scaled} \
    CONFIG.target_clock_frequency {40} \
    CONFIG.transform_length {1024} \
  ] $xfft_range


  # Create instance: fft_config_const, and set properties
  set fft_config_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 fft_config_const ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x06AA} \
    CONFIG.CONST_WIDTH {16} \
  ] $fft_config_const


  # Create instance: fft_config_valid, and set properties
  set fft_config_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 fft_config_valid ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $fft_config_valid


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.IS_ACLK_ASYNC {1} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_0


  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_include_s2mm {1} \
    CONFIG.c_include_sg {0} \
    CONFIG.c_s2mm_burst_size {128} \
    CONFIG.c_s_axis_s2mm_tdata_width {32} \
  ] $axi_dma_0


  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property CONFIG.NUM_MI {4} $ps7_0_axi_periph


  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_mem_intercon


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
    CONFIG.GPIO2_BOARD_INTERFACE {Custom} \
    CONFIG.GPIO_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_0


  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [list \
    CONFIG.GPIO_BOARD_INTERFACE {rgbled_6bits} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_1


  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [list \
    CONFIG.CE {true} \
    CONFIG.Load {false} \
    CONFIG.Output_Width {10} \
    CONFIG.SCLR {true} \
    CONFIG.Sync_Threshold_Output {true} \
    CONFIG.Threshold_Value {3FF} \
  ] $c_counter_binary_0


  # Create instance: win_rom_0, and set properties
  set win_rom_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 win_rom_0 ]
  set_property -dict [list \
    CONFIG.coefficient_file {c:/Users/vempa/Eclypse-Z7/zynq-fmcw-radar-processor/Coefficient_Files/hanning_1024.coe} \
    CONFIG.depth {1024} \
    CONFIG.memory_type {rom} \
  ] $win_rom_0


  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [list \
    CONFIG.Multiplier_Construction {Use_Mults} \
    CONFIG.PipeStages {2} \
    CONFIG.PortAWidth {16} \
    CONFIG.PortBWidth {16} \
  ] $mult_gen_0


  # Create instance: win_slice_0, and set properties
  set win_slice_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 win_slice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {30} \
    CONFIG.DIN_TO {15} \
  ] $win_slice_0


  # Create instance: sr_tvalid, and set properties
  set sr_tvalid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 sr_tvalid ]
  set_property -dict [list \
    CONFIG.Depth {2} \
    CONFIG.Width {1} \
  ] $sr_tvalid


  # Create instance: sr_tlast, and set properties
  set sr_tlast [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 sr_tlast ]
  set_property -dict [list \
    CONFIG.Depth {2} \
    CONFIG.Width {1} \
  ] $sr_tlast


  # Create instance: adc_ch1_slice, and set properties
  set adc_ch1_slice [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 adc_ch1_slice ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {16} \
  ] $adc_ch1_slice


  # Create instance: ilconcat_0, and set properties
  set ilconcat_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 ilconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {16} \
    CONFIG.IN1_WIDTH {16} \
  ] $ilconcat_0


  # Create instance: ilconstant_0, and set properties
  set ilconstant_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {16} \
  ] $ilconstant_0


  # Create instance: ZmodAWGController_0, and set properties
  set ZmodAWGController_0 [ create_bd_cell -type ip -vlnv digilent.com:user:ZmodAWGController:1.1 ZmodAWGController_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

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
  
  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create interface connections
  connect_bd_intf_net -intf_net ZmodADC_Controller_0_DataStream [get_bd_intf_pins ZmodADC_Controller_0/DataStream] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports btn_2bits] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports btn_2bits_0] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins ps7_0_axi_periph/M00_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins ps7_0_axi_periph/M02_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins ps7_0_axi_periph/M03_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]
  connect_bd_intf_net -intf_net sawtooth_ramp_gen_0_m_axis [get_bd_intf_pins sawtooth_ramp_gen_0/m_axis] [get_bd_intf_pins ZmodAWGController_0/InputDataStream]
  connect_bd_intf_net -intf_net xfft_range_M_AXIS_DATA [get_bd_intf_pins xfft_range/M_AXIS_DATA] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]

  # Create port connections
  connect_bd_net -net Net  [get_bd_ports sZmodADC_SDIO_0] \
  [get_bd_pins ZmodADC_Controller_0/sZmodADC_SDIO]
  connect_bd_net -net Net1  [get_bd_ports sZmodDAC_SDIO_0] \
  [get_bd_pins ZmodAWGController_0/sZmodDAC_SDIO]
  connect_bd_net -net ZmodADC_Controller_0_ZmodAdcClkIn_n  [get_bd_pins ZmodADC_Controller_0/ZmodAdcClkIn_n] \
  [get_bd_ports ZmodAdcClkIn_n_0]
  connect_bd_net -net ZmodADC_Controller_0_ZmodAdcClkIn_p  [get_bd_pins ZmodADC_Controller_0/ZmodAdcClkIn_p] \
  [get_bd_ports ZmodAdcClkIn_p_0]
  connect_bd_net -net ZmodADC_Controller_0_iZmodSync  [get_bd_pins ZmodADC_Controller_0/iZmodSync] \
  [get_bd_ports iZmodSync_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodADC_CS  [get_bd_pins ZmodADC_Controller_0/sZmodADC_CS] \
  [get_bd_ports sZmodADC_CS_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodADC_Sclk  [get_bd_pins ZmodADC_Controller_0/sZmodADC_Sclk] \
  [get_bd_ports sZmodADC_Sclk_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1CouplingH  [get_bd_pins ZmodADC_Controller_0/sZmodCh1CouplingH] \
  [get_bd_ports sZmodCh1CouplingH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1CouplingL  [get_bd_pins ZmodADC_Controller_0/sZmodCh1CouplingL] \
  [get_bd_ports sZmodCh1CouplingL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1GainH  [get_bd_pins ZmodADC_Controller_0/sZmodCh1GainH] \
  [get_bd_ports sZmodCh1GainH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1GainL  [get_bd_pins ZmodADC_Controller_0/sZmodCh1GainL] \
  [get_bd_ports sZmodCh1GainL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2CouplingH  [get_bd_pins ZmodADC_Controller_0/sZmodCh2CouplingH] \
  [get_bd_ports sZmodCh2CouplingH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2CouplingL  [get_bd_pins ZmodADC_Controller_0/sZmodCh2CouplingL] \
  [get_bd_ports sZmodCh2CouplingL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2GainH  [get_bd_pins ZmodADC_Controller_0/sZmodCh2GainH] \
  [get_bd_ports sZmodCh2GainH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2GainL  [get_bd_pins ZmodADC_Controller_0/sZmodCh2GainL] \
  [get_bd_ports sZmodCh2GainL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodRelayComH  [get_bd_pins ZmodADC_Controller_0/sZmodRelayComH] \
  [get_bd_ports sZmodRelayComH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodRelayComL  [get_bd_pins ZmodADC_Controller_0/sZmodRelayComL] \
  [get_bd_ports sZmodRelayComL_0]
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
  [get_bd_ports sZmodDAC_Reset_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_SCLK  [get_bd_pins ZmodAWGController_0/sZmodDAC_SCLK] \
  [get_bd_ports sZmodDAC_SCLK_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_SetFS1  [get_bd_pins ZmodAWGController_0/sZmodDAC_SetFS1] \
  [get_bd_ports sZmodDAC_SetFS1_0]
  connect_bd_net -net ZmodAWGController_0_sZmodDAC_SetFS2  [get_bd_pins ZmodAWGController_0/sZmodDAC_SetFS2] \
  [get_bd_ports sZmodDAC_SetFS2_0]
  connect_bd_net -net ZmodDcoClk_0_1  [get_bd_ports ZmodDcoClk_0] \
  [get_bd_pins ZmodADC_Controller_0/ZmodDcoClk]
  connect_bd_net -net adc_ch1_slice_Dout  [get_bd_pins adc_ch1_slice/Dout] \
  [get_bd_pins mult_gen_0/A]
  connect_bd_net -net axis_subset_converter_0_m_axis_tdata  [get_bd_pins axis_subset_converter_0/m_axis_tdata] \
  [get_bd_pins adc_ch1_slice/Din]
  connect_bd_net -net axis_subset_converter_0_m_axis_tvalid  [get_bd_pins axis_subset_converter_0/m_axis_tvalid] \
  [get_bd_pins sr_tvalid/D] \
  [get_bd_pins c_counter_binary_0/CE]
  connect_bd_net -net c_counter_binary_0_Q  [get_bd_pins c_counter_binary_0/Q] \
  [get_bd_pins win_rom_0/a]
  connect_bd_net -net c_counter_binary_0_THRESH0  [get_bd_pins c_counter_binary_0/THRESH0] \
  [get_bd_pins sr_tlast/D]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins rst_clk_wiz_40M/slowest_sync_clk] \
  [get_bd_pins axis_subset_converter_0/aclk] \
  [get_bd_pins xfft_range/aclk] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins c_counter_binary_0/CLK] \
  [get_bd_pins mult_gen_0/CLK] \
  [get_bd_pins sr_tvalid/CLK] \
  [get_bd_pins sr_tlast/CLK] \
  [get_bd_pins ZmodADC_Controller_0/ADC_SamplingClk] \
  [get_bd_pins ZmodADC_Controller_0/SysClk100]
  connect_bd_net -net clk_wiz_0_clk_out2  [get_bd_pins clk_wiz_0/clk_out2] \
  [get_bd_pins ZmodAWGController_0/SysClk100] \
  [get_bd_pins ZmodAWGController_0/DAC_InIO_Clk] \
  [get_bd_pins sawtooth_ramp_gen_0/clk]
  connect_bd_net -net clk_wiz_0_clk_out3  [get_bd_pins clk_wiz_0/clk_out3] \
  [get_bd_pins ZmodADC_Controller_0/ADC_InClk]
  connect_bd_net -net clk_wiz_0_clk_out4  [get_bd_pins clk_wiz_0/clk_out4] \
  [get_bd_pins ZmodAWGController_0/DAC_Clk]
  connect_bd_net -net clk_wiz_0_locked  [get_bd_pins clk_wiz_0/locked] \
  [get_bd_pins rst_clk_wiz_40M/dcm_locked]
  connect_bd_net -net const_adc_en_dout  [get_bd_pins const_adc_en/dout] \
  [get_bd_pins ZmodADC_Controller_0/sEnableAcquisition]
  connect_bd_net -net const_adc_test_dout  [get_bd_pins const_adc_test/dout] \
  [get_bd_pins ZmodADC_Controller_0/sTestMode]
  connect_bd_net -net dZmodADC_Data_0_1  [get_bd_ports dZmodADC_Data_0] \
  [get_bd_pins ZmodADC_Controller_0/dZmodADC_Data]
  connect_bd_net -net dist_mem_gen_0_spo  [get_bd_pins win_rom_0/spo] \
  [get_bd_pins mult_gen_0/B]
  connect_bd_net -net fft_config_const_dout  [get_bd_pins fft_config_const/dout] \
  [get_bd_pins xfft_range/s_axis_config_tdata]
  connect_bd_net -net fft_config_valid_dout  [get_bd_pins fft_config_valid/dout] \
  [get_bd_pins xfft_range/s_axis_config_tvalid]
  connect_bd_net -net ilconcat_0_dout  [get_bd_pins ilconcat_0/dout] \
  [get_bd_pins xfft_range/s_axis_data_tdata]
  connect_bd_net -net ilconstant_0_dout  [get_bd_pins ilconstant_0/dout] \
  [get_bd_pins ilconcat_0/In1]
  connect_bd_net -net mult_gen_0_P  [get_bd_pins mult_gen_0/P] \
  [get_bd_pins win_slice_0/Din]
  connect_bd_net -net processing_system7_0_FCLK_CLK0  [get_bd_pins processing_system7_0/FCLK_CLK0] \
  [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] \
  [get_bd_pins axis_data_fifo_0/m_axis_aclk] \
  [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] \
  [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] \
  [get_bd_pins ps7_0_axi_periph/ACLK] \
  [get_bd_pins ps7_0_axi_periph/S00_ACLK] \
  [get_bd_pins ps7_0_axi_periph/M00_ACLK] \
  [get_bd_pins axi_mem_intercon/ACLK] \
  [get_bd_pins axi_mem_intercon/S00_ACLK] \
  [get_bd_pins axi_mem_intercon/M00_ACLK] \
  [get_bd_pins axi_dma_0/s_axi_lite_aclk] \
  [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] \
  [get_bd_pins ps7_0_axi_periph/M01_ACLK] \
  [get_bd_pins ps7_0_axi_periph/M02_ACLK] \
  [get_bd_pins axi_gpio_0/s_axi_aclk] \
  [get_bd_pins axi_gpio_1/s_axi_aclk] \
  [get_bd_pins ps7_0_axi_periph/M03_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N  [get_bd_pins processing_system7_0/FCLK_RESET0_N] \
  [get_bd_pins rst_ps7_0_100M/ext_reset_in] \
  [get_bd_pins rst_clk_wiz_40M/ext_reset_in] \
  [get_bd_pins ZmodAWGController_0/aRst_n]
  connect_bd_net -net reset_rtl_1  [get_bd_ports reset_rtl] \
  [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net rst_clk_wiz_40M_peripheral_aresetn  [get_bd_pins rst_clk_wiz_40M/peripheral_aresetn] \
  [get_bd_pins ZmodADC_Controller_0/aRst_n] \
  [get_bd_pins axis_subset_converter_0/aresetn] \
  [get_bd_pins xfft_range/aresetn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn] \
  [get_bd_pins sawtooth_ramp_gen_0/rst_n]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn  [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] \
  [get_bd_pins ps7_0_axi_periph/ARESETN] \
  [get_bd_pins ps7_0_axi_periph/S00_ARESETN] \
  [get_bd_pins ps7_0_axi_periph/M00_ARESETN] \
  [get_bd_pins axi_mem_intercon/ARESETN] \
  [get_bd_pins axi_mem_intercon/S00_ARESETN] \
  [get_bd_pins axi_mem_intercon/M00_ARESETN] \
  [get_bd_pins axi_dma_0/axi_resetn] \
  [get_bd_pins ps7_0_axi_periph/M01_ARESETN] \
  [get_bd_pins ps7_0_axi_periph/M02_ARESETN] \
  [get_bd_pins axi_gpio_0/s_axi_aresetn] \
  [get_bd_pins axi_gpio_1/s_axi_aresetn] \
  [get_bd_pins ps7_0_axi_periph/M03_ARESETN]
  connect_bd_net -net sawtooth_ramp_gen_0_sync_trigger  [get_bd_pins sawtooth_ramp_gen_0/sync_trigger] \
  [get_bd_pins c_counter_binary_0/SCLR]
  connect_bd_net -net sr_tlast_Q  [get_bd_pins sr_tlast/Q] \
  [get_bd_pins xfft_range/s_axis_data_tlast]
  connect_bd_net -net sr_tvalid_Q  [get_bd_pins sr_tvalid/Q] \
  [get_bd_pins xfft_range/s_axis_data_tvalid]
  connect_bd_net -net sys_clock_1  [get_bd_ports sys_clock] \
  [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net win_slice_0_Dout  [get_bd_pins win_slice_0/Dout] \
  [get_bd_pins ilconcat_0/In0]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins ZmodAWGController_0/sTestMode]
  connect_bd_net -net xlconstant_1_dout  [get_bd_pins xlconstant_1/dout] \
  [get_bd_pins ZmodAWGController_0/sDAC_EnIn]
  connect_bd_net -net xlconstant_2_dout  [get_bd_pins xlconstant_2/dout] \
  [get_bd_pins sawtooth_ramp_gen_0/enable]

  # Create address segments
  assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force


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

