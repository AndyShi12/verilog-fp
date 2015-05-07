// $Id: $
// File name:   indecode.sv
// Created:     3/24/2015
// Author:      Matt King
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: operation decoder 

module indecode(
input wire clk,
input wire n_rst,
input wire op_strobe,
input reg [31:0] op1,
input reg [31:0] op2,
input reg [2:0] op_sel,
input wire out_fifo_hold,
input wire add_busy, mul_busy, sine_busy,
output reg [31:0] op1_out,
output reg [31:0] op2_out,
output reg add_start, mul_start, sine_start, cpu_hold, [2:0]opcode_out
);
reg strobe_reg;
reg prev_strobe1;
reg prev_strobe2;
reg strobe_edge;
reg [66:0]reg0;
reg [66:0]reg1;
reg [66:0]reg2;
reg [66:0]reg3;
reg [66:0]reg4;
reg [66:0]reg5;
reg [66:0]reg6;
reg [66:0]reg7;
reg [66:0]next_reg0;
reg [66:0]next_reg1;
reg [66:0]next_reg2;
reg [66:0]next_reg3;
reg [66:0]next_reg4;
reg [66:0]next_reg5;
reg [66:0]next_reg6;
reg [66:0]next_reg7;
reg [66:0]data_out;
reg [66:0]next_data;

//fifo pointers
reg [2:0]in_point;
reg [2:0]out_point;
//reg [2:0]next_in_point;
//reg [2:0]next_out_point;
reg [2:0]fifo_status;
reg fifo_pop;
reg prev_pop;
reg pop;
assign cpu_hold = out_fifo_hold || (fifo_status == 7);
assign op1_out = data_out[66:35];
assign op2_out = data_out[34:3];
assign opcode_out = data_out[2:0];

//pointer updating
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    in_point <= 0;
  end else if (strobe_edge) begin
    in_point <= in_point + 1;
  end else begin
    in_point <= in_point;
  end
end

always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    out_point <= 0;
  end else if(fifo_pop) begin
    out_point <= out_point + 1;
  end else begin
    out_point <= out_point;
  end
end

always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    fifo_status <= 0;
  end
  else if(strobe_edge && !fifo_pop) begin
    fifo_status <= fifo_status + 1;
  end else if(fifo_pop && !strobe_edge) begin
    if(fifo_status == 0) begin
      fifo_status <= 0;
    end else begin
      fifo_status <= fifo_status - 1;
    end
  end else begin
    fifo_status <= fifo_status;
  end
end

always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    strobe_reg <= 0;
    prev_strobe1 <= 0;
    prev_strobe2 <= 0;
  end else begin
    strobe_reg <= strobe_edge;
    prev_strobe1 <= op_strobe;
    prev_strobe2 <= prev_strobe1;
  end
end

always @ (posedge clk, negedge n_rst)
begin
  //active low reset all regs 
  if(~n_rst) begin
    reg0 <= 0;
    reg1 <= 0;
    reg2 <= 0;
    reg3 <= 0;
    reg4 <= 0;
    reg5 <= 0;
    reg6 <= 0;
    reg7 <= 0;
    data_out <= 0;
    prev_pop <= 0;
  end else begin
    //load in next value for reg at clock 
    reg0 <= next_reg0;
    reg1 <= next_reg1;
    reg2 <= next_reg2;
    reg3 <= next_reg3;
    reg4 <= next_reg4;
    reg5 <= next_reg5;
    reg6 <= next_reg6;
    reg7 <= next_reg7;
    data_out <= next_data;
    prev_pop <= fifo_pop;
  end
end

//determine next reg values
always_comb
begin
  if(in_point == 0 && strobe_edge) begin 
    next_reg0 = {op1,op2,op_sel};
  end else begin
    next_reg0 = reg0;
  end

  if(in_point == 1 && strobe_edge) begin
    next_reg1 = {op1,op2,op_sel};
  end else begin
    next_reg1 = reg1;
  end
       
  if(in_point == 2 && strobe_edge) begin
    next_reg2 = {op1,op2,op_sel};
  end else begin
    next_reg2 = reg2;
  end

  if(in_point == 3 && strobe_edge) begin
    next_reg3 = {op1,op2,op_sel};
  end else begin
    next_reg3 = reg3;
  end
  
  if(in_point == 4 && strobe_edge) begin
    next_reg4 = {op1,op2,op_sel};
  end else begin 
    next_reg4 = reg4;
  end

  if(in_point == 5 && strobe_edge) begin
    next_reg5 = {op1,op2,op_sel};
  end else begin
    next_reg5 = reg5;
  end

  if(in_point == 6 && strobe_edge) begin
    next_reg6 = {op1,op2,op_sel};
  end else begin
    next_reg6 = reg6;
  end

  if(in_point == 7 && strobe_edge) begin
    next_reg7 = {op1,op2,op_sel};
  end else begin
    next_reg7 = reg7;
  end
end

always_comb
begin
  if(prev_strobe1 && ~prev_strobe2) begin
    strobe_edge = 1;
  end else begin
    strobe_edge = 0;
  end
end

always_comb
begin
  if(pop && ~prev_pop) begin
    if(fifo_status == 0) begin
      fifo_pop = 0;
    end else begin
      fifo_pop = 1;
    end
  end else begin
    fifo_pop = 0;
  end 
end
always_comb
begin
  next_data = reg0;
  if(out_point == 1) begin
    next_data = reg1;
  end else if(out_point == 2) begin
    next_data = reg2;
  end else if(out_point == 3) begin
    next_data = reg3;
  end else if(out_point == 4) begin
    next_data = reg4;
  end else if(out_point == 5) begin
    next_data = reg5;
  end else if(out_point == 6) begin
    next_data = reg6;
  end else if(out_point == 7) begin
    next_data = reg7;
  end 
end

always_comb 
begin
  if(fifo_status == 0) begin
    pop = 0;
    add_start = 0;
    mul_start = 0;
    sine_start = 0;
  end else begin

  if(opcode_out == 3'b000 && ~add_busy) begin
    pop = 1;
    add_start = 1;
    mul_start = 0;
    sine_start = 0;
  end else if(opcode_out == 3'b001 && ~add_busy) begin
    pop = 1;
    add_start = 1;
    mul_start = 0;
    sine_start = 0;
  end else if(opcode_out == 3'b010 && ~mul_busy) begin
    pop = 1;
    add_start = 0;
    mul_start = 1;
    sine_start = 0;
  end else if(opcode_out == 3'b011 && ~sine_busy) begin
    pop = 1;
    add_start = 0;
    mul_start = 0;
    sine_start = 1;
  end else if(opcode_out == 3'b100 && ~sine_busy) begin
    pop = 1;
    add_start = 0;
    mul_start = 0;
    sine_start = 1;
  end else begin
    add_start = 0;
    mul_start = 0;
    sine_start = 0;
  end
  end
end


endmodule
