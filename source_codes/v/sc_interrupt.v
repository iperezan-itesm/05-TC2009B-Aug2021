/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module sc_interrupt (clk,clrn,inst,pc,aluout,memout,memclk,intr,inta);
    input         clk, clrn;                      // clock and reset
    input         memclk;                         // synch ram clock
    input         intr;                           // interrupt request
    output        inta;                           // interrupt acknowledge
    output [31:0] pc;                             // program counter
    output [31:0] inst;                           // instruction
    output [31:0] aluout;                         // alu output
    output [31:0] memout;                         // data memory output
    wire   [31:0] data;                           // data to data memory
    wire          wmem;                           // write data memory
    sccpu_intr cpu (clk,clrn,inst,memout,pc,wmem,aluout,data,intr,inta);
    sci_intr im (pc,inst);                        // inst memory
    scd_intr dm (memout,data,aluout,wmem,memclk); // data memory
endmodule
