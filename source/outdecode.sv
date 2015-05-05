// $Id: $
// File name:   outdecode.sv
// Created:     3/24/2015
// Author:      Matt King
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: system level output module

module outdecode(
input wire clk, n_rst,
input reg [31:0] add_result,
input reg [31:0] mul_result,
input reg [31:0] sine_result,
input wire add_done, mul_done, sine_done, cpu_pop,
input reg [2:0] fifo_out,
output reg [31:0] result,
output reg  out_fifo_hold, op_fifo_pop, add_serv, mul_serv, sine_serv
);

//fifo registers
reg [31:0]reg0;
reg [31:0]reg1;
reg [31:0]reg2;
reg [31:0]reg3;
reg [31:0]reg4;
reg [31:0]reg5;
reg [31:0]reg6;
reg [31:0]reg7;
reg [31:0]next_reg0;
reg [31:0]next_reg1;
reg [31:0]next_reg2;
reg [31:0]next_reg3;
reg [31:0]next_reg4;
reg [31:0]next_reg5;
reg [31:0]next_reg6;
reg [31:0]next_reg7;
reg [2:0]fifo_status;

reg prev_pop;
reg fifo_pop;
reg pop; 
reg strobe; //internal fifo strobe
reg write;
reg [31:0] fifo_in;
reg [31:0] next_fifo_in;
reg [2:0] opcode;
reg add_s;
reg mul_s;
reg sine_s;

//fifo pointers
reg [2:0]in_point;
reg [2:0]out_point;

//data output registers
reg [31:0]data_out;
reg [31:0]next_data;

assign result = data_out;
assign fifo_pop = cpu_pop;
assign op_fifo_pop = add_serv || mul_serv || sine_serv;
assign out_fifo_hold = (fifo_status == 7);

always_comb
begin
  if(add_done && (fifo_out == 3'b001)) begin
    next_fifo_in = add_result;
    write = 1;
    add_s = 1;
    mul_s = 0;
    sine_s = 0;
  end else if(add_done && (opcode == 3'b010)) begin
    next_fifo_in = add_result;
    write = 1;
    add_s = 1;
    sine_s = 0;
    mul_s = 0;
  end else if(mul_done && (opcode == 3'b011)) begin
    next_fifo_in = mul_result;
    write = 1;
    add_s = 0;
    mul_s = 1;
    sine_s = 0;
  end else if(sine_done && (opcode == 3'b100)) begin
    next_fifo_in = sine_result;
    write = 1;
    add_s = 0;
    mul_s = 0;
    sine_s = 1;
  end else if(sine_done && (opcode == 3'b101)) begin
    next_fifo_in = sine_result;
    write = 1;
    add_s = 0;
    mul_s = 0;
    sine_s = 1;
  end else begin
    next_fifo_in = next_data;
    write = 0;
    add_s = 0;
    mul_s = 0;
    sine_s = 0;
  end
  if(out_fifo_hold) begin
    write = 0;
  end
end

always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    strobe <= 0;
    add_serv <= 0;
    mul_serv <= 0;
    sine_serv <= 0;
  end else begin
    if(strobe) begin
      strobe <= 0;
    end else begin
      strobe <= write;
    end
    if(add_serv) begin
      add_serv <= 0;
    end else begin
      add_serv <= add_s;
    end
    if(mul_serv) begin
      mul_serv <= 0;
    end else begin
      mul_serv <= mul_s;
    end
    if(sine_serv) begin
      sine_serv <= 0;
    end else begin
      sine_serv <= sine_s;
    end
  end
end
//update in pointer when pushing new frame (strobe signal asserted)
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    in_point <= 0;
  end else if(strobe) begin
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
  end else if(fifo_pop) begin
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
  end else if(strobe && !fifo_pop) begin
    fifo_status <= fifo_status + 1;
  end else if(fifo_pop && !strobe) begin
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
    prev_pop <= 0;
    fifo_in <= 0;
    opcode <= 0;
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
    fifo_in <= next_fifo_in;
    opcode <= fifo_out;
  end
end

always_comb
begin
  if(in_point == 0 && strobe) begin 
    next_reg0 = fifo_in;
  end else begin
    next_reg0 = reg0;
  end

  if(in_point == 1 && strobe) begin
    next_reg1 = fifo_in;
  end else begin
    next_reg1 = reg1;
  end
       
  if(in_point == 2 && strobe) begin
    next_reg2 = fifo_in;
  end else begin
    next_reg2 = reg2;
  end

  if(in_point == 3 && strobe) begin
    next_reg3 = fifo_in;
  end else begin
    next_reg3 = reg3;
  end
  
  if(in_point == 4 && strobe) begin
    next_reg4 = fifo_in;
  end else begin 
    next_reg4 = reg4;
  end

  if(in_point == 5 && strobe) begin
    next_reg5 = fifo_in;
  end else begin
    next_reg5 = reg5;
  end

  if(in_point == 6 && strobe) begin
    next_reg6 = fifo_in;
  end else begin
    next_reg6 = reg6;
  end

  if(in_point == 7 && strobe) begin
    next_reg7 = fifo_in;
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
