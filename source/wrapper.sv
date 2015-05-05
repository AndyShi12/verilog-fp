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
  input wire op_strobe,
  input wire cpu_pop,
  output wire cpu_hold,
  output reg [31:0] result
  );
  
  
  // Input Decode
  reg in_fifo_hold;
  reg add_busy;
  reg mul_busy;
  reg sine_busy;
  reg [31:0] op1_out;
  reg [31:0] op2_out;
  reg add_start;
  reg mul_start;
  reg sine_start;
  reg [2:0] opcode_out;
  reg opbuff_strobe;
  
  // Addition/Subtraction
  reg add_done;
  reg add_overflow;
  reg [31:0] add_result;
  reg add_serv;
  
  // Multiply
  reg [31:0] mul_result;
  reg mul_done;
  reg mul_overflow;
  reg mul_serv;
  
  // Sine/Cosine
  reg [31:0] sine_result;
  reg [31:0] cosine_result;
  reg sincos_done;
  reg [31:0] opx;
  reg sine_serv;
  
  // Output Decode
  reg out_fifo_hold;
  reg op_fifo_pop;
  reg [2:0] fifo_out;
  
  indecode INPUT(
  .clk(clk),
  .n_rst(n_rst),
  .op_strobe(op_strobe),
  .op1(op1),
  .op2(op2),
  .op_sel(op_sel),
  .out_fifo_hold(out_fifo_hold),
  .op1_out(op1_out),
  .op2_out(op2_out),
  .add_busy(add_busy),
  .mul_busy(mul_busy),
  .sine_busy(sine_busy),
  .add_start(add_start),
  .mul_start(mul_start),
  .sine_start(sine_start),
  .cpu_hold(cpu_hold),
  .opcode_out(opcode_out),
  .opbuff_strobe(opbuff_strobe)
  );
  
  addsub ADD_SUB(
  .clk(clk),
  .n_rst(n_rst),
  .op1(op1_out),
  .op2(op2_out),
  .add_result(add_result),
  .add_done(add_done),
  .add_start(add_start),
  .add_busy(add_busy),
  .add_serv(add_serv)
  );
  
  multiple MUL(
  .clk(clk),
  .n_rst(n_rst),
  .op1(op1_out),
  .op2(op2_out),
  .mul_result(mul_result),
  .mul_done(mul_done),
  .mul_start(mul_start),
  .mul_busy(mul_busy),
  .mul_serv(mul_serv)
  );
  
  /*
  sincos TRIG(
  .clk(clk),
  .n_rst(n_rst),
  .opx(opx),
  .sine_result(sine_result),
  .cosine_result(cosine_result),
  .done(sincos_done)
  );*/

  fifobuff BUFF(
    .clk(clk),
    .n_rst(n_rst),
    .read(op_fifo_pop),
    .write(opbuff_strobe),
    .opcode_in(opcode_out),
    .opcode_out(fifo_out)
  );
  
  outdecode OUTPUT(
  .clk(clk),
  .n_rst(n_rst),
  .add_result(add_result),
  .mul_result(mul_result),
  .sine_result(sine_result),
  .add_done(add_done),
  .mul_done(mul_done),
  .sine_done(sine_done),
  .cpu_pop(cpu_pop),
  .fifo_out(fifo_out),
  .result(result),
  .out_fifo_hold(out_fifo_hold),
  .op_fifo_pop(op_fifo_pop),
  .add_serv(add_serv),
  .mul_serv(mul_serv),
  .sine_serv(sine_serv)
  );
  
  
  
  
endmodule
