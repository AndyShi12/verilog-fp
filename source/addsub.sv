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

////////////////////////////////////////////////////////////////////////////////////////////////////////////// Same exponential
if (exp1 == exp2) begin 
  $display("exp1 is %b, exp2 is %b",exp1, exp2);
  
  if(op1[31] == op2[31]) begin
    frac = f1+f2;
    $display("##################op1 == op2");
  end
  else begin
    if (op1[31] == 0 && op2[31] == 1) begin
      $display("##################op1 != op2, +/-");
      $display("CHECK EXPONENTS");
      frac = f1-f2;
      $display("NEW fraction is %b, from %b - %b", frac, f1, f2);
     
      if(f1 < f2)
        sign = 1;
      else
        sign = 0;     
    end
    
    if (op1[31] == 1 && op2[31] == 0) begin
      $display("##################op1 != op2, -/+");
      $display("CHECK EXPONENTS");
      frac = f2-f1;
      $display("NEW fraction is %b, from %b - %b", frac, f2, f1);
      if(f1 > f2)
        sign = 1;
      else
        sign = 0;
    end 
  end
  
   if (frac[24] == 1)
      exp = exp1 + 1'b1;
    else
      exp = exp1;
      
    if ((op1[31] != op2[31]) && (f1 == f2)) begin
      $display("##################op1 != op2, f1=f2");
      exp = exp1 - exp2;
      ans = 32'b0000;
    end 
 
   $display("NEW exp1 = %b, exp2 = %b, final exp = %b", exp1, exp2, exp);
  ans = {sign, exp, frac[23:1]};
end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////// exp1 > exp2
else if (exp1 > exp2) begin
  //$display("TOP is bigger");
  expDiff = exp1 - exp2;
  $display("ORIGINAL f1 is %b, f2 is %b", f1, f2);
  $display("exp1 is %b, exp2 is %b, difference is %b",exp1, exp2, expDiff);
  f2 = f2 >> expDiff;
  $display("New      f1 is %b, f2 is %b", f1, f2);
  //$display("NEW f2 is %b", f2,);
  
  frac = f1 + f2;
 //   $display("f1 is %b, f2 is %b, sum is %b", f1, f2, frac);
  
   if (op1[31] == 0 && op2[31] == 1) begin
      frac = f1-f2;
      $display("NEW fraction is %b, from %b - %b", frac, f1, f2);
   end
  
   if (op1[31] == 1 && op2[31] == 0) begin
      frac = f2-f1;
      $display("NEW fraction is %b, from %b - %b", frac, f2, f1);
   end
   
  if (frac[24] == 1)
  exp = exp1 + 1'b1;
  else
  exp = exp1;

  sign = op1[31];
  
  $display("NEW exp1 = %b, exp2 = %b, final exp = %b", exp1, exp2, exp);
  ans = {sign, exp, frac[22:0]};
  end
  
  else begin
  //////////////////////////////////////////////////////////// exp1 < exp2
 // $display("TOP is smaller");
  expDiff = exp2 - exp1;
  $display("exp1 is %b, exp2 is %b, difference is %b",exp1, exp2, expDiff);
  $display("ORIGINAL f1 is %b, f2 is %b", f1, f2);
  f1 = f1 >> expDiff;
  $display("New      f1 is %b, f2 is %b", f1, f2);
  
  frac = f1 + f2;
 //   $display("f1 is %b, f2 is %b, sum is %b", f1, f2, frac);

   if (op1[31] == 0 && op2[31] == 1) begin
      frac = f1-f2;
      $display("NEW fraction is %b, from %b - %b", frac, f1, f2);
   end
  
   if (op1[31] == 1 && op2[31] == 0) begin
      frac = f2-f1;
      $display("NEW fraction is %b, from %b - %b", frac, f2, f1);
   end
   
  if (frac[24] == 1)
  exp = exp2 + 1'b1;
  else
  exp = exp2;  
  

  sign = op2[31];
        $display("NEW exp1 = %b, exp2 = %b, final exp = %b", exp1, exp2, exp);
  ans = {sign, exp, frac[22:0]};
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
