// $Id: $
// File name:   tb_addsub.sv
// Created:     3/28/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: testbench for add/sub

`timescale 1ns/10ps
module tb_addsub();

localparam	CLK_PERIOD	= 5;
localparam	CHECK_DELAY = 1; 

reg tb_clk, tb_nReset, tb_add_start, tb_add_done, tb_mode, tb_add_overflow;
reg [31:0] tb_op1;
reg [31:0] tb_op2;
reg [31:0] tb_add_result;

addsub ADDSUB(
  .clk(tb_clk), .n_rst(tb_nReset), .add_start(tb_add_start), 
  .mode(tb_mode), .op1(tb_op1), .op2(tb_op2), .add_result(tb_add_result),
  .add_done(tb_add_done), .add_overflow(tb_add_overflow)
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
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
 	tb_nReset = 1;
 	#(10*CHECK_DELAY);
 
  $display("\n----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001000000000000000000000;
  tb_op2 = 32'b01000000011000000000000000000000;
  $display("correct result:              01000000110000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
 	#(10*CHECK_DELAY);
 
  	
  $display("\n----------- pos/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b01000001001000000000000000000000;
  tb_op2 = 32'b11000000101000000000000000000000;
  $display("correct result:              01000000101000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  #(10*CHECK_DELAY);
  
  
 end
 endmodule
 /* $display("----------- reset -----------");
  @(negedge tb_clk);
  tb_nReset = 0;
  $display("correct result:              00000000000000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
 	tb_nReset = 1;
 	#(10*CHECK_DELAY);
 
  $display("\n----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001000000000000000000000;
  tb_op2 = 32'b01000000011000000000000000000000;
  $display("correct result:              01000000110000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
 	#(10*CHECK_DELAY);
 	
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000001011001000000000000000000;
  tb_op2 = 32'b00111111010000000000000000000000;
  $display("\ncorrect result:              01000001011100000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  #(10*CHECK_DELAY);
 
  $display("\n----------- pos/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b01000001001000000000000000000000;
  tb_op2 = 32'b11000000101000000000000000000000;
  $display("correct result:              01000000101000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  #(10*CHECK_DELAY);
  
  $display("\n----------- neg/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b11000000101000000000000000000000;
  tb_op2 = 32'b11000000010000000000000000000000;
  $display("correct result:              11000001000000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  #(10*CHECK_DELAY);
  end
endmodule 
*/