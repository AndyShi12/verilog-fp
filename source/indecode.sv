// Author:      Matt King
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: operation decoder 

module indecode(
  input wire clk, //system clock
  input wire n_rst, //system reset
  input wire op_strobe, //data valid write to fifo
  input reg [31:0] op1, //operand 1
  input reg [31:0] op2, //operand 2
  input reg [2:0] op_sel, //operation select
  input wire add_busy, mul_busy, sine_busy, //operation busy signals
  input wire out_fifo_hold, //hold signal from output fifo
  output reg [31:0] op1_out, //operand output 1 to operation block
  output reg [31:0] op2_out, //operand output 2 to operation block
  output reg add_start, mul_start, sine_start, //operation start signals
  output reg cpu_hold, //fifo full signal
  output reg [2:0] opcode_out
);

//fifo registers
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

reg [2:0]fifo_status;
reg prev_pop;
reg fifo_pop;
reg pop;

//fifo pointers
reg [2:0]in_point;
reg [2:0]out_point;

//data output registers
reg [66:0]data_out;
reg [66:0]next_data;

//output signal assignments
assign cpu_hold = out_fifo_hold || (fifo_status == 7);
assign op1_out = data_out[66:35]; //first 32 bits
assign op2_out = data_out[34:3]; //next 32 bits
assign opcode_out = data_out[2:0]; //last 3 bits

//update in pointer when pushing new frame (strobe signal asserted)
always @ (posedge clk, negedge n_rst)
begin
  if(~n_rst) begin
    in_point <= 0;
  end else if(op_strobe) begin
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
  end else if(op_strobe && !fifo_pop) begin
    fifo_status <= fifo_status + 1;
  end else if(fifo_pop && !op_strobe) begin
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

always_comb
begin
  if(in_point == 0 && op_strobe) begin 
    next_reg0 = {op1,op2,op_sel};
  end else begin
    next_reg0 = reg0;
  end

  if(in_point == 1 && op_strobe) begin
    next_reg1 = {op1,op2,op_sel};
  end else begin
    next_reg1 = reg1;
  end
       
  if(in_point == 2 && op_strobe) begin
    next_reg2 = {op1,op2,op_sel};
  end else begin
    next_reg2 = reg2;
  end

  if(in_point == 3 && op_strobe) begin
    next_reg3 = {op1,op2,op_sel};
  end else begin
    next_reg3 = reg3;
  end
  
  if(in_point == 4 && op_strobe) begin
    next_reg4 = {op1,op2,op_sel};
  end else begin 
    next_reg4 = reg4;
  end

  if(in_point == 5 && op_strobe) begin
    next_reg5 = {op1,op2,op_sel};
  end else begin
    next_reg5 = reg5;
  end

  if(in_point == 6 && op_strobe) begin
    next_reg6 = {op1,op2,op_sel};
  end else begin
    next_reg6 = reg6;
  end

  if(in_point == 7 && op_strobe) begin
    next_reg7 = {op1,op2,op_sel};
  end else begin
    next_reg7 = reg7;
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
