set SynModuleInfo {
  {SRCNAME fmcw_ramp_gen MODELNAME fmcw_ramp_gen RTLNAME fmcw_ramp_gen IS_TOP 1
    SUBMODULES {
      {MODELNAME fmcw_ramp_gen_s_axi_control_s_axi RTLNAME fmcw_ramp_gen_s_axi_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME fmcw_ramp_gen_regslice_both RTLNAME fmcw_ramp_gen_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
    }
  }
}
