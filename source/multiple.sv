// $Id: $
// File name:   multiple.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: multiply module

module multiple(
input wire clk, n_rst, mul_start,
input reg mul_serv,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] mul_result,
output reg mul_done, mul_busy
);

bit sign;
reg [23:0] m1;
reg [23:0] m2;
reg [7:0] exp;
reg [47:0] mul;

always_comb
begin
if (n_rst == 0) begin
    mul_result = 32'b00000000000000000000000000000000;
    mul_done = 0;

end
else begin
// send start signal
mul_done = 0;
mul_busy = 1;
// determine exponent
exp = op1[30:23] + op2[30:23];
exp = exp - 8'b01111111;
// determine mantissa
m1 = {1,op1[22:0]};
m2 = {1,op2[22:0]};
mul = m1 * m2;
// determine sign
sign = op1[31] ^ op2[31];
// set result
if(mul[47] == 1) begin
	mul = mul >> 1;
	exp = exp + 1'b1;
end
mul_result = {sign, exp, mul[45:23]}; 
// send complete signal
mul_done = 1;
mul_busy = 0;
end
end

endmodule


//always_ff @ (posedge clk, negedge n_rst) 
//begin
//if (n_rst == 0) begin
 //   mul_result <= 32'b00000000000000000000000000000000;
  //  mul_done <= 0;
   // mul_overflow <= 1;
  //end
//end
//  else
//    begin
//    mul_overflow <= 0;
//    mul_done <= 1;
//    mul_result <= ans;
//    end
//end