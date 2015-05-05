`timescale 1ns/10ps

module tb_outdecode ();

reg tb_clk;
reg tb_n_rst;
reg [31:0] tb_add_result;
reg [31:0] tb_mul_result;
reg [31:0] tb_sine_result;
reg tb_add_done;
reg tb_mul_done;
reg tb_sine_done;
reg tb_cpu_pop;
reg [2:0] tb_fifo_out;
reg [31:0] tb_result;
reg tb_out_fifo_hold;
reg tb_op_fifo_pop;
reg tb_add_serv;
reg tb_mul_serv;
reg tb_sine_serv;

outdecode DUT (
  .clk(tb_clk),
  .n_rst(tb_n_rst),
  .add_result(tb_add_result),
  .mul_result(tb_mul_result),
  .sine_result(tb_sine_result),
  .add_done(tb_add_done),
  .mul_done(tb_mul_done),
  .sine_done(tb_sine_done),
  .cpu_pop(tb_cpu_pop),
  .fifo_out(tb_fifo_out),
  .result(tb_result),
  .out_fifo_hold(tb_out_fifo_hold),
  .op_fifo_pop(tb_op_fifo_pop),
  .add_serv(tb_add_serv),
  .mul_serv(tb_mul_serv),
  .sine_serv(tb_sine_serv)
);

always
begin
  tb_clk = 1;
#2;
  tb_clk = 0;
#2;
end

initial
begin
tb_n_rst = 0;
#2
tb_n_rst = 1;

tb_add_result = 32'b00000000000000000000000000000001;
tb_fifo_out = 3'b000;
#1
tb_add_done = 1;
@(posedge tb_add_serv);
tb_add_done = 0;

end
endmodule

