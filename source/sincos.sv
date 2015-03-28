// $Id: $
// File name:   sincos.sv
// Created:     3/24/2015
// Author:      Andy Shi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: sine and cosine module

module sincos(
input wire clk, n_rst, sine_start,
input reg [0:31] opx,
output reg [0:31] sine_result,
output wire sine_done
);


always_ff @ (posedge clk, negedge n_rst) 
begin
 if (n_rst == 0) begin
    sine_result <= 0;
    sine_done = 0;
    end
end


// have to get it under pi... x = x%pi wouuld work? .. negatives?
// sin(x) = x - x^3/3! + x^5/5! - x^7/7! + x^9/9! - x^11/11!
// sin(x) = x - x**3/6 + x^5/120 - x^7/5040 + x^9/362880 - x^11/39916800
 
// cos(x) = 1 - x^2/2! + x^4/4! - x^6/6! + x^8/8! - x^10/10!
// cos(x) = 1 - x^2/2  + x^2/24 - x^6/720 + x^8/40320 - x^10/3628800

endmodule