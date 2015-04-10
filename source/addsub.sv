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
reg [7:0] expDiff;
reg [7:0] exp;

reg [23:0] f1;
reg [23:0] f2;
reg [24:0] frac;
reg [31:0] ans;

always_ff @ (posedge clk, negedge n_rst) 
begin
    if (n_rst == 0) begin
      add_result <= 0;
      add_overflow <= 0;
      add_done <= 0;
    end
    else begin
      add_result <= ans;
      add_overflow <= 0;
      add_done <= 1;
    end
end
  

always_comb
begin
    
exp1 = op1[30:23];
exp2 = op2[30:23];
f1 = {1,op1[22:0]};
f2 = {1,op2[22:0]};
sign = op1[31];
    
////////////// SAME EXPONENT //////////////////   
if (exp1 == exp2) begin 
$display("///////////////////// SAME EXP /////////////////////");
   exp = exp1;
   sign = 0;

   //////////// SAME SIGN  /////////////
   if(op1[31] == op2[31]) begin
   $display("##############same sign");
      frac = f1+f2;
        if (frac[24] == 1)
        exp = exp1 + 1'b1;
   end
   //////////// POS/NEG  /////////////
   else if (op1[31] == 0 && op2[31] == 1) begin
     $display("##############pos/neg");
   end
  //////////// NEG/POS /////////////
   else begin
      $display("##############neg/pos");
   end
   
    //////////// SAME VALUE /////////////
    if ((op1[31] != op2[31]) && (f1 == f2)) begin
      $display("##############same value pos/neg");
    end 
end





else if (op1[31] == 1 && op2[31] == 0) begin
$display("///////////////////// NEG/POS /////////////////////");

end





else begin
$display("///////////////////// POS/NEG /////////////////////");
end

    
////////////////////////////////////////////////////////////////////////////////////////////////////////////// Same exponential
end
endmodule



/*
op1: 0 01111111 01000000    00000000 0000 000
op2: 0 01111111 10000000    00000000 0000 000 (>> 2 at bit 9)
   ----------- ---------
res: 0 10000000 01100000    00000000 0000 000



op1: 0 01111111 10000000    000000000000000
op2: 0 01111111 01000000    000000000000000 (flip and +1)
     0 01111111 01000000    000000000000000
    ---------- ---------
res: 0 01111101 00000000    000000000000000


 1.25     00111111101000000000000000000000
+1.50      00111111110000000000000000000000
 2.75     01000000001100000000000000000000

 1.50      00111111110000000000000000000000
-1.25     00111111101000000000000000000000
 0.25      00111110100000000000000000000000
*/
