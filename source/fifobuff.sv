// $Id: $
// File name:   fifobuff.sv
// Created:     3/24/2015
// Author:      Matt King
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: fifo for operations

module fifobuff(
input wire clk, n_rst, read, write,
input reg [2:0] opcode_in,
output reg [2:0] opcode_out
);

//fifo registers
reg [2:0]reg0;
reg [2:0]reg1;
reg [2:0]reg2;
reg [2:0]reg3;
reg [2:0]reg4;
reg [2:0]reg5;
reg [2:0]reg6;
reg [2:0]reg7;
reg [2:0]next_reg0;
reg [2:0]next_reg1;
reg [2:0]next_reg2;
reg [2:0]next_reg3;
reg [2:0]next_reg4;
reg [2:0]next_reg5;
reg [2:0]next_reg6;
reg [2:0]next_reg7;

reg [2:0]fifo_status;

//fifo pointers
reg [2:0]in_point;
reg [2:0]out_point;

//data output registers
reg [2:0]data_out;
reg [2:0]next_data;

assign opcode_out = data_out;

//update in pointer when pushing new frame (strobe signal asserted)
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    in_point <= 0;
  end else if(write) begin
    in_point <= in_point + 1;
  end else begin 
    in_point <= in_point;
  end
end

//update out pointer when popping new frame (pop signal asserted)
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    out_point <= 0;
  end else if(read) begin
    out_point <= out_point + 1;
  end else begin
    out_point <= out_point;
  end
end

//determine fifo status (number of frames currently in buffer)
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    fifo_status <= 0;
  end else if(write && !read) begin
    fifo_status <= fifo_status + 1;
  end else if(read && !write) begin
    if(fifo_status == 0) begin
      fifo_status <= 0;
    end else begin
      fifo_status <= fifo_status - 1;
    end
  end else begin
    fifo_status <= fifo_status;
  end
end

//state machine logic for fifo registers
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
  end
end

always_comb
begin
  if(in_point == 0 && write) begin 
    next_reg0 = opcode_in;
  end else begin
    next_reg0 = reg0;
  end

  if(in_point == 1 && write) begin
    next_reg1 = opcode_in;
  end else begin
    next_reg1 = reg1;
  end
       
  if(in_point == 2 && write) begin
    next_reg2 = opcode_in;
  end else begin
    next_reg2 = reg2;
  end

  if(in_point == 3 && write) begin
    next_reg3 = opcode_in;
  end else begin
    next_reg3 = reg3;
  end
  
  if(in_point == 4 && write) begin
    next_reg4 = opcode_in;
  end else begin 
    next_reg4 = reg4;
  end

  if(in_point == 5 && write) begin
    next_reg5 = opcode_in;
  end else begin
    next_reg5 = reg5;
  end

  if(in_point == 6 && write) begin
    next_reg6 = opcode_in;
  end else begin
    next_reg6 = reg6;
  end

  if(in_point == 7 && write) begin
    next_reg7 = opcode_in;
  end else begin
    next_reg7 = reg7;
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



endmodule
