`timescale 1ns/10ps
module tb_fifobuff ();

reg tb_clk;
reg tb_n_rst;
reg tb_read;
reg tb_write;
reg [2:0]tb_op_in;
reg [2:0]tb_op_out;

fifobuff DUT (.clk(tb_clk), .n_rst(tb_n_rst), .read(tb_read), .write(tb_write), .opcode_in(tb_op_in), .opcode_out(tb_op_out));

always
begin
  tb_clk = 1;
#2;
  tb_clk = 0;
#2;
end

task push;
  input [2:0]t_op_in;
  //input [2:0]t_op_out;

  tb_op_in = t_op_in;
  //tb_op_out = t_op_out;
  
#1;
  tb_write = 1;
#3;
  tb_write = 0;
endtask

task pull;
  tb_read = 1;
  #3;
  tb_read = 0;
endtask

initial begin
  tb_n_rst = 0;
  tb_read = 0;
  tb_write = 0;
#5
  tb_n_rst = 1;
#5
  push(3'b001);
  push(3'b010);
  pull;
  push(3'b100);
  push(3'b110);
  push(3'b001);
  push(3'b101);
  push(3'b111);
  push(3'b010);
  pull;
end 
endmodule
