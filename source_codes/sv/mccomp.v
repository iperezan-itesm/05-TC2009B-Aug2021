/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mccomp (clk,clrn,q,a,b,alu,adr,tom,fromm,pc,ir,memclk);
    input         clk, clrn;                      // clock and reset
    input         memclk;                         // memory clk for sync ram
    output [31:0] a;                              // alu input a
    output [31:0] b;                              // alu input b
    output [31:0] alu;                            // alu result
    output [31:0] adr;                            // memory address
    output [31:0] tom;                            // data to memory
    output [31:0] fromm;                          // data from memory
    output [31:0] pc;                             // program counter
    output [31:0] ir;                             // instruction register
    output  [2:0] q;                              // state
    wire          wmem;                           // memory write enable
    mccpu mc_cpu (clk,clrn,fromm,pc,ir,a,b,alu,wmem,adr,tom,q);    // cpu
    mcmem memory (fromm,tom,adr,wmem,memclk);                      // memory
endmodule
