// $Id: $
// File name:   wrapper.sv
// Created:     4/22/2015
// Author:      Kyunghoon Jung
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Wrapper file for floating point co-processor

module wrapper(
  input wire clk,
  input wire n_rst,
  input wire [31:0] op1,
  input wire [31:0] op2,
  input wire [2:0] op_sel,
  output reg [31:0] result,
  output reg done,
  output reg overflow
  );
  
  
  // Input Decode
  reg op_strobe;
  reg out_fifo_hold;
  reg add_busy;
  reg mul_busy;
  reg sine_busy;
  reg [31:0] op1_out;
  reg [31:0] op2_out;
  reg add_start;
  reg mul_start;
  reg sine_start;
  reg cpu_hold;
  reg [2:0] opcode_out;
  
  // Addition/Subtraction
  reg add_done;
  reg add_overflow;
  reg add_result;
  
  // Multiply
  reg mul_result;
  reg mul_done;
  reg mul_overflow;
  
  // Sine/Cosine
  reg sine_result;
  reg cosine_result;
  reg sincos_done;
  
  // Output Decode
  reg fifo_out;
  
  indecode INPUT(
  .clk(clk),
  .n_rst(n_rst),
  .op_strobe(op_strobe),
  .op1(op1),
  .op2(op2),
  .op_sel(op_sel),
  .out_fifo_hold(out_fifo_hold),
  .add_busy(add_busy),
  .mul_busy(mul_busy),
  .sine_busy(sine_busy),
  .add_start(add_start),
  .mul_start(mul_start),
  .sine_start(sine_start),
  .cpu_hold(cpu_hold),
  .opcode_out(opcode_out)
  );
  
  addsub ADD_SUB(
  .clk(clk),
  .n_rst(n_rst),
  .op1(op1_out),
  .op2(op2_out),
  .add_result(add_result),
  .add_done(add_done),
  .add_overflow(add_overflow)
  );
  
  multiple MUL(
  .clk(clk),
  .n_rst(n_rst),
  .op1(op1_out),
  .op2(op2_out),
  .mul_result(mul_result),
  .mul_done(mul_done),
  .mul_overflow(mul_overflow)
  );
  
  sincos TRIG(
  .clk(clk),
  .n_rst(n_rst),
  .opx(opx),
  .sine_result(sine_result),
  .cosine_result(cosine_result),
  .done(sincos_done)
  );
  
  outdecode OUTPUT(
  .add_result(add_result),
  .mul_result(mul_result),
  .sine_result(sine_result),
  .add_done(add_done),
  .mul_done(mul_done),
  .sine_done(sine_done),
  .add_overflow(add_overflow),
  .mul_overflow(mul_overflow),
  .fifo_out(fifo_out),
  .result(result),
  .done(done),
  .overflow(overflow)
  );
  
  
  
  
endmodule