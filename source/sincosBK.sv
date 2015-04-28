// $Id: $
// File name:   sincos.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: sine and cosine module

module sincos(
input wire clk, n_rst, 
input reg [31:0] opx,
output reg [31:0] sine_result,
output reg [31:0] cosine_result,
output reg done
);

reg [31:0] one = 32'b00111111100000000000000000000000;  // 1
// Sine
reg [31:0] s1 = 32'b10111110001010101010101010101011;   // -1/6
reg [31:0] s2 = 32'b00111100000010001000100010001001;   // 1/120
reg [31:0] s3 = 32'b10111001010100000000110100000000;   // -1/5040
reg [31:0] s4 = 32'b00110110001110001110111100010101;   // 1/362880
reg [31:0] s5 = 32'b10110010110101110011001000101011;   // -1/39916800
reg [31:0] sP1;
reg [31:0] sP2;
reg [31:0] sP3;
reg [31:0] sP4;
reg [31:0] sP5;
// Cos
reg [31:0] c1 = 32'b10111111000000000000000000000000;   // -1/2
reg [31:0] c2 = 32'b00111101001010101010101010101011;   // 1/24
reg [31:0] c3 = 32'b10111010101101100000101101100001;   // -1/720
reg [31:0] c4 = 32'b00110111110100000000110011111101;   // 1/40320
reg [31:0] c5 = 32'b10110100100100111111001001111110;   // -1/3628800
reg [31:0] c6 = 32'b00110001000011110111011011000111;   // 1/479001600
reg [31:0] cP1;
reg [31:0] cP2;
reg [31:0] cP3;
reg [31:0] cP4;
reg [31:0] cP5;
reg [31:0] cP6;
byte n;

reg [31:0] tempResult;

always_comb
begin
if (n_rst == 0) begin
    sine_result = 32'b0;
    cosine_result = 32'b0;
    done = 1;
  end
else begin
///////////////////////////////////////////// Sine
// - x**3/6
////$display("x^3/6");
findProduct(opx, opx, sP1);
////$display("sp1 is %f", $bitstoshortreal(sP1));
for (n=0; n<1; n=n+1) begin
////$display("sp1 is %f", $bitstoshortreal(sP1));
findProduct(sP1, opx, sP1);
end
findProduct(sP1, s1, sP1);
////$display("final sp1 is %f", $bitstoshortreal(sP1));

//+ x**5/120
////$display("x^5/120");
findProduct(opx, opx, sP2);
////$display("sp2 is %f", $bitstoshortreal(sP2));
for (n=0; n<3; n=n+1) begin
findProduct(sP2, opx, sP2);
////$display("sp2 is %f", $bitstoshortreal(sP2));
end
findProduct(sP2, s2, sP2);
////$display("final sp2 is %f", $bitstoshortreal(sP2));


//- x**7/5040 
findProduct(opx, opx, sP3);
for (n=0; n<5; n=n+1) begin
findProduct(sP3, opx, sP3);
end
findProduct(sP3, s3, sP3);

//+ x**9/362880 
findProduct(opx, opx, sP4);
for (n=0; n<7; n=n+1) begin
findProduct(sP4, opx, sP4);
end
findProduct(sP4, s4, sP4);

//- x**11/39916800
findProduct(opx, opx, sP5);
for (n=0; n<9; n=n+1) begin
findProduct(sP5, opx, sP5);
end
findProduct(sP5, s5, sP5);

////$display("sin(x) = %f", x - x**3/6 + x**5/120 - x**7/5040 + x**9/362880 - x**11/39916800 );  // + x**13/6227020800  - x**15/1307674368000 + x**17/355687428096000 - x**19/121645100408832000
//$display("\n\n\n/////////////////////////////////");
findSum(opx, sP1, sine_result);
//$display("opx is %f + sP1: %f = ",$bitstoshortreal(opx), $bitstoshortreal(sP1));
////$display("sine result is %f",$bitstoshortreal(sine_result));

tempResult = sine_result;
//$display("---> temp result is %b, sP2 is %b",tempResult,sP2);
//$display("---> temp result is %f, sP2 is %f",$bitstoshortreal(tempResult),$bitstoshortreal(sP2));
findSum(tempResult, sP2, sine_result);
//$display("---> sine result is %f",$bitstoshortreal(sine_result));
//$display("result is %f + sP2 (+x^5/120): %f = ",$bitstoshortreal(sine_result), $bitstoshortreal(sP2));
//$display("sine result is %f",$bitstoshortreal(sine_result));

