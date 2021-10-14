/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module sccpu_intr (clk,clrn,inst,mem,pc,wmem,alu,data,intr,inta);
    input  [31:0] inst;                           // inst from inst memory
    input  [31:0] mem;                            // data from data memory
    input         intr;                           // interrupt request
    input         clk, clrn;                      // clock and reset
    output [31:0] pc;                             // program counter
    output [31:0] alu;                            // alu output
    output [31:0] data;                           // data to data memory
    output        wmem;                           // write data memory
    output        inta;                           // interrupt acknowledge
    parameter     BASE = 32'h00000008;            // exc/int handler entry
    parameter     ZERO = 32'h00000000;            // zero
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
    wire    [1:0] mfc0;                           // move from c0 regs
    wire    [1:0] selpc;                          // select for pc
    wire          v;                              // overflow
    wire          exc;                            // exc or int occurs
    wire          wsta;                           // write status reg
    wire          wcau;                           // write cause reg
    wire          wepc;                           // write epc reg
    wire          mtc0;                           // move to c0 regs
    // datapath wires
    wire   [31:0] p4;                             // pc+4
    wire   [31:0] bpc;                            // branch target address
    wire   [31:0] npc;                            // next pc, not exc/int
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
    wire          z;                              // alu zero tag
    wire   [31:0] sta;                            // output of status reg
    wire   [31:0] cau;                            // output of cause reg
    wire   [31:0] epc;                            // output of epc reg
    wire   [31:0] sta_in;                         // data in for status reg
    wire   [31:0] cau_in;                         // data in for cause reg
    wire   [31:0] epc_in;                         // data in for epc reg
    wire   [31:0] sta_lr;                         // status left/right shift
    wire   [31:0] pc_npc;                         // pc or npc
    wire   [31:0] cause;                          // exc/int cause
    wire   [31:0] res_c0;                         // r or c0 regs
    wire   [31:0] n_pc;                           // next pc
    wire   [31:0] sta_r = {4'h0,sta[31:4]};       // status >> 4
    wire   [31:0] sta_l = {sta[27:0],4'h0};       // status << 4
    // control unit
    sccu_intr cu (op,rs,rd,func,z,wmem,wreg,      // control unit
                  regrt,m2reg,aluc,shift,
                  aluimm,pcsrc,jal,sext,
                  intr,inta,v,sta,                // exc/int signals
                  cause,exc,wsta,wcau,
                  wepc,mtc0,mfc0,selpc);
    // datapath
    dff32 i_point (n_pc,clk,clrn,pc);             // pc register
    cla32 pcplus4 (pc,32'h4,1'b0,p4);             // pc + 4
    cla32 br_addr (p4,dis,1'b0,bpc);              // branch target address
    mux2x32 alu_a (qa,sa,shift,alua);             // alu input a
    mux2x32 alu_b (qb,i32,aluimm,alub);           // alu input b
    mux2x32 alu_m (alu,mem,m2reg,r);              // alu out or mem
    mux2x32 link  (res_c0,p4,jal,wd);             // res_c0 or p4
    mux2x5 reg_wn (rd,rt,regrt,reg_dest);         // rs or rt
    mux4x32 nextpc(p4,bpc,qa,jpc,pcsrc,npc);      // next pc, not exc/int
    regfile rf (rs,rt,wd,wn,wreg,clk,clrn,qa,qb); // register file
    alu_ov alunit (alua,alub,aluc,alu,z,v);       // alu_ov, z and v tags
    dffe32  c0sta (sta_in,clk,clrn,wsta,sta);     // c0 status register
    dffe32  c0cau (cau_in,clk,clrn,wcau,cau);     // c0 cause register
    dffe32  c0epc (epc_in,clk,clrn,wepc,epc);     // c0 epc register
    mux2x32 cau_x (cause,qb,mtc0,cau_in);         // mux  for cause reg
    mux2x32 sta_1 (sta_r,sta_l,exc,sta_lr);       // mux1 for status reg
    mux2x32 sta_2 (sta_lr,qb,mtc0,sta_in);        // mux2 for status reg
    mux2x32 epc_1 (pc,npc,inta,pc_npc);           // mux1 for epc reg
    mux2x32 epc_2 (pc_npc,qb,mtc0,epc_in);        // mux2 for epc reg
    mux4x32 nxtpc (npc,epc,BASE,ZERO,selpc,n_pc); // mux for pc
    mux4x32 fr_c0 (r,sta,cau,epc,mfc0,res_c0);    // r or c0 regs
    assign data = qb;                             // regfile output port b
endmodule
