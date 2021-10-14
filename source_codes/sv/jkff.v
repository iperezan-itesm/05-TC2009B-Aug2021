/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module jkff (j,k,clk,clrn,q);               // jkff with asynchronous reset
    input      j, k, clk, clrn;             // inputs j, k, clock, reset
    output reg q;                           // output q, register type
    always @ (posedge clk or negedge clrn) begin // always block, "or"
        if (!clrn) q <= 0;                  // if clrn is active, reset jkff
        else       q <= j & ~q | ~k & q;    // else update jkff
    end
endmodule
