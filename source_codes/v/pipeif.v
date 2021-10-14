/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipeif (pcsrc,pc,bpc,rpc,jpc,npc,pc4,ins);    // IF stage
    input  [31:0] pc;                                // program counter
    input  [31:0] bpc;                               // branch target
    input  [31:0] rpc;                               // jump target of jr
    input  [31:0] jpc;                               // jump target of j/jal
    input   [1:0] pcsrc;                             // next pc (npc) select
    output [31:0] npc;                               // next pc
    output [31:0] pc4;                               // pc + 4
    output [31:0] ins;                               // inst from inst mem
    mux4x32 next_pc (pc4,bpc,rpc,jpc,pcsrc,npc);     // npc select
    cla32  pc_plus4 (pc,32'h4,1'b0,pc4);             // pc + 4
    pl_inst_mem inst_mem (pc,ins);                   // inst mem
endmodule
