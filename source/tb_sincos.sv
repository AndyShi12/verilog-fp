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

module sincos(
input wire clk, n_rst, sine_start,
input reg [0:31] opx,
output reg [0:31] sine_result,
output wire sine_done
);