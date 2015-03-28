// $Id: $
// File name:   indecode.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: operation decoder 

module indecode(
input wire op_strobe,
input reg [31:0] op1,
input reg [31:0] op2,
input reg [2:0] op_sel,
output reg [31:0] op1_out,
output reg [31:0] op2_out,
output reg add_start, mul_start, sine_start, opcode_out, read_data
);

endmodule