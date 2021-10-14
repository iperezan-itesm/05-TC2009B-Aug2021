/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module vpc (d,clk,clrn,e,q);                      // virtual program counter
    input      [31:0] d;                          // input d
    input             e;                          // e: enable
    input             clk, clrn;                  // clock and reset
    output reg [31:0] q;                          // output q
    always @(negedge clrn or posedge clk)
        if (!clrn)                                // if reset
            q <= 32'h8000_0000;                   // kseg0 starting address
        else if (e) q <= d;                       // save d if enabled
endmodule
