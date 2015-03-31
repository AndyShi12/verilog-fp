// $Id: $
// File name:   tb_multiple.sv
// Created:     3/28/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: testbench for multiply

`timescale 1ns/10ps
module tb_multiple();

localparam	CLK_PERIOD	= 2.5;
localparam	CHECK_DELAY = 1; 

reg tb_clk, tb_nReset, tb_mul_start, tb_mul_done, tb_mul_overflow;
reg [31:0] tb_op1;
reg [31:0] tb_op2;
reg [31:0] tb_mul_result;

multiple MULTI(
          .clk(tb_clk), 
          .n_rst(tb_nReset),
          .mul_start(tb_mul_start),
          .mul_done(tb_mul_done),
          .mul_overflow(tb_mul_overflow),
          .op1(tb_op1),
          .op2(tb_op2),
          .mul_result(tb_mul_result)
         );

always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
initial
  begin
  
  $display("----------- reset -----------");
  @(negedge tb_clk);
  tb_nReset = 0;
  $display("correct result:              00000000000000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
 	tb_nReset = 1;
 	#(10*CHECK_DELAY);
 
  $display("\n----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111101000000000000000000000;
  tb_op2 = 32'b00111111110000000000000000000000;
  $display("correct result:              00111111111100000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
 	#(10*CHECK_DELAY);
 	
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000000000000000000000000000000;
  tb_op2 = 32'b01000000010000000000000000000000;
  $display("correct result:              01000000110000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
  #(10*CHECK_DELAY);
 
  $display("\n----------- pos/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b00111111100000000000000000000000;
  tb_op2 = 32'b11000000110000000000000000000000;
  $display("correct result:              11000000110000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
  #(10*CHECK_DELAY);
  
  $display("\n----------- neg/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b11000000010000000000000000000000;
  tb_op2 = 32'b11000000100000000000000000000000;
  $display("correct result:              01000001010000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
  #(10*CHECK_DELAY);
  end
endmodule 