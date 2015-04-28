// $Id: $
// File name:   addsub.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: add and subtract module

module addsub(
input wire clk, n_rst,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] add_result,
output reg add_done, add_overflow
);

bit sign;
byte n, i, msbFound;
reg [7:0] exp;
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] expDiff;
reg [24:0] frac;
reg [23:0] f1;
reg [23:0] f2;
reg [24:0] tempFrac;
reg [7:0] tempExp;

always_comb
begin
    
if (n_rst == 0) begin
    add_result = 32'b00000000000000000000000000000000;
    add_done = 0;
    add_overflow = 1;
end
else begin

exp1 = op1[30:23];
exp2 = op2[30:23];
f1 = {1,op1[22:0]};
f2 = {1,op2[22:0]};
sign = 0;

////////////// SAME EXPONENT //////////////////   
  if (exp1 == exp2) begin 
   exp = exp1;

  //////////// SAME SIGN  /////////////
    if(op1[31] == op2[31]) begin
        frac = f1+f2;
        sign = op1[31];
          if (frac[24] == 1)
          exp = exp1 + 1'b1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
        if (f1 > f2) begin
          frac = f1-f2;
              if (op1[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2[31] == 1)
                sign = 1;
        end
      frac = frac << 2;
      tempFrac = frac;
      tempExp = exp;
      findMSB (tempFrac, tempExp, frac, exp);
      exp = exp - 1'b1;
    end
    add_result = {sign, exp, frac[23:1]};
    
  //////////// SAME VALUE +/- /////////////
  if ((op1[31] != op2[31]) && (f1 == f2)) begin
      add_result = 32'b0000;
  end 
end


else if (exp1 > exp2) begin
//$display("\n///////////////////// A > B /////////////////////");
 sign = op1[31];
 expDiff = exp1 - exp2;
 f2 = f2 >> expDiff;
 exp = exp1;
  if(op1[31] == op2[31]) begin
         frac = f1+f2;
         if (frac[24] == 1)
          exp = exp1 + 1'b1;
          frac = frac << 1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
          if (f1 > f2) begin
          frac = f1-f2;
              if (op1[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2[31] == 1)
                sign = 1;
        end
 
  frac = frac << 1;
  tempFrac = frac;
  tempExp = exp;
  findMSB (tempFrac, tempExp, frac, exp);
   end
    add_result = {sign, exp, frac[23:1]};
end

else begin
//$display("\n\n\n///////////////////// A < B /////////////////////");
 sign = op2[31];
 expDiff = exp2 - exp1;
 f1 = f1 >> expDiff;
 exp = exp2;

 if(op1[31] == op2[31]) begin
        frac = f1+f2;
        
         if (frac[24] == 1)
          exp = exp1 + 1'b1;
          frac = frac << 1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
          if (f1 > f2) begin
          frac = f1-f2;
              if (op1[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2[31] == 1)
            sign = 1;
        end
 
  frac = frac << 1;
  tempFrac = frac;
  tempExp = exp;
  findMSB (tempFrac, tempExp, frac, exp);
  end
  add_result = {sign, exp, frac[23:1]};
end
end
end


task findMSB(
input reg [24:0] frac,
input reg [7:0] exp,
output reg [24:0] outFrac,
output reg [7:0] outExp
);
begin
reg [24:0] tempFrac;
byte msbFound;
tempFrac = frac;
msbFound = 0;

if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
               msbFound = 1;
         end
 end
outFrac = frac;
outExp = exp;
end
endtask

endmodule

