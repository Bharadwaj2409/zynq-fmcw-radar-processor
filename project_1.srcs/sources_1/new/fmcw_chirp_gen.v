`timescale 1ns / 1ps

module fmcw_chirp_gen (
    input  wire        clk,          // Connect to clk_wiz_0/clk_out4 (100 MHz DAC domain)
    input  wire        rst_n,        // Connect to rst_clk_wiz_dac/peripheral_aresetn
    
    // Tuning settings (tie to constants or AXI GPIO)
    input  wire [13:0] min_val,      // Minimum DAC code (e.g. 14'd0)
    input  wire [13:0] max_val,      // Maximum DAC code (e.g. 14'd16383)
    input  wire [13:0] step_size,    // Ramp increment per cycle (e.g. 14'd1)
    input  wire        enable,       // 1'b1
    
    // Direct connection to ZmodAWGController
    output reg  [31:0] dac_tdata,    // Wire to ZmodAWGController_0/cDataAxisTdata
    output wire        dac_tvalid,   // Wire to ZmodAWGController_0/cDataAxisTvalid
    input  wire        dac_tready,   // Wire to ZmodAWGController_0/cDataAxisTready
    
    // Sync Trigger for ADC Windowing Alignment
    output reg         sync_trigger  // Wire to c_counter_binary_0/SCLR
);

    reg [13:0] current_val;

    assign dac_tvalid = enable;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_val  <= min_val;
            dac_tdata    <= 32'd0;
            sync_trigger <= 1'b0;
        end else if (enable) begin
            dac_tdata <= {18'd0, current_val};
            
            if ((current_val + step_size) >= max_val) begin
                current_val  <= min_val;
                sync_trigger <= 1'b1; // Trigger at start of sweep
            end else begin
                current_val  <= current_val + step_size;
                sync_trigger <= 1'b0;
            end
        end else begin
            current_val  <= min_val;
            dac_tdata    <= {18'd0, min_val};
            sync_trigger <= 1'b0;
        end
    end

endmodule