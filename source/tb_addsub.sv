`timescale 1ns/10ps
module tb_addsub();

reg [31:0]tbop1;
reg [31:0]tbop2;
reg tbclk;
reg tbnrst;
reg tbaddstart;
reg tbmode;
reg [31:0]tbaddresult;
reg tbadddone;
reg tbaddoverflow;

addsub DUT (.clk(tbclk), .n_rst(tbnrst), .add_start(tbaddstart), .mode(tbmode),.op1(tbop1), .op2(tbop2), .add_result(tbaddresult), .add_done(tbadddone), .add_overflow(tbaddoverflow));

initial
begin
  tbop1 = 32'b01111111100000000000000000000000;
  tbop2 = 32'b01111000000000000000000000000000;
#1;
end
endmodule


