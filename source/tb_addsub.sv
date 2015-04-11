// $Id: $
// File name:   tb_addsub.sv
// Created:     3/28/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: testbench for add/sub

`timescale 1ns/10ps
module tb_addsub();

localparam	CLK_PERIOD	= 10;
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
    
  $display("1. ----------- reset -----------");
  @(negedge tb_clk);
  tb_nReset = 0;
  $display("correct result:              00000000000000000000000000000000");
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
 	tb_nReset = 1;
 	#(10*CHECK_DELAY);

////////////////////////////////////////////////////////////////////////////////
$display("/////////////////////////////////// SAME EXPONENTS//////////////////////////////");

$display("\n\n1. ----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(8.25);
 	tb_op2 =  $shortrealtobits(8.65);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(16.9));
  #(5*CHECK_DELAY);
 

$display("\n\n2. ----------- neg/neg -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits((-1)*2.25);
  tb_op2 =  $shortrealtobits((-1)*2.55);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits((-1)*4.8));
  #(5*CHECK_DELAY);
  

$display("\n\n3. ----------- pos/neg  = pos-----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(24.55);
  tb_op2 =  $shortrealtobits((-1)*24.15);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(0.40));
  #(5*CHECK_DELAY);
  
$display("\n\n4. ----------- pos/neg  = neg-----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(24.00);
  tb_op2 =  $shortrealtobits((-1)*24.15);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(-0.15));
  #(5*CHECK_DELAY);

$display("\n\n5. ----------- neg/pos = pos -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits((-1)*48.0);
  tb_op2 =  $shortrealtobits(48.50);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(0.5));
  #(5*CHECK_DELAY);

  $display("\n\n6. ----------- neg/pos = neg -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits((-1)*48.50);
  tb_op2 =  $shortrealtobits(48.00);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits((-1)*0.5));
  #(5*CHECK_DELAY);
   

////////////////////////////////////////////////////////////////////////////////
$display("////////////////////////////// TOP > BOT EXPONENTS /////////////////////////////");

$display("\n\n1. ----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(422.25);
  tb_op2 =  $shortrealtobits(8.65);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(430.9));
  #(5*CHECK_DELAY);
 

$display("\n\n2. ----------- neg/neg -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(-50.25);
  tb_op2 =  $shortrealtobits(-5.55);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(55.8));
  #(5*CHECK_DELAY);
  

$display("\n\n3. ----------- pos/neg  = pos-----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(500.55);
  tb_op2 =  $shortrealtobits(-4.15);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(496.40));
  #(5*CHECK_DELAY);
  

$display("\n\n4. ----------- neg/pos = pos -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(-800.5);
  tb_op2 =  $shortrealtobits(0.50);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(-800.0));
  #(5*CHECK_DELAY);



////////////////////////////////////////////////////////////////////////////////
$display("////////////////////////////// BOT > TOP EXPONENTS /////////////////////////////");
      

$display("\n\n1. ----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(8.65);
  tb_op2 =  $shortrealtobits(422.25);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(430.9));
  #(5*CHECK_DELAY);
 

$display("\n\n2. ----------- neg/neg -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(-5.55);
  tb_op2 =  $shortrealtobits(-50.25);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(-55.8));
  #(5*CHECK_DELAY);
  

$display("\n\n4. ----------- neg/pos = pos -----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(-4.15);
  tb_op2 =  $shortrealtobits(500.55);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(496.40));
  #(5*CHECK_DELAY);
  

$display("\n\n3. ----------- pos/neg = neg-----------");
  @(negedge tb_clk);
  tb_op1 =  $shortrealtobits(0.50);
  tb_op2 =  $shortrealtobits(-800.5);
  #(CLK_PERIOD);
  $display("calculated result:  %b", tb_add_result);
  $display("correct result:     %b", $shortrealtobits(-800.0));
  #(5*CHECK_DELAY);



















































////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  $display("\n\n14. ----------- neg/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000100011101011100000000000000;
  tb_op2 = 32'b01001010000111111110100110000010;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01001010000111111101101000100110");
  #(10*CHECK_DELAY);
  
 
  $display("\n\n16. ----------- neg/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000100011101011100000000000000;
  tb_op2 = 32'b11001010000111111110100110000010;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              11001010000111111101101000100110");
  #(10*CHECK_DELAY);

/*

  $display("\n2. ----------- pos/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001000000000000000000000;
  tb_op2 = 32'b01000000011000000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000000110000000000000000000000");
  #(10*CHECK_DELAY);
  
  $display("\n3. ----------- pos/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001100000000000000000000;
  tb_op2 = 32'b01000000001100000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000000101100000000000000000000");
  #(10*CHECK_DELAY);
  
  $display("\n4. ----------- neg/neg (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b11000110000111000100001000111000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              11000110100111000100001000111000");
  #(10*CHECK_DELAY);
  
  $display("\n5. ----------- neg/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b01000110000111000100001000111000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              00000000000000000000000000000000");
  #(10*CHECK_DELAY);
  
  
  $display("\n6. -----------pos/pos -----------");
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
  
  $display("\n\n7. ----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000010111101101110100101111001;
  tb_op2 = 32'b01000100001000111001010010001011;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01000100010000100111000110111010");
  #(10*CHECK_DELAY);
  
  
  $display("\n\n8. ----------- pos/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000100011101011100000000000000;
  tb_op2 = 32'b01001010000111111110100110000010;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01001010000111111111100011011110");
  #(10*CHECK_DELAY);
  
  $display("\n\n9. ----------- pos/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op2 = 32'b01000100011101011100000000000000;
  tb_op1 = 32'b01001010000111111110100110000010;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              01001010000111111111100011011110");
  #(10*CHECK_DELAY);
  
    $display("\n10. ----------- neg/pos (same value) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b01000110000111000100001000111000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              00000000000000000000000000000000");
  #(10*CHECK_DELAY);
  
  $display("\n11. ----------- neg/neg (same value) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b11000110000111000100001000111000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              11000110100111000100001000111000");
  #(10*CHECK_DELAY);


  
    $display("\n\n12. ----------- pos/neg (same exp) 0.125 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000100001000000000000000000;
  tb_op2 = 32'b11000000100000000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              00111110000000000000000000000000");
  #(10*CHECK_DELAY);
  
  
  $display("\n\n13. ----------- neg/pos (same exp) -0.125 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000000100001000000000000000000;
  tb_op2 = 32'b01000000100000000000000000000000;
  #(CLK_PERIOD);
  $display("done: %b, calculated result:  %b", tb_add_done, tb_add_result);
  $display("correct result:              10111110000000000000000000000000");
  #(10*CHECK_DELAY);

  */
  	////////////////////////////////////////////////////////////////////////////////////////////////////////////// Sub exponential
  
  end
endmodule 
