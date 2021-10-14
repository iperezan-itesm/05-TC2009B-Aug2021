/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module sccpu (clk,clrn,inst,mem,pc,wmem,alu,data);
    input  [31:0] inst;                           // inst from inst memory
    input  [31:0] mem;                            // data from data memory
    input         clk, clrn;                      // clock and reset
    output [31:0] pc;                             // program counter
    output [31:0] alu;                            // alu output
    output [31:0] data;                           // data to data memory
    output        wmem;                           // write data memory
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
    wire          aluimm;                         // alu input b is an i32
    wire          jal;                            // instruction is a jal
    wire          sext;                           // is sign extension
    // datapath wires
    wire   [31:0] p4;                             // pc+4
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
    wire   [31:0] jpc = {p4[31:28],addr,2'b00};   // jump target address
    wire    [4:0] reg_dest;                       // rs or rt
    wire    [4:0] wn  = reg_dest | {5{jal}};      // regfile write reg #
    wire          z;                              // alu, zero tag
    // control unit
    sccu_dataflow cu (op,func,z,wmem,wreg,        // control unit
                      regrt,m2reg,aluc,shift,
                      aluimm,pcsrc,jal,sext);
    // datapath
    dff32 i_point (npc,clk,clrn,pc);              // pc register
    cla32 pcplus4 (pc,32'h4,1'b0,p4);             // pc + 4
    cla32 br_addr (p4,dis,1'b0,bpc);              // branch target address
    mux2x32 alu_a (qa,sa,shift,alua);             // alu input a
    mux2x32 alu_b (qb,i32,aluimm,alub);           // alu input b
    mux2x32 alu_m (alu,mem,m2reg,r);              // alu out or mem
    mux2x32 link  (r,p4,jal,wd);                  // r or p4
    mux2x5 reg_wn (rd,rt,regrt,reg_dest);         // rs or rt
    mux4x32 nextpc(p4,bpc,qa,jpc,pcsrc,npc);      // next pc
    regfile rf (rs,rt,wd,wn,wreg,clk,clrn,qa,qb); // register file
    alu alunit (alua,alub,aluc,alu,z);            // alu
    assign data = qb;                             // regfile output port b
endmodule
