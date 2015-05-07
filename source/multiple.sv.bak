// $Id: $
// File name:   multiple.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: multiply module

module multiple(
input wire clk, n_rst, mul_start,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] mul_result,
output reg mul_done, mul_overflow
);

reg overflow;
bit sign;
reg [7:0] exp;
reg [7:0] bias = 8'b01111111;
reg [23:0] m1;
reg [23:0] m2;
reg [47:0] mul;
reg [22:0] frac;
reg [31:0] ans;

always_ff @ (posedge clk, negedge n_rst) 
begin
if (n_rst == 0) begin
    mul_result <= '0;
    mul_done <= 0;
    mul_overflow <= 1;
  end
  else
    begin
    mul_overflow <= 0;
    mul_done <= 1;
    mul_result <= ans;
    end
end
 
always_comb
begin

exp = op1[30:23] + op2[30:23] - bias;
m1 = {1,op1[22:0]};   
m2 = {1,op2[22:0]};  
mul = m1 * m2;


sign = op1[31] ^ op2[31];


ans = {sign, exp, mul[45:23]};
end

endmodule


//$display("sign bit: %b", op1[31] ^ op2[31]);
//$display("new exp = %b", exp);
//$display("frac = %b", mul[45:26]);


/*
op1: 0 01111111 01000000 		00000000 0000000
op2: 0 01111111 10000000 		00000000 0000000 
	--------------------
res: 0 01111111 11100000		 00000000 0000000


op1: 0 01000000 00000000  	00000000 0000000
op2: 0 10000000 10000000   00000000 0000000
	 ---------- ---------
*/


/*
 1.25   00111111101000000000000000000000
*1.50 		00111111110000000000000000000000
 1.875		00111111111100000000000000000000

 2.0 		01000000000000000000000000000000
*3.0  	01000000010000000000000000000000
 6.0 		01000000110000000000000000000000
*/
