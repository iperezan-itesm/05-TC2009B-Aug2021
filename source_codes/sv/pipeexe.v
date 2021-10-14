/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipeexe (ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu);
    input  [31:0] ea, eb;                            // all in EXE stage
    input  [31:0] eimm;                              // imm
    input  [31:0] epc4;                              // pc+4
    input   [4:0] ern0;                              // temporary dest reg #
    input   [3:0] ealuc;                             // aluc
    input         ealuimm;                           // aluimm
    input         eshift;                            // shift
    input         ejal;                              // jal
    output [31:0] ealu;                              // EXE stage result
    output  [4:0] ern;                               // dest reg #
    wire   [31:0] alua;                              // alu input a
    wire   [31:0] alub;                              // alu input b
    wire   [31:0] ealu0;                             // alu result
    wire   [31:0] epc8;                              // pc+8
    wire          z;                                 // alu z flag, not used
    wire   [31:0] esa = {eimm[5:0],eimm[31:6]};      // shift amount
    cla32   ret_addr (epc4,32'h4,1'b0,epc8);         // pc+8
    mux2x32 alu_in_a (ea,esa,eshift,alua);           // alu input a
    mux2x32 alu_in_b (eb,eimm,ealuimm,alub);         // alu input b
    mux2x32 save_pc8 (ealu0,epc8,ejal,ealu);         // alu result or pc+8
    assign ern = ern0 | {5{ejal}};                   // dest reg #, jal: 31
    alu al_unit (alua,alub,ealuc,ealu0,z);           // alu result, z flag
endmodule
