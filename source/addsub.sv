// $Id: $
// File name:   addsub.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: add and subtract module

module addsub(
input wire clk, n_rst,
input reg add_serv,
input reg add_start,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] add_result,
output reg add_done, add_busy
);

reg [31:0]op1_r;
reg [31:0]op2_r;
reg [31:0]result;

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
reg [2:0] count;
reg done;
reg [2:0] next;

assign add_result = result;
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    op1_r <= 0;
    op2_r <= 0;
  end else begin
    if(add_start) begin
      op1_r <= op1;
      op2_r <= op2;
    end else begin
      op1_r <= op1_r;
      op2_r <= op2_r;
    end
  end
end

always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    count <= 0;
    add_done <= 0;
  end else begin
    count <= next;
    if(add_done) begin
      if(add_serv) begin
        add_done <= 0;
      end else begin
        add_done <= 1;
      end
    end else begin
      add_done <= done;
    end
  end
end

always_comb
begin
  case(count)
    0:
  begin
    add_busy = 0;
    done = 0;
    if(add_start) begin
      next = 1;
    end else begin
      next = 0;
    end
  end
    1:
  begin
    next = 2;
    add_busy = 1;
    done = 0;
  end
    2:
  begin
    next = 3;
    add_busy = 1;
    done = 0;
  end
    3:
  begin
    next = 4;
    add_busy = 1;
    done = 0;
  end
    4:
  begin
    next = 5;
    add_busy = 1;
    done = 0;
  end
    5:
  begin
    next = 0;
    add_busy = 1;
    done = 1;
  end
endcase
end




always_comb
begin    
if (n_rst == 0) begin
    result = 32'b00000000000000000000000000000000;
end
else begin

exp1 = op1_r[30:23];
exp2 = op2_r[30:23];
f1 = {1,op1_r[22:0]};
f2 = {1,op2_r[22:0]};
sign = 0;

////////////// SAME EXPONENT //////////////////   
  if (exp1 == exp2) begin 
   exp = exp1;

  //////////// SAME SIGN  /////////////
    if(op1_r[31] == op2_r[31]) begin
        frac = f1+f2;
        sign = op1_r[31];
          if (frac[24] == 1)
          exp = exp1 + 1'b1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
        if (f1 > f2) begin
          frac = f1-f2;
              if (op1_r[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2_r[31] == 1)
                sign = 1;
        end
      frac = frac << 2;
      tempFrac = frac;
      tempExp = exp;
      findMSB (tempFrac, tempExp, frac, exp);
      exp = exp - 1'b1;
    end
    result = {sign, exp, frac[23:1]};
    
  //////////// SAME VALUE +/- /////////////
  if ((op1_r[31] != op2_r[31]) && (f1 == f2)) begin
      result = 32'b0000;
  end 
end


else if (exp1 > exp2) begin
//$display("\n///////////////////// A > B /////////////////////");
 sign = op1_r[31];
 expDiff = exp1 - exp2;
 f2 = f2 >> expDiff;
 exp = exp1;
  if(op1_r[31] == op2_r[31]) begin
         frac = f1+f2;
         if (frac[24] == 1)
          exp = exp1 + 1'b1;
          frac = frac << 1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
          if (f1 > f2) begin
          frac = f1-f2;
              if (op1_r[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2_r[31] == 1)
                sign = 1;
        end
 
  frac = frac << 1;
  tempFrac = frac;
  tempExp = exp;
  findMSB (tempFrac, tempExp, frac, exp);
   end
    result = {sign, exp, frac[23:1]};
end

else begin
//$display("\n\n\n///////////////////// A < B /////////////////////");
 sign = op2_r[31];
 expDiff = exp2 - exp1;
 f1 = f1 >> expDiff;
 exp = exp2;

 if(op1_r[31] == op2_r[31]) begin
        frac = f1+f2;
        
         if (frac[24] == 1)
          exp = exp1 + 1'b1;
          frac = frac << 1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
          if (f1 > f2) begin
          frac = f1-f2;
              if (op1_r[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2_r[31] == 1)
            sign = 1;
        end
 
  frac = frac << 1;
  tempFrac = frac;
  tempExp = exp;
  findMSB (tempFrac, tempExp, frac, exp);
  end
  result = {sign, exp, frac[23:1]};
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

