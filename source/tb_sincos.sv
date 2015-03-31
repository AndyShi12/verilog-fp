// $Id: $
// File name:   tb_sincos.sv
// Created:     3/28/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: test bench for sine and cosine

`timescale 1ns/10ps
module tb_sincos();

localparam	CLK_PERIOD	= 2.5;
localparam	CHECK_DELAY = 1; 

reg tb_clk, tb_nReset, tb_sine_start, tb_sine_done;
reg [31:0] tb_opx;
reg [31:0] tb_sine_result;
reg [31:0] tb_cosine_result;


sincos SINCOS(
    .clk(tb_clk), 
    .n_rst(tb_nReset),
    .sine_start(tb_sine_start),
    .opx(tb_opx),
    .sine_done(tb_sine_done),
    .sine_result(tb_sine_result),
    .cosine_result(tb_cosine_result)
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
  $display("done:    %b, sine result:    %f", tb_sine_result, $bitstoshortreal(tb_sine_result));
  $display("done:    %b, cosine result:  %f", tb_cosine_result, $bitstoshortreal(tb_cosine_result));
  tb_nReset = 1;
  #(10*CHECK_DELAY);
 
  $display("\n----------- pi/4 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b00111111010010010000111111011000;
  $display("correct result:                0.707106, 0.707106 ");
  //$display("correct result:              00111111111100000000000000000000");
  #(CLK_PERIOD);
  $display("done:    %b, sine result:    %f", tb_sine_result, $bitstoshortreal(tb_sine_result));
  $display("done:    %b, cosine result:  %f", tb_cosine_result, $bitstoshortreal(tb_cosine_result));
  #(10*CHECK_DELAY);
 
  $display("\n----------- pi/2 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b00111111110010010000111111011000;
  $display("correct result:                1.0, 0.0 ");
  //$display("correct result:              00111111111100000000000000000000");
  #(CLK_PERIOD);
  $display("done:    %b, sine result:    %f", tb_sine_result, $bitstoshortreal(tb_sine_result));
  $display("done:    %b, cosine result:  %f", tb_cosine_result, $bitstoshortreal(tb_cosine_result));
  #(10*CHECK_DELAY);
 
  $display("\n----------- 3pi/2 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b01000000100101101100101111100100;
  $display("correct result:                -1.0, 0.0");
  //$display("correct result:              11000000110000000000000000000000");
  #(CLK_PERIOD);
  $display("done:    %b, sine result:    %f", tb_sine_result, $bitstoshortreal(tb_sine_result));
  $display("done:    %b, cosine result:  %f", tb_cosine_result, $bitstoshortreal(tb_cosine_result));

  #(10*CHECK_DELAY);

  $display("\n----------- 7pi/4 -----------");
  @(negedge tb_clk);
  tb_opx = 32'b01000000101011111110110111011111;  
  $display("correct result:                -0.707106, 0.707106 ");
  //$display("correct result:              01000001010000000000000000000000");
  #(CLK_PERIOD);
  $display("done:    %b, sine result:    %f", tb_sine_result, $bitstoshortreal(tb_sine_result));
  $display("done:    %b, cosine result:  %f", tb_cosine_result, $bitstoshortreal(tb_cosine_result));
  #(10*CHECK_DELAY);

  $display("\n----------- 2pi -----------");
  @(negedge tb_clk);
  tb_opx = 32'b01000000110010010000111111011011;
  $display("correct result:                0.0, 1.0 ");
  //$display("correct result:              01000001010000000000000000000000");
  #(CLK_PERIOD);
  $display("done:    %b, sine result:    %f", tb_sine_result, $bitstoshortreal(tb_sine_result));
  $display("done:    %b, cosine result:  %f", tb_cosine_result, $bitstoshortreal(tb_cosine_result));
  #(10*CHECK_DELAY);
  end
    
endmodule