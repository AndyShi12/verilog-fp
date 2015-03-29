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

sincos SINCOS(
    .clk(tb_clk), 
    .n_rst(tb_nReset),
    .sine_start(tb_sine_start),
    .opx(tb_opx),
    .sine_done(tb_sine_done),
    .sine_result(tb_sine_result)
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
    end
    
endmodule