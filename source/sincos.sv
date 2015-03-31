// $Id: $
// File name:   sincos.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: sine and cosine module

module sincos(
input wire clk, n_rst, sine_start,
input reg [31:0] opx,
output reg [31:0] sine_result,
output reg [31:0] cosine_result,
output reg sine_done
);

real num, sinAns, cosAns;
real pi = 3.141592654;
int  x = 0;

always_ff @ (posedge clk, negedge n_rst) 
begin
if (n_rst == 0) begin
    sine_result = 0;
    cosine_result = 0;
    sine_done = 1;
  end
else begin
  
sine_done = 0;
num = $bitstoshortreal(opx)/2/pi;
x = num;
num = (num - x)*2*pi;

//sine
sinAns = num - num**3/6 + num**5/120 - num**7/5040 + num**9/362880 - num**11/39916800;
//cosine
cosAns = 1 - num**2/2 + num**4/24 - num**6/720 + num**8/40320 - num**10/3628800 + num**12/479001600;

sine_result = $shortrealtobits(sinAns);
cosine_result = $shortrealtobits(cosAns);
sine_done = 1;
end

end
endmodule

/*
op = 32'b00111111111100000000000000000000;
test = $bitstoshortreal(op);
$display("conversion = %b = %f", op, test);

$display("\n\n\nx = pi");
$display("sin(x) = %f", x - x**3/6 + x**5/120 - x**7/5040 + x**9/362880 - x**11/39916800 );  // + x**13/6227020800  - x**15/1307674368000 + x**17/355687428096000 - x**19/121645100408832000
$display("cos(x) = %f", 1 - x**2/2 + x**4/24 - x**6/720 + x**8/40320 - x**10/3628800 + x**12/479001600);

$display("\ny = pi/2");
$display("sin(y) = %f", y - y**3/6 + y**5/120 - y**7/5040 + y**9/362880 - y**11/39916800);
$display("cos(y) = %f", 1 - y**2/2 + y**4/24 - y**6/720 + y**8/40320 - y**10/3628800 + y**12/479001600);

$display("\nz = pi/4");
$display("sin(z) = %f", z - z**3/6 + z**5/120 - z**7/5040 + z**9/362880 - z**11/39916800);
$display("cos(z) = %f", 1 - z**2/2 + z**4/24 - z**6/720 + z**8/40320 - z**10/3628800 + z**12/479001600);

$display("\na = 0");
$display("sin(z) = %f", a - a**3/6 + a**5/120 - a**7/5040 + a**9/362880 - a**11/39916800);
$display("cos(z) = %f", 1 - a**2/2 + a**4/24 - a**6/720 + a**8/40320 - a**10/3628800 + a**12/479001600);
*/

/*$display("mod  %f", 26%3);
$display("mod  %f", 72%6);
$display("mod  %f", 1%9);
$display("div  %f", 728/6.28);
*/