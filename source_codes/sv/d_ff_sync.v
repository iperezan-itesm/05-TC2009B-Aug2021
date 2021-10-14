/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module d_ff_sync (d,clk,clrn,q);      // dff with synchronous reset (to clk)
    input      d, clk, clrn;          // inputs d, clk, clrn (active low)
    output reg q;                     // output q, register type
    always @ (posedge clk) begin      // always block, posedge: rising edge
        if (!clrn) q <= 0;            // if clrn is asserted, reset dff
        else       q <= d;            // else store d to dff
    end
endmodule