tempResult = sine_result;
findSum(tempResult, sP3, sine_result);
//$display("result is %f + sP3 (-x^7/5040): %f = ",$bitstoshortreal(sine_result), $bitstoshortreal(sP2));
//$display("sine result is %f",$bitstoshortreal(sine_result));

tempResult = sine_result;
findSum(tempResult, sP4, sine_result);
//$display("result is %f + sP4: %f = ",$bitstoshortreal(sine_result), $bitstoshortreal(sP4));
//$display("sine result is %f",$bitstoshortreal(sine_result));

tempResult = sine_result;
findSum(tempResult, sP5, sine_result);
//$display("result is %f + sP4: %f = ",$bitstoshortreal(sine_result), $bitstoshortreal(sP5));
//$display("sine result is %f",$bitstoshortreal(sine_result));
//$display("\n\n\n/////////////////////////////////");

///////////////////////////////////////////// Cos
////$display("cos(x) = %f", 1 - x**2/2 + x**4/24 - x**6/720 + x**8/40320 - x**10/3628800 + x**12/479001600);

// - x**2/2
findProduct(opx, opx, cP1);
findProduct(cP1, c1, cP1);

//+ x**4/24
findProduct(opx, opx, cP2);
for (n=0; n<2; n=n+1) begin
findProduct(cP2, opx, cP2);
end
findProduct(cP2, c2, cP2);

//- x**6/720
findProduct(opx, opx, cP3);
for (n=0; n<4; n=n+1) begin
findProduct(cP3, opx, cP3);
end
findProduct(cP3, c3, cP3);

//+ x**8/40320 
findProduct(opx, opx, cP4);
for (n=0; n<6; n=n+1) begin
findProduct(cP4, opx, cP4);
end
findProduct(cP4, c4, cP4);

//- x**10/3628800
findProduct(opx, opx, cP5);
for (n=0; n<8; n=n+1) begin
findProduct(cP5, opx, cP5);
end
findProduct(cP5, c5, cP5);

//+ x**12/479001600
findProduct(opx, opx, cP6);
for (n=0; n<10; n=n+1) begin
findProduct(cP6, opx, cP6);
end
findProduct(cP6, c6, cP6);
end

findSum(one, cP1, cosine_result);
tempResult = cosine_result;
findSum(tempResult, cP2, cosine_result);
tempResult = cosine_result;
findSum(tempResult, cP3, cosine_result);
tempResult = cosine_result;
findSum(tempResult, cP4, cosine_result);
tempResult = cosine_result;
findSum(tempResult, cP5, cosine_result);
tempResult = cosine_result;
findSum(tempResult, cP6, cosine_result);

//$display("\n\n\n/////////////////////////////////");
//$display("cP1: %f", $bitstoshortreal(cP1));
//$display("cP2: %f", $bitstoshortreal(cP2));
//$display("cP3: %f", $bitstoshortreal(cP3));
//$display("cP4: %f", $bitstoshortreal(cP4));
//$display("cP5: %f", $bitstoshortreal(cP5));
//$display("cP6: %f", $bitstoshortreal(cP6));
//$display("\n\n\n\/////////////////////////////////");


end







//////////////////////////////////////////////////////////// Helper Tasks
/*
task findProduct(
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] mul_result
);

task findSum(
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] add_result
);
*/
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////// findProduct 
task findProduct(
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] mul_result
);
begin

bit sign;
reg [23:0] m1;
reg [23:0] m2;
reg [7:0] exp;
reg [47:0] mul;
reg [31:0] ans;

// determine exponent
exp = op1[30:23] + op2[30:23];
exp = exp - 8'b01111111;
// determine mantissa
m1 = {1,op1[22:0]};   
m2 = {1,op2[22:0]};
mul = m1 * m2;
if(mul[47] == 1) begin
	mul = mul >> 1;
	exp = exp + 1'b1;
end
// determine sign
sign = op1[31] ^ op2[31];
// set result
ans = {sign, exp, mul[45:23]}; 
mul_result = ans;
end
endtask


///////////////////////////////////////////////// Find most significant bit
task findMSB(
input reg [24:0] frac,
input reg [7:0] exp,
output reg [24:0] outFrac,
output reg [7:0] outExp
);
begin
reg [24:0] tempFrac;
byte msbFound;
tempFrac = frac;
msbFound = 0;

if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
               msbFound = 1;
         end
 end
outFrac = frac;
outExp = exp;
end
endtask


///////////////////////////////////////////////// Find Sum
task findSum(
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] add_result
);
begin
bit sign;
byte n, i, msbFound;
reg [7:0] exp;
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] expDiff;
reg [24:0] frac;
reg [23:0] f1;
reg [23:0] f2;
reg [24:0] tempFrac;
reg [7:0] tempExp;
reg [31:0] ans;


