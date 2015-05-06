// $Id: $
// File name:   tb_multiple.sv
// Created:     3/28/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: testbench for multiply

`timescale 1ns/10ps
module tb_multiple();

localparam	CLK_PERIOD	= 4ns;
localparam	CHECK_DELAY = 2ns;

reg tb_clk, tb_nReset, tb_mul_start, tb_mul_done, tb_mul_overflow, tb_mul_serv, tb_busy;
reg [31:0] tb_op1;
reg [31:0] tb_op2;
reg [31:0] tb_mul_result;
reg [47:0] tb_mul;

multiple MULTI(
          .clk(tb_clk), 
          .n_rst(tb_nReset),
          .mul_start(tb_mul_start),
          .mul_done(tb_mul_done),
          .op1(tb_op1),
          .op2(tb_op2),
          .mul_result(tb_mul_result),
          .mul_serv(tb_mul_serv),
          .mul_busy(tb_busy)
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
  #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);


  $display("\n----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111101000000000000000000000;
  tb_op2 = 32'b00111111110000000000000000000000;
  tb_nReset = 1;
  $display("correct result:              00111111111100000000000000000000");
   #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);


 	$display("\n\n----------- pos/pos -----------");
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000000000000000000000000000000;
  tb_op2 = 32'b01000000010000000000000000000000;
  $display("correct result:              01000000110000000000000000000000");
   #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);

  $display("\n\n----------- pos/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b00111111100000000000000000000000;
  tb_op2 = 32'b11000000110000000000000000000000;
  $display("correct result:              11000000110000000000000000000000");
  #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);


  $display("\n\n----------- neg/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b11000000010000000000000000000000;
  tb_op2 = 32'b11000000100000000000000000000000;
  $display("correct result:              01000001010000000000000000000000");  
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);

/*
  $display("\n\n----------- neg/neg -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000000011111111111111111111111;
  tb_op2 = 32'b11000000101111111111111111111111;
  $display("correct result:              ?");  
   #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
 
 $display("\n\n----------- pi/4^2 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111010010010000111111011011;
  tb_op2 = 32'b00111111010010010000111111011011;
  $display("correct result:              ?");  
  #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
 

  $display("\n\n----------- 0.36685002^2 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111110101110111101001111000100;
  tb_op2 = 32'b00111110101110111101001111000100;
  $display("correct result:              ?");  
  #(8*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_mul_done, tb_mul_result);
 
*/

  end
endmodule 
