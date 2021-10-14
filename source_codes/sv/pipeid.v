/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipeid (mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,wrn,wdi,ealu,
               malu,mmo,wwreg,clk,clrn,bpc,jpc,pcsrc,nostall,wreg,m2reg,
               wmem,aluc,aluimm,a,b,dimm,rn,shift,jal);// ID stage
    input         clk, clrn;                           // clock and reset
    input  [31:0] dpc4;                                // pc+4 in ID
    input  [31:0] inst;                                // inst in ID
    input  [31:0] wdi;                                 // data in WB
    input  [31:0] ealu;                                // alu res in EXE
    input  [31:0] malu;                                // alu res in MEM
    input  [31:0] mmo;                                 // mem out in MEM
    input   [4:0] ern;                                 // dest reg # in EXE
    input   [4:0] mrn;                                 // dest reg # in MEM
    input   [4:0] wrn;                                 // dest reg # in WB
    input         ewreg;                               // wreg in EXE
    input         em2reg;                              // m2reg in EXE
    input         mwreg;                               // wreg in MEM
    input         mm2reg;                              // m2reg in MEM
    input         wwreg;                               // wreg in MEM
    output [31:0] bpc;                                 // branch target
    output [31:0] jpc;                                 // jump target
    output [31:0] a, b;                                // operands a and b
    output [31:0] dimm;                                // 32-bit immediate
    output  [4:0] rn;                                  // dest reg #
    output  [3:0] aluc;                                // alu control
    output  [1:0] pcsrc;                               // next pc select
    output        nostall;                             // no pipeline stall
    output        wreg;                                // write regfile
    output        m2reg;                               // mem to reg
    output        wmem;                                // write memory
    output        aluimm;                              // alu input b is imm
    output        shift;                               // inst is a shift
    output        jal;                                 // inst is jal
    wire    [5:0] op   = inst[31:26];                  // op
    wire    [4:0] rs   = inst[25:21];                  // rs
    wire    [4:0] rt   = inst[20:16];                  // rt
    wire    [4:0] rd   = inst[15:11];                  // rd
    wire    [5:0] func = inst[05:00];                  // func
    wire   [15:0] imm  = inst[15:00];                  // immediate
    wire   [25:0] addr = inst[25:00];                  // address
    wire          regrt;                               // dest reg # is rt
    wire          sext;                                // sign extend
    wire   [31:0] qa, qb;                              // regfile outputs
    wire    [1:0] fwda, fwdb;                          // forward a and b
    wire   [15:0] s16  = {16{sext & inst[15]}};        // 16-bit signs
    wire   [31:0] dis  = {dimm[29:0],2'b00};           // branch offset
    wire          rsrtequ = ~|(a^b);                   // reg[rs] == reg[rt]
    pipeidcu cu (mwreg,mrn,ern,ewreg,em2reg,mm2reg,    // control unit
                 rsrtequ,func,op,rs,rt,wreg,m2reg,
                 wmem,aluc,regrt,aluimm,fwda,fwdb,
                 nostall,sext,pcsrc,shift,jal);
    regfile r_f (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb); // register file
    mux2x5  d_r (rd,rt,regrt,rn);                      // select dest reg #
    mux4x32 s_a (qa,ealu,malu,mmo,fwda,a);             // forward for a
    mux4x32 s_b (qb,ealu,malu,mmo,fwdb,b);             // forward for b
    cla32 b_adr (dpc4,dis,1'b0,bpc);                   // branch target
    assign dimm = {s16,imm};                           // 32-bit imm
    assign jpc  = {dpc4[31:28],addr,2'b00};            // jump target
endmodule
