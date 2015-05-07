module fp_layout (
  input wire clk,
  input wire n_rst,
  input wire [31:0] op1,
  input wire [31:0] op2,
  input wire [2:0] op_sel,
  input wire op_strobe,
  input wire cpu_pop,
  output wire cpu_hold,
  output reg [31:0] result
);

wrapper LD (
  .clk(clk),
  .n_rst(n_rst),
  .op1(op1),
  .op2(op2),
  .op_sel(op_sel),
  .op_strobe(op_strobe),
  .cpu_pop(cpu_pop),
  .cpu_hold(cpu_hold),
  .result(result)
);
endmodule
