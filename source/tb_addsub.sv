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
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] expT;
reg [7:0] expB;
  
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////// Same exponential

/*
  $display("\n----------- pos/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001000000000000000000000;
  tb_op2 = 32'b01000000011000000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000000110000000000000000000000");
 	#(10*CHECK_DELAY);
 	
 	$display("\n----------- pos/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001100000000000000000000;
  tb_op2 = 32'b01000000001100000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000000101100000000000000000000");
 	#(10*CHECK_DELAY);
 	
 	$display("\n----------- neg/neg (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b11000110000111000100001000111000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              11000110100111000100001000111000");
 	#(10*CHECK_DELAY);
 	
 	 	$display("\n----------- neg/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b01000110000111000100001000111000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              00000000000000000000000000000000");
 	#(10*CHECK_DELAY);

 */
 	
 	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
 	
 	
 	$display("\n-----------pos/pos -----------");
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000001010010000000000000000000;
  tb_op2 = 32'b01000001100011000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000001111100000000000000000000\n\n");
  #(10*CHECK_DELAY);
  
  
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000100000010101110001110000101;
  tb_op2 = 32'b01000011010111100011100011010101;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000100010000100111000110111010\n\n");
  #(10*CHECK_DELAY);
  
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000011010111100011100011010101;
  tb_op2 = 32'b01000100000010101110001110000101;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000100010000100111000110111010\n\n");
  #(10*CHECK_DELAY);
    
  
  $display("\n\n----------- pos/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000100011101011101010111100011;
 	tb_op2 = 32'b01000011010111100011101101101100;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000100100101101011001001011111");
  #(10*CHECK_DELAY);
  
   $display("\n\n----------- pos/pos, larger exp -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b01000011010111100011101101101100;
  tb_op2 = 32'b01000100011101011101010111100011;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000100100101101011001001011111");
  #(10*CHECK_DELAY);

  
  $display("\n\n----------- pos/pos -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b01000010111101101110100101111001;
  tb_op2 = 32'b01000100001000111001010010001011;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000100010000100111000110111010");
  #(10*CHECK_DELAY);
  
  	////////////////////////////////////////////////////////////////////////////////////////////////////////////// Sub exponential

 	


/*
	$display("\n\n----------- pos/neg (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000100001000000000000000000;
  tb_op2 = 32'b11000000100000000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              00111110000000000000000000000000");
 	#(10*CHECK_DELAY);
 	
 	$display("\n\n----------- neg/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000000100000000000000000000000;
  tb_op2 = 32'b01000000100001000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              10111110000000000000000000000000");
 	#(10*CHECK_DELAY);
 	
 	  
    $display("\n\n----------- pos/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b01000001001000000000000000000000;
  tb_op2 = 32'b11000000101000000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
    $display("correct result:              01000000101000000000000000000000");
  #(10*CHECK_DELAY);
 	*/
  end
endmodule 