exp1 = op1[30:23];
exp2 = op2[30:23];
f1 = {1,op1[22:0]};
f2 = {1,op2[22:0]};
sign = 0;

////////////// SAME EXPONENT //////////////////   
  if (exp1 == exp2) begin 
   exp = exp1;
  //////////// SAME SIGN  /////////////
    if(op1[31] == op2[31]) begin
        frac = f1+f2;
        sign = op1[31];
          if (frac[24] == 1)
          exp = exp1 + 1'b1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
        if (f1 > f2) begin
          frac = f1-f2;
              if (op1[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2[31] == 1)
                sign = 1;
        end
      frac = frac << 2;
      tempFrac = frac;
      tempExp = exp;
      findMSB (tempFrac, tempExp, frac, exp);
      exp = exp - 1'b1;
    end
    ans = {sign, exp, frac[23:1]};
    
  //////////// SAME VALUE +/- /////////////
  if ((op1[31] != op2[31]) && (f1 == f2)) begin
      add_result = 32'b0000;
  end 
end
else if (exp1 > exp2) begin
////$display("\n///////////////////// A > B /////////////////////");
 sign = op1[31];
 expDiff = exp1 - exp2;
 f2 = f2 >> expDiff;
 exp = exp1;
  if(op1[31] == op2[31]) begin
        frac = f1+f2;
         if (frac[24] == 1)
          exp = exp1 + 1'b1;
          frac = frac << 1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
          if (f1 > f2) begin
          frac = f1-f2;
              if (op1[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2[31] == 1)
                sign = 1;
        end
 
  frac = frac << 1;
  tempFrac = frac;
  tempExp = exp;
  findMSB (tempFrac, tempExp, frac, exp);
   end
    ans = {sign, exp, frac[23:1]};
end

else begin
////$display("\n\n\n///////////////////// A < B /////////////////////");
 sign = op2[31];
 expDiff = exp2 - exp1;
 f1 = f1 >> expDiff;
 exp = exp2;

 if(op1[31] == op2[31]) begin
        frac = f1+f2;
         if (frac[24] == 1)
          exp = exp1 + 1'b1;
          frac = frac << 1;
    end
    //////////// DIFF SIGN  /////////////
    else begin
          if (f1 > f2) begin
          frac = f1-f2;
              if (op1[31] == 1)
                sign = 1;
          end
        else begin
          frac = f2-f1;
          if (op2[31] == 1)
            sign = 1;
        end
 
  frac = frac << 1;
  tempFrac = frac;
  tempExp = exp;
  findMSB (tempFrac, tempExp, frac, exp);
  end
  ans = {sign, exp, frac[23:1]};
end
add_result = ans;
end
endtask




endmodule








/*

real num, sinAns, cosAns;
real pi = 3.141592654;
int  x = 0;



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


op = 32'b00111111111100000000000000000000;
test = $bitstoshortreal(op);
//$display("conversion = %b = %f", op, test);

//$display("\n\n\nx = pi");
//$display("sin(x) = %f", x - x**3/6 + x**5/120 - x**7/5040 + x**9/362880 - x**11/39916800 );  // + x**13/6227020800  - x**15/1307674368000 + x**17/355687428096000 - x**19/121645100408832000
//$display("cos(x) = %f", 1 - x**2/2 + x**4/24 - x**6/720 + x**8/40320 - x**10/3628800 + x**12/479001600);

//$display("\ny = pi/2");
//$display("sin(y) = %f", y - y**3/6 + y**5/120 - y**7/5040 + y**9/362880 - y**11/39916800);
//$display("cos(y) = %f", 1 - y**2/2 + y**4/24 - y**6/720 + y**8/40320 - y**10/3628800 + y**12/479001600);

//$display("\nz = pi/4");
//$display("sin(z) = %f", z - z**3/6 + z**5/120 - z**7/5040 + z**9/362880 - z**11/39916800);
//$display("cos(z) = %f", 1 - z**2/2 + z**4/24 - z**6/720 + z**8/40320 - z**10/3628800 + z**12/479001600);

//$display("\na = 0");
//$display("sin(z) = %f", a - a**3/6 + a**5/120 - a**7/5040 + a**9/362880 - a**11/39916800);
//$display("cos(z) = %f", 1 - a**2/2 + a**4/24 - a**6/720 + a**8/40320 - a**10/3628800 + a**12/479001600);
*/

/*//$display("mod  %f", 26%3);
//$display("mod  %f", 72%6);
//$display("mod  %f", 1%9);
//$display("div  %f", 728/6.28);
*/