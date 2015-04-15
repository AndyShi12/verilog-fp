// $Id: $
// File name:   addsub.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: add and subtract module

module addsub(
input wire clk, n_rst, add_start, mode,
input reg [31:0] op1,
input reg [31:0] op2,
output reg [31:0] add_result,
output reg add_done, add_overflow
);

reg sign;
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] expDiff;
reg [7:0] exp;
byte n, i, msbFound;
reg [23:0] f1;
reg [23:0] f2;
reg [24:0] frac;
reg [24:0] tempFrac;
reg [31:0] ans;

always_ff @ (posedge clk, negedge n_rst) 
begin
    if (n_rst == 0) begin
      add_result <= 0;
      add_overflow <= 0;
      add_done <= 0;
    end
    else begin
      add_result <= ans;
      add_overflow <= 0;
      add_done <= 1;
    end
end
  
always_comb
begin
    
exp1 = op1[30:23];
exp2 = op2[30:23];
f1 = {1,op1[22:0]};
f2 = {1,op2[22:0]};
sign = 0;
////////////// SAME EXPONENT //////////////////   
if (exp1 == exp2) begin 
//$display("\n\n\n///////////////////// SAME EXP /////////////////////");
   exp = exp1;
   sign = 0;

   //////////// SAME SIGN  /////////////
   if(op1[31] == op2[31]) begin
  // $display("##############same sign");
      frac = f1+f2;
      sign = op1[31];
        if (frac[24] == 1)
        exp = exp1 + 1'b1;
   end

   //////////// POS/NEG  /////////////
   else if (op1[31] == 0 && op2[31] == 1) begin
     // $display("##############pos/neg");
    //  $display("op1 is %b, op2 is %b", op1, op2);
      if (f1 > f2)
        frac = f1-f2;
      else
        frac = f2-f1;

      if(f1 < f2)
        sign = 1;

        frac = frac << 2;
        tempFrac = frac;
        msbFound = 0;
    /*    if (frac != 0) begin
         while (frac[24] == 0) begin
            frac = frac << 1;
            exp = exp - 1'b1;
         end
          exp = exp - 1'b1;
       end
*/
        if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
       //     $display("1111look iter = %d", n);
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
               msbFound = 1;
          end
          exp = exp - 1'b1;
      end



       if(f1 < f2)
          sign = 1;

     // $display("f1 is %b, f2 is %b, frac is %b", f1,f2,frac);

   end
  //////////// NEG/POS /////////////
   else begin
   //  $display("##############neg/pos");
  //   $display("op1 is %b, op2 is %b", op1, op2);
       if (f1 > f2)
        frac = f1-f2;
       else
        frac = f2-f1;
      
      if(f1 > f2)
        sign = 1;

         frac = frac << 2;

      tempFrac = frac;
      msbFound = 0;
      if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
          //  $display("+++++look iter = %d", n);
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
                msbFound = 1;
          end
          exp = exp - 1'b1;
      end

   /*    if (frac != 0) begin
        while (frac[24] == 0) begin
          frac = frac << 1;
          exp = exp - 1'b1;
        end
          exp = exp - 1'b1;
        end*/


   //   $display("f1 is %b, f2 is %b, frac is %b", f1,f2,frac);
   end
    ans = {sign, exp, frac[23:1]};

    //////////// SAME VALUE /////////////
    if ((op1[31] != op2[31]) && (f1 == f2)) begin
   //   $display("##############same value pos/neg");
      ans = 32'b0000;
    end 
end






else if (exp1 > exp2) begin
//$display("\n\n\n///////////////////// NUM > DEMS /////////////////////");
 sign = op1[31];
 //$display("op1 is %b, op2 is %b", op1,op2);
 expDiff = exp1 - exp2;
 // $display("ORIGINAL f1 is %b, f2 is %b", f1, f2);
  f2 = f2 >> expDiff;
  exp = exp1;
 // $display("NEW f1 is %b, f2 is %b", f1, f2);
 // $display("exp1 = %b, exp2 = %b", exp1, exp2);

  if(op1[31] == op2[31]) begin
  // $display("##############same sign");
  // $display("op1 = %b, op2 =%b", op1[31], op2[31]);
     frac = f1+f2;
     frac = frac << 1;
