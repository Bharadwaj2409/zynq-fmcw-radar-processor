#include "fmcw_ramp_gen.h"

void fmcw_ramp_gen(
    hls::stream<axis_word_t> &dac_stream,
    ap_uint<1>               &sync_trigger,
    ap_uint<14>              min_val,
    ap_uint<14>              max_val,
    ap_uint<14>              step_size,
    ap_uint<1>               enable
) {
    // -----------------------------------------------------------------------
    // Directives & Interface Protocols
    // -----------------------------------------------------------------------
    #pragma HLS INTERFACE mode=axis register_mode=both port=dac_stream
    #pragma HLS INTERFACE mode=ap_none port=sync_trigger
    #pragma HLS INTERFACE mode=s_axilite port=min_val      bundle=s_axi_control
    #pragma HLS INTERFACE mode=s_axilite port=max_val      bundle=s_axi_control
    #pragma HLS INTERFACE mode=s_axilite port=step_size    bundle=s_axi_control
    #pragma HLS INTERFACE mode=s_axilite port=enable       bundle=s_axi_control
    #pragma HLS INTERFACE mode=s_axilite port=return       bundle=s_axi_control

    #pragma HLS PIPELINE II=1 rewind

    // Persistent state between consecutive 100 MHz clock executions
    static ap_uint<14> current_val = 0;
    static ap_uint<1>  sync_pulse  = 0;

    axis_word_t out_word;

    if (!enable) {
        current_val = min_val;
        sync_pulse = 0;
        sync_trigger = 0;
        return;
    }

    // Assign current DAC amplitude (packed into lower 14 bits of 32-bit AXIS)
    out_word.data = (ap_uint<32>)current_val;
    out_word.keep = 0xF;
    out_word.strb = 0xF;

    // Check if chirp boundary is reached
    if ((current_val + step_size) >= max_val) {
        out_word.last = 1;
        current_val = min_val;   // Flyback / Retrace to start frequency
        sync_pulse = 1;          // Assert sync trigger at start of new sweep
    } else {
        out_word.last = 0;
        current_val += step_size;
        sync_pulse = 0;
    }

    sync_trigger = sync_pulse;
    dac_stream.write(out_word);
}