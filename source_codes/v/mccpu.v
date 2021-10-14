/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mccpu (clk,clrn,frommem,pc,inst,alua,alub,alu,wmem,madr,tomem,state);
    input  [31:0] frommem;                        // data from memory
    input         clk, clrn;                      // clock and reset
    output [31:0] pc;                             // program counter
    output [31:0] inst;                           // instruction
    output [31:0] alua;                           // alu input a
    output [31:0] alub;                           // alu input b
    output [31:0] alu;                            // alu result
    output [31:0] madr;                           // memory address
    output [31:0] tomem;                          // data to memory
    output  [2:0] state;                          // state
    output        wmem;                           // memory write enable
    // instruction fields
    wire    [5:0] op   = inst[31:26];             // op
    wire    [4:0] rs   = inst[25:21];             // rs
    wire    [4:0] rt   = inst[20:16];             // rt
    wire    [4:0] rd   = inst[15:11];             // rd
    wire    [5:0] func = inst[05:00];             // func
    wire   [15:0] imm  = inst[15:00];             // immediate
    wire   [25:0] addr = inst[25:00];             // address
    // control signals
    wire    [3:0] aluc;                           // alu operation control
    wire    [1:0] pcsrc;                          // select pc source
    wire          wreg;                           // write regfile
    wire          regrt;                          // dest reg number is rt
    wire          m2reg;                          // instruction is an lw
    wire          shift;                          // instruction is a shift
    wire    [1:0] alusrcb;                        // alu input b selection
    wire          jal;                            // instruction is a jal
    wire          sext;                           // is sign extension
    wire          wpc;                            // write pc
    wire          wir;                            // write ir
    wire          iord;                           // select memory address
    wire          selpc;                          // select pc
    // datapath wires
    wire   [31:0] bpc;                            // branch target address
    wire   [31:0] npc;                            // next pc
    wire   [31:0] qa;                             // regfile output port a
    wire   [31:0] qb;                             // regfile output port b
    wire   [31:0] alua;                           // alu input a
    wire   [31:0] alub;                           // alu input b
    wire   [31:0] wd;                             // regfile write port data
    wire   [31:0] r;                              // alu out or mem
    wire   [31:0] sa  = {27'b0,inst[10:6]};       // shift amount
    wire   [15:0] s16 = {16{sext & inst[15]}};    // 16-bit signs
    wire   [31:0] i32 = {s16,imm};                // 32-bit immediate
    wire   [31:0] dis = {s16[13:0],imm,2'b00};    // word distance
    wire   [31:0] jpc = {pc[31:28],addr,2'b00};   // jump target address
    wire    [4:0] reg_dest;                       // rs or rt
    wire    [4:0] wn  = reg_dest | {5{jal}};      // regfile write reg #
    wire          z;                              // alu, zero tag
    wire   [31:0] rega;                           // register a
    wire   [31:0] regb;                           // register b
    wire   [31:0] regc;                           // register c
    wire   [31:0] data;                           // output of dr
    wire   [31:0] opa;                            // sa or output of reg a
    // datapath
    mccu control_unit (op,func,z,clk,clrn,        // control unit
                       wpc,wir,wmem,wreg,
                       iord,regrt,m2reg,aluc,
                       shift,selpc,alusrcb,
                       pcsrc,jal,sext,state);
    dffe32  ip    (npc,clk,clrn,wpc,pc);          // pc register
    dffe32  ir    (frommem,clk,clrn,wir,inst);    // instruction register
    dff32   dr    (frommem,clk,clrn,data);        // data register
    dff32   reg_a (qa, clk,clrn,rega);            // register a
    dff32   reg_b (qb, clk,clrn,regb);            // register b
    dff32   reg_c (alu,clk,clrn,regc);            // register c
    mux2x32 aorsa (rega,sa,shift,opa);            // sa or output of reg a
    mux2x32 alu_a (opa,pc,selpc,alua);            // alu input a
    mux4x32 alu_b (regb,32'h4,i32,dis,alusrcb,alub); // alu input b
    mux2x32 alu_m (regc,data,m2reg,r);            // alu out or mem data
    mux2x32 mem_a (pc,regc,iord,madr);            // memory address
    mux2x32 link  (r,pc,jal,wd);                  // r or pc
    mux2x5 reg_wn (rd,rt,regrt,reg_dest);         // rs or rt
    mux4x32 nextpc(alu,regc,qa,jpc,pcsrc,npc);    // next pc
    regfile rf (rs,rt,wd,wn,wreg,clk,clrn,qa,qb); // register file
    alu alunit (alua,alub,aluc,alu,z);            // alu
    assign tomem = regb;                          // output of reg b
endmodule