//$display("frac is = %b", frac);

   end
   //////////// POS/NEG  /////////////
   else if (op1[31] == 0 && op2[31] == 1) begin
  //   $display("##############pos/neg");
  //    $display("op1 is %b, op2 is %b", op1, op2);
    $display("AAAAAAAA");
      if (f1 > f2)
        frac = f1-f2;
      else
        frac = f2-f1;

        frac = frac << 2;
        
   /* if (frac != 0) begin
         while (frac[24] == 0) begin
            frac = frac << 1;
            exp = exp - 1'b1;
         end 
       end*/
      

     tempFrac = frac;
     msbFound = 0;
      if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
        //    $display("2222look iter = %d", n);
             if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
              msbFound = 1;
          end
      end


    frac = frac >> 1;

       if(f1 < f2)
          sign = 1;

   // $display("f1 is %b, f2 is %b, frac is %b", f1,f2,frac);

   end
  //////////// NEG/POS /////////////
   else begin
    // $display("##############neg/pos");
    //  $display("op1 is %b, op2 is %b", op1, op2);
       if (f1 > f2)
        frac = f1-f2;
       else
        frac = f2-f1;
      
      if(f1 > f2)
        sign = 1;

         frac = frac << 1;
      
     /*if (frac != 0) begin
        while (frac[24] == 0) begin
             frac = frac << 1;
             exp = exp - 1'b1;
         end
          //frac = frac << 1;
       end*/
       msbFound = 0;
        tempFrac = frac;
      if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
          //  $display("???look iter = %d", n);
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
                     msbFound = 1;
          end
  
      end

     // $display("f1 is %b, f2 is %b, frac is %b", f1,f2,frac);
   end

    ans = {sign, exp, frac[23:1]};
    
end



else begin
//$display("\n\n\n///////////////////// NUM < DEM /////////////////////");
 sign = op2[31];
 expDiff = exp2 - exp1;
 // $display("ORIGINAL f1 is %b, f2 is %b", f1, f2);
  f1 = f1 >> expDiff;
  exp = exp2;
 // $display("NEW f1 is %b, f2 is %b", f1, f2);
 // $display("exp1 = %b, exp2 = %b", exp1, exp2);


  if(op1[31] == op2[31]) begin
  // $display("##############same sign");
  $display("CCCCC");
    frac = f1+f2;
  //  $display("frac is = %b", frac);
      frac = frac << 1;
      sign = op1[31];
   end
   //////////// POS/NEG  /////////////
  else if (op1[31] == 0 && op2[31] == 1) begin
   $display("DDDDDDDD");
  //    $display("##############pos/neg");
  //    $display("op1 is %b, op2 is %b", op1, op2);
      if (f1 > f2)
        frac = f1-f2;
      else
        frac = f2-f1;

      //  $display("fractional bit is %b", frac);
        frac = frac << 1;
     //   $display("fractional bit is now (shifted) %b", frac);
        
      /* if (frac != 0) begin
         while (frac[24] == 0) begin
            frac = frac << 1;
            exp = exp - 1'b1;
         end
       end*/

        tempFrac = frac;
        msbFound = 0;
      if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
           // $display("???look iter = %d", n);
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
                msbFound = 1;
          end
  
      end

   // $display("f1 is %b, f2 is %b, frac is %b", f1,f2,frac);

   end
  //////////// NEG/POS /////////////
   else begin
    $display("EEEEE");
     // $display("##############neg/pos");
    //  $display("op1 is %b, op2 is %b", op1, op2);
       if (f1 > f2)
        frac = f1-f2;
       else
        frac = f2-f1;
  
        frac = frac << 1;
      

      /*  if (frac != 0) begin
         while (frac[24] == 0) begin
            frac = frac << 1;
            exp = exp - 1'b1;
         end
       end*/

      tempFrac = frac;
      msbFound=0;
      if (frac != 0) begin
         for (n=0; n<24; n=n+1) begin
            //$display("------look iter = %d", n);
            if((tempFrac[24-n] == 0) && (msbFound == 0)) begin
                frac = frac << 1;
                exp = exp - 1'b1;
            end
            else
                msbFound = 1;
          end
      end



   //  $display("f1 is %b, f2 is %b, frac is %b", f1,f2,frac);
   end

    ans = {sign, exp, frac[23:1]};

// ans = {sign, exp, frac[23:1]};
end

    
////////////////////////////////////////////////////////////////////////////////////////////////////////////// Same exponential
end
endmodule



/*
op1: 0 01111111 01000000    00000000 0000 000
op2: 0 01111111 10000000    00000000 0000 000 (>> 2 at bit 9)
   ----------- ---------
res: 0 10000000 01100000    00000000 0000 000



op1: 0 01111111 10000000    000000000000000
op2: 0 01111111 01000000    000000000000000 (flip and +1)
     0 01111111 01000000    000000000000000
    ---------- ---------
res: 0 01111101 00000000    000000000000000


 1.25     00111111101000000000000000000000
+1.50      00111111110000000000000000000000
 2.75     01000000001100000000000000000000

 1.50      00111111110000000000000000000000
-1.25     00111111101000000000000000000000
 0.25      00111110100000000000000000000000
*/
