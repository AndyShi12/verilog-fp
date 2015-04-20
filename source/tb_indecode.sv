`timescale 1ns/10ps
module tb_indecode ();

reg tb_clk;
reg tb_n_rst;
reg tb_op_strobe;
reg [31:0]tb_op1;
reg [31:0]tb_op2;
reg [2:0]tb_op_sel;
reg [31:0]tb_op1_out;
reg [31:0]tb_op2_out;
reg tb_add_start;
reg tb_mul_start;
reg tb_sine_start;
reg [2:0]tb_opcode_out;
//reg tb_read_data;
reg tb_cpu_hold;
reg tb_add_busy;
reg tb_mul_busy;
reg tb_sine_busy;
reg tb_out_fifo_hold;

indecode DUT (.clk(tb_clk), .n_rst(tb_n_rst), .op_strobe(tb_op_strobe), .op1(tb_op1), .op2(tb_op2), .op_sel(tb_op_sel), .op1_out(tb_op1_out), .op2_out(tb_op2_out), .add_start(tb_add_start), .mul_start(tb_mul_start), .sine_start(tb_sine_start), .opcode_out(tb_opcode_out), .cpu_hold(tb_cpu_hold), .add_busy(tb_add_busy), .mul_busy(tb_mul_busy), .sine_busy(tb_sine_busy), .out_fifo_hold(tb_out_fifo_hold));

always
begin
  tb_clk = 1;
#50;
  tb_clk = 0;
#50;
end

task push;
  input [31:0]t_op1;
  input [31:0]t_op2;
  input [2:0]t_opsel;

  tb_op1 = t_op1;
  tb_op2 = t_op2;
  tb_op_sel = t_opsel;

  #100;
  tb_op_strobe = 1;
  #100;
  tb_op_strobe = 0;
endtask

initial begin
  tb_n_rst = 0;
  tb_op_strobe = 0;
  tb_add_busy = 0;
  tb_mul_busy = 0;
  tb_sine_busy = 0;
  tb_out_fifo_hold = 0;
 #5
  tb_n_rst = 1;
  tb_add_busy = 1;
  push(32'b00000000000000000000000000000001,32'b00000000000000000000000000000001,3'b001);
  push(32'b00000000000000000000000000001111,32'b00000000000000000000000000001111,3'b010);
  push(32'b00000000000000000000000000000011,32'b00000000000000000000000000000011,3'b100);
  push(32'b00000000000000000000000000000001,32'b00000000000000000000000000000001,3'b000);
  push(32'b00000000000000000000000000000011,32'b00000000000000000000000000000011,3'b011);
  push(32'b00000000000000000000000000000111,32'b00000000000000000000000000000111,3'b111);
  push(32'b00000000000000000000000000000001,32'b00000000000000000000000000000001,3'b000);
#10
  tb_add_busy = 0;
end
endmodule



