// $Id: $
// File name:   tb_wrapper.sv
// Created:     4/28/2015
// Author:      Kyunghoon Jung
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for wrapper.sv

`timescale 1ns / 10ps

localparam CLK_PERIOD = 4;
localparam CHECK_DELAY = 2;

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
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
  
initial
  begin
    
  // Testing Add/Sub Block
  
  $display("1. ----------- reset -----------");
  @(negedge tb_clk);
  tb_n_rst = 0;
  $display("correct result:              00000000000000000000000000000000");
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  
     
  $display("\n\n14. ----------- neg/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000100011101011100000000000000;
  tb_op2 = 32'b01001010000111111110100110000010;
  tb_n_rst = 1;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01001010000111111101101000100110");

  
  $display("\n\n16. ----------- neg/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000100011101011100000000000000;
  tb_op2 = 32'b11001010000111111110100110000010;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              11001010000111111101101000100110");


  $display("\n2. ----------- pos/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001000000000000000000000;
  tb_op2 = 32'b01000000011000000000000000000000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01000000110000000000000000000000");

  
  $display("\n3. ----------- pos/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000000001100000000000000000000;
  tb_op2 = 32'b01000000001100000000000000000000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01000000101100000000000000000000");
  
  
  $display("\n4. ----------- neg/neg (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b11000110000111000100001000111000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              11000110100111000100001000111000");
  
  
  $display("\n5. ----------- neg/pos (same exp) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b01000110000111000100001000111000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              00000000000000000000000000000000");
  
  $display("\n6. -----------pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000001010010000000000000000000;
  tb_op2 = 32'b01000001100011000000000000000000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01000001111100000000000000000000\n\n");
  
  @(negedge tb_clk);
  tb_op1 = 32'b01000100000010101110001110000101;
  tb_op2 = 32'b01000011010111100011100011010101;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01000100010000100111000110111010\n\n");
  
  @(negedge tb_clk);
  tb_op1 = 32'b01000011010111100011100011010101;
  tb_op2 = 32'b01000100000010101110001110000101;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01000100010000100111000110111010\n\n");
  
  $display("\n\n7. ----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000010111101101110100101111001;
  tb_op2 = 32'b01000100001000111001010010001011;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01000100010000100111000110111010");
  
  $display("\n\n8. ----------- pos/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b01000100011101011100000000000000;
  tb_op2 = 32'b01001010000111111110100110000010;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01001010000111111111100011011110");
  
  $display("\n\n9. ----------- pos/pos, larger exp -----------");
  @(negedge tb_clk);
  tb_op2 = 32'b01000100011101011100000000000000;
  tb_op1 = 32'b01001010000111111110100110000010;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              01001010000111111111100011011110");

  
  $display("\n10. ----------- neg/pos (same value) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b01000110000111000100001000111000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              00000000000000000000000000000000");

  $display("\n11. ----------- neg/neg (same value) -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000110000111000100001000111000;
  tb_op2 = 32'b11000110000111000100001000111000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              11000110100111000100001000111000");

  $display("\n\n13. ----------- neg/pos (same exp) -0.125 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000000100001000000000000000000;
  tb_op2 = 32'b01000000100000000000000000000000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              10111110000000000000000000000000");


  $display("\n\n13. ----------- neg/pos (same exp) -0.125 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111110010010000111111011000;
  tb_op2 = 32'b10111111001001010101110111100000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              ?");


  $display("\n\n13. ----------- neg/pos (same exp) -0.125 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111011011001100000111010000;
  tb_op2 = 32'b00111101101000110011010111011000;
  tb_op_sel = 3'b000;
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  $display("correct result:              ~1 ");
  
  
  
  
  
  
  
  
  
  // Test bench for Multiplication
  $display("\n----------- pos/pos -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111101000000000000000000000;
  tb_op2 = 32'b00111111110000000000000000000000;
  tb_op_sel = 3'b010;
  tb_n_rst = 1;
  $display("correct result:              00111111111100000000000000000000");
   #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);


 	$display("\n\n----------- pos/pos -----------");
 	@(negedge tb_clk);
 	tb_op1 = 32'b01000000000000000000000000000000;
  tb_op2 = 32'b01000000010000000000000000000000;
  tb_op_sel = 3'b010;
  $display("correct result:              01000000110000000000000000000000");
   #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);

  $display("\n\n----------- pos/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b00111111100000000000000000000000;
  tb_op2 = 32'b11000000110000000000000000000000;
  tb_op_sel = 3'b010;
  $display("correct result:              11000000110000000000000000000000");
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);


  $display("\n\n----------- neg/neg -----------");
  @(negedge tb_clk);
 	tb_op1 = 32'b11000000010000000000000000000000;
  tb_op2 = 32'b11000000100000000000000000000000;
  tb_op_sel = 3'b010;
  $display("correct result:              01000001010000000000000000000000");  
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);


  $display("\n\n----------- neg/neg -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b11000000011111111111111111111111;
  tb_op2 = 32'b11000000101111111111111111111111;
  tb_op_sel = 3'b010;
  $display("correct result:              ?");  
   #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
 
 $display("\n\n----------- pi/4^2 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111111010010010000111111011011;
  tb_op2 = 32'b00111111010010010000111111011011;
  tb_op_sel = 3'b010;
  $display("correct result:              ?");  
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
 

  $display("\n\n----------- 0.36685002^2 -----------");
  @(negedge tb_clk);
  tb_op1 = 32'b00111110101110111101001111000100;
  tb_op2 = 32'b00111110101110111101001111000100;
  tb_op_sel = 3'b010;
  $display("correct result:              ?");  
  #(10*CHECK_DELAY);
  $display("done: %b, calculated result:  %b", tb_done, tb_result);
  
  
  
  
  
  
  
  
  /*
  // Test bench for sine/cosine block (still need to adjust clock cycle, delay, and opcodes)
  
  $display("\n----------- pi/4 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b00111111010010010000111111011000;
  $display("correct result:              0.707106, 0.707106 ");
  $display("correct result:              00111111001101010000010011100110");
  #(5*CHECK_DELAY);
  $display("done:     sine result:      %b", tb_result);

  $display("\n----------- pi/2 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b00111111110010010000111111011000;
  $display("correct result:                1.0, 0.0 ");
  $display("correct result:              00111111100000000000000000000000, 0");
    #(5*CHECK_DELAY);
  $display("done:     sine result:      %b", tb_result);


  $display("\n----------- pi -----------");
  @(negedge tb_clk);
  tb_opx = 32'b01000000010010010000111111011010;
  $display("correct result:                0.0, -1.0");
  $display("correct result:              0, 10111111100000000000000000000000 ");
  #(5*CHECK_DELAY);
  $display("done:     sine result:      %b", tb_result);
  
  
  
  
  
  $display("\n----------- pi/4 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b00111111010010010000111111011000;
  $display("correct result:              0.707106, 0.707106 ");
  $display("correct result:              00111111001101010000010011100110");
  #(5*CHECK_DELAY);
  $display("done:     cosine result:    %b", tb_result);

$display("\n----------- pi/2 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b00111111110010010000111111011000;
  $display("correct result:                1.0, 0.0 ");
  $display("correct result:              00111111100000000000000000000000, 0");
    #(5*CHECK_DELAY);
  $display("done:     cosine result:    %b", tb_result);


$display("\n----------- pi -----------");
  @(negedge tb_clk);
  tb_opx = 32'b01000000010010010000111111011010;
  $display("correct result:                0.0, -1.0");
  $display("correct result:              0, 10111111100000000000000000000000 ");
  #(5*CHECK_DELAY);
  $display("done:     cosine result:    %b", tb_result); 
  */
  
  end 
endmodule