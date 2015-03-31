// $Id: $
// File name:   addsub.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: add and subtract module

module addsub(
input wire clk, n_rst, add_start, mode,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] add_result,
output reg add_done, add_overflow
);

reg sign;
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] exp;
reg [23:0] f1;
reg [23:0] f2;
reg [22:0] frac;


always_ff @ (posedge clk, negedge n_rst) 
begin
  
if (n_rst == 0) begin
      add_result = 0;
      add_overflow = 0;
      add_done = 0;
    end
else begin

add_done = 0;

exp1 = op1[30:23];
exp2 = op2[30:23];
f1 = op1[22:0];
f2 = op2[22:0];

sign = op1[31] ^ op2[31];
exp = exp1 - exp2;
frac = f1+f2;
add_result = {exp, frac};
add_done = 1;

end
end
endmodule


/*
op1: 0 01111111 01000000 		00000000 0000 000
op2: 0 01111111 10000000 		00000000 0000 000 (>> 2 at bit 9)
	 ----------- ---------
res: 0 10000000 01100000 		00000000 0000 000



op1: 0 01111111 10000000 		000000000000000
op2: 0 01111111 01000000 		000000000000000 (flip and +1)
	   0 01111111 01000000 		000000000000000
	  ---------- ---------
res: 0 01111101 00000000 		000000000000000


 1.25  		00111111101000000000000000000000
+1.50 		 00111111110000000000000000000000
 2.75		  01000000001100000000000000000000

 1.50 		 00111111110000000000000000000000
-1.25  		00111111101000000000000000000000
 0.25 		 00111110100000000000000000000000
*/