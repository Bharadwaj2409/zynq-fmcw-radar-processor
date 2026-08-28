#ifndef FMCW_RAMP_GEN_H_
#define FMCW_RAMP_GEN_H_

#include <ap_int.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>

typedef ap_axis<32,0,0,0> axis_word_t;

void fmcw_ramp_gen(hls::stream<axis_word_t> &dac_stream,  
  ap_uint<1> &sync_trigger,   ap_uint<14> min_val,
   ap_uint<14> max_val,  ap_uint<14> step_size, ap_uint<1>  enable);

#endif //FMCW_RAMP_GEN_H

