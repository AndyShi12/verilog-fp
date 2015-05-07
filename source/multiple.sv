// $Id: $
// File name:   multiple.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: multiply module

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



/*
module multiple(
input wire clk, n_rst, mul_start,
input reg mul_serv,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] mul_result,
output reg mul_done, mul_busy
);

reg [31:0]op1_r;
reg [31:0]op2_r;

bit sign;
reg [23:0] m1;
reg [23:0] m2;
reg [7:0] exp;
reg [47:0] mul;
reg [2:0] count;
reg done;
reg [2:0] next;

always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    op1_r <= 0;
    op2_r <= 0;
  end else begin
    if(mul_start) begin
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
    mul_done <= 0;
  end else begin
    count <= next;
    if(mul_done) begin
      if(mul_serv) begin
        mul_done <= 0;
      end else begin
        mul_done <= 1;
      end
    end else begin
      mul_done <= done;
    end
  end
end

always_comb
begin
  case(count)
    0:
  begin
    mul_busy = 0;
    done = 0;
    if(mul_start) begin
      next = 1;
    end else begin
      next = 0;
    end
  end
    1:
  begin
    next = 2;
    mul_busy = 1;
    done = 0;
  end
    2:
  begin
    next = 3;
    mul_busy = 1;
    done = 0;
  end
    3:
  begin
    next = 4;
    mul_busy = 1;
    done = 0;
  end
    4:
  begin
    next = 5;
    mul_busy = 1;
    done = 0;
  end
    5:
  begin
    next = 0;
    mul_busy = 1;
    done = 1;
  end
endcase
end

always_comb
begin
if (n_rst == 0) begin
    mul_result = 32'b00000000000000000000000000000000;

end
else begin
// send start signal
// determine exponent
exp = op1_r[30:23] + op1_r[30:23];
exp = exp - 8'b01111111;
// determine mantissa
m1 = {1,op1_r[22:0]};
m2 = {1,op2_r[22:0]};
mul = m1 * m2;
// determine sign
sign = op1_r[31] ^ op1_r[31];
// set result
if(mul[47] == 1) begin
	mul = mul >> 1;
	exp = exp + 1'b1;
end
mul_result = {sign, exp, mul[45:23]}; 
// send complete signal
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
*/