#include <iostream>
#include "fmcw_ramp_gen.h"

int main() {
    hls::stream<axis_word_t> test_stream("test_stream");
    ap_uint<1> sync_trig = 0;

    // Chirp configuration parameters
    ap_uint<14> min_code  = 1000;    // e.g., Low Vtune limit
    ap_uint<14> max_code  = 5000;    // e.g., High Vtune limit
    ap_uint<14> step      = 100;     // Slope: 100 counts/cycle
    ap_uint<1>  enable_ip = 1;

    std::cout << "=============================================" << std::endl;
    std::cout << "   FMCW Ramp Generator C-Simulation Test     " << std::endl;
    std::cout << "=============================================" << std::endl;

    int total_cycles = 100;
    int ramp_restarts = 0;

    for (int cycle = 0; cycle < total_cycles; cycle++) {
        fmcw_ramp_gen(test_stream, sync_trig, min_code, max_code, step, enable_ip);

        if (!test_stream.empty()) {
            axis_word_t word = test_stream.read();
            ap_uint<14> dac_data = word.data(13, 0);

            std::cout << "Tick " << cycle 
                      << " | DAC Code: " << dac_data 
                      << " | TLAST: " << word.last 
                      << " | SYNC: " << sync_trig 
                      << std::endl;

            if (sync_trig == 1) {
                ramp_restarts++;
            }
        }
    }

    std::cout << "Simulation completed. Number of full chirps generated: " << ramp_restarts << std::endl;

    if (ramp_restarts > 0) {
        std::cout << "[PASS] Testbench executed successfully." << std::endl;
        return 0;
    } else {
        std::cout << "[FAIL] No ramps detected." << std::endl;
        return -1;
    }
}