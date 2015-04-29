// $Id: $
// File name:   tb_wrapper.sv
// Created:     4/28/2015
// Author:      Kyunghoon Jung
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for wrapper.sv

`timescale 1ns / 10ps

module tb_wrapper();
  
  reg tb_clk;
  reg tb_n_rst;
  reg [31:0] tb_op1;
  reg [31:0] tb_op2;
  reg [2:0] tb_op_sel;
  reg [31:0] tb_result;
  reg tb_done;
  reg tb_overflow;
  reg tb_op_strobe;
  
  wrapper DUT(
  .clk(tb_clk),
  .n_rst(tb_n_rst),
  .op1(tb_op1),
  .op2(tb_op2),
  .op_sel(tb_op_sel),
  .result(tb_result),
  .done(tb_done),
  .overflow(tb_overflow)
  );
  
  always
  begin
  tb_clk = 1;
  #50;
  tb_clk = 0;
  #50;
  end
  
  
  task push;
    input [31:0] t_op1;
    input [31:0] t_op2;
    input [2:0] t_op_sel;
    
    tb_op1 = t_op1;
    tb_op2 = t_op2;
    tb_op_sel = t_op_sel;
    
    #100
    tb_op_strobe = 1;
    #100
    tb_op_strobe = 0;
  endtask
  
  
  initial
  begin
    
    tb_op_strobe = 0;
    
    #5;
    tb_n_rst = 1;
    push(32'b00000000000000000000000000000001,32'b00000000000000000000000000000001,3'b001);
    push(32'b00000000000000000000000000001111,32'b00000000000000000000000000001111,3'b010);
    push(32'b00000000000000000000000000000011,32'b00000000000000000000000000000011,3'b100);
    push(32'b00000000000000000000000000000001,32'b00000000000000000000000000000001,3'b000);
    push(32'b00000000000000000000000000000011,32'b00000000000000000000000000000011,3'b011);
    push(32'b00000000000000000000000000000111,32'b00000000000000000000000000000111,3'b111);
    push(32'b00000000000000000000000000000001,32'b00000000000000000000000000000001,3'b000);
    #10;
  end
    
  
endmodule