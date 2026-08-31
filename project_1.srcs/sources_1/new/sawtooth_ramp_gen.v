`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2026 09:30:02 AM
// Design Name: 
// Module Name: sawtooth_ramp_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module sawtooth_ramp_gen #(
    parameter [13:0] RAMP_MIN  = 14'h0000,   // Min DAC voltage (Hex: 0x0000)
    parameter [13:0] RAMP_MAX  = 14'h3FFF,   // Max DAC voltage (Hex: 0x3FFF)
    parameter [13:0] RAMP_STEP = 14'h0001    // Step increment  (Hex: 0x0001)
)(
    input  wire        clk,                  // -> clk_wiz_0/clk_out4 (100 MHz)
    input  wire        rst_n,                // -> rst_clk_wiz_dac/peripheral_aresetn
    input  wire        enable,               // -> const_dac_en (1'b1)
    
    // AXI-Stream interface -> ZmodAWGController_0
    output wire [31:0] m_axis_tdata,         // -> ZmodAWGController_0/cDataAxisTdata
    output wire        m_axis_tvalid,        // -> ZmodAWGController_0/cDataAxisTvalid
    input  wire        m_axis_tready,        // <- ZmodAWGController_0/cDataAxisTready
    
    // FMCW sweep sync trigger -> ADC windowing
    output reg         sync_trigger          // -> c_counter_binary_0/SCLR
);

    reg [13:0] ramp_counter;

    assign m_axis_tvalid = enable;
    assign m_axis_tdata  = {18'h00000, ramp_counter};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ramp_counter <= RAMP_MIN;
            sync_trigger <= 1'b0;
        end else if (enable && m_axis_tready) begin
            if (ramp_counter >= (RAMP_MAX - RAMP_STEP)) begin
                ramp_counter <= RAMP_MIN;
                sync_trigger <= 1'b1;
            end else begin
                ramp_counter <= ramp_counter + RAMP_STEP;
                sync_trigger <= 1'b0;
            end
        end else begin
            sync_trigger <= 1'b0;
        end
    end

endmodule