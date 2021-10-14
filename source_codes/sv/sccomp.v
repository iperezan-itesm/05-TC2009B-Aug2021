/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module sccomp (clk,clrn,inst,pc,aluout,memout);   // single cycle computer
    input         clk, clrn;                      // clock and reset
    output [31:0] pc;                             // program counter
    output [31:0] inst;                           // instruction
    output [31:0] aluout;                         // alu output
    output [31:0] memout;                         // data memory output
    wire   [31:0] data;                           // data to data memory
    wire          wmem;                           // write data memory
    sccpu cpu (clk,clrn,inst,memout,pc,wmem,aluout,data);   // cpu
    scinstmem imem (pc,inst);                               // inst memory
    scdatamem dmem (clk,memout,data,aluout,wmem);           // data memory
endmodule
