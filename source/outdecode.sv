// $Id: $
// File name:   outdecode.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: system level output module

module outdecode(
input reg [31:0] add_result,
input reg [31:0] mul_result,
input reg [31:0] sine_result,
input wire add_done, mul_done, sine_done, add_overflow, mul_overflow,
input reg [2:0] fifo_out,
output reg [31:0] result,
output wire done, overflow
);

endmodule