/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipelined_cpu_exc_int (clk,clrn,pc,inst,ealu,malu,wdi,intr,inta);
    input         clk, clrn;               // clock and reset
    input         intr;                    // interrupt request
    output [31:0] pc;                      // program counter
    output [31:0] inst;                    // instruction in ID stage
    output [31:0] ealu;                    // result in EXE stage
    output [31:0] malu;                    // result in MEM stage
    output [31:0] wdi;                     // result in WB stage
    output        inta;                    // interrupt acknowledgement
    parameter     exc_base = 32'h00000008; // exception handler entry
    // signals in IF stage
    wire   [31:0] pc4,ins,npc;
    wire   [31:0] next_pc;                 // next pc
    // signals in ID stage
    wire   [31:0] dpc4,bpc,jpc,da,db,imm,qa,qb;
    wire    [5:0] op,func;
    wire    [4:0] rs,rt,rd,rn;
    wire    [3:0] aluc;
    wire    [1:0] pcsrc,fwda,fwdb;
    wire          wreg,m2reg,wmem,aluimm,shift,jal,sext,regrt,rsrtequ,wpcir;
    wire   [31:0] pcd;                     // pc in ID stage
    wire   [31:0] cause;                   // cause content
    wire   [31:0] sta_in;                  // status register, data in
    wire   [31:0] cau_in;                  // cause  register, data in
    wire   [31:0] epc_in;                  // epc    register, data in
    wire   [31:0] epcin;                   // pc, pcd, pce, or pcm
    wire   [31:0] stalr;                   // state shift left or right
    wire    [1:0] mfc0;                    // select pc+8, sta, cau, or epc
    wire    [1:0] selpc;                   // select for next_pc
    wire    [1:0] sepc;                    // select for epcin
    wire          isbr;                    // is a branch or a jump
    wire          ove;                     // ov enable = arith & sta[3]
    wire          cancel;                  // cancel next instruction
    wire          exc;                     // exc or int occurs
    wire          mtc0;                    // move to c0 instruction
    wire          wsta;                    // status register write enable
    wire          wcau;                    // cause  register write enable
    wire          wepc;                    // epc    register write enable
    wire          irq;                     // latched intr
    // signals in EXE stage
    wire   [31:0] ealua,ealub,esa,ealu0,epc8;
    reg    [31:0] ea,eb,eimm,epc4;
    reg     [4:0] ern0;
    wire    [4:0] ern;
    reg     [3:0] ealuc;
    reg           ewreg0,em2reg,ewmem,ealuimm,eshift,ejal;
    wire          ewreg,zero;
    wire          exc_ovr;                 // overflow exc in EXE stage
    reg    [31:0] pce;                     // pc in EXE stage
    wire   [31:0] sta;                     // status register, data out
    wire   [31:0] cau;                     // cause  register, data out
    wire   [31:0] epc;                     // epc    register, data out
    wire   [31:0] pc8c0r;                  // epc8, sta, cau, or epc
    reg     [1:0] emfc0;                   // mfc0   in EXE stage
    reg           eisbr;                   // isbr   in EXE stage
    reg           eove;                    // ove    in EXE stage
    reg           ecancel;                 // cancel in EXE stage
    wire          ov;                      // overflow flag
    // signals in MEM stage
    wire   [31:0] mmo;
    reg    [31:0] malu,mb;
    reg     [4:0] mrn;
    reg           mwreg,mm2reg,mwmem;
    reg    [31:0] pcm;                     // pc      in MEM stage
    reg           misbr;                   // isbr    in MEM stage
    reg           mexc_ovr;                // exc_ovr in MEM stage
    // signals in WB stage
    reg    [31:0] wmo,walu;
    reg     [4:0] wrn;
    reg           wwreg,wm2reg;
    // program counter
    dffe32 prog_cnt (next_pc,clk,clrn,wpcir,pc);      // pc
    // IF stage
    cla32 pc_plus4 (pc,32'h4,1'b0,pc4);               // pc+4
    mux4x32 nextpc (pc4,bpc,da,jpc,pcsrc,npc);        // next pc
    pl_exc_i_mem inst_mem (pc,ins);                   // inst mem
    // IF/ID pipeline register
    dffe32 pc_4_r (pc4,clk,clrn,wpcir,dpc4);          // pc+4 reg
    dffe32 inst_r (ins,clk,clrn,wpcir,inst);          // ir
    dffe32 pcd_r  ( pc,clk,clrn,wpcir,pcd);           // pcd reg
    dff    intr_r (intr,clk,clrn,irq);                // interrupt req reg
    // ID stage
    assign op   = inst[31:26];                        // op
    assign rs   = inst[25:21];                        // rs
    assign rt   = inst[20:16];                        // rt
    assign rd   = inst[15:11];                        // rd
    assign func = inst[05:00];                        // func
    assign imm  = {{16{sext&inst[15]}},inst[15:0]};
    assign jpc  = {dpc4[31:28],inst[25:0],2'b00};     // jump target
    regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb); // reg file
    mux2x5  des_reg_no (rd,rt,regrt,rn);              // destination reg
    mux4x32 operand_a (qa,ealu,malu,mmo,fwda,da);     // forward a
    mux4x32 operand_b (qb,ealu,malu,mmo,fwdb,db);     // forward b
    assign  rsrtequ = ~|(da^db);                      // rsrtequ = (da==db)
    cla32 br_addr (dpc4,{imm[29:0],2'b00},1'b0,bpc);  // branch target
    cu_exc_int cu (mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,op,rs,
                   rt,rd,rs,wreg,m2reg,wmem,aluc,regrt,aluimm,fwda,fwdb,
                   wpcir,sext,pcsrc,shift,jal,irq,sta,ecancel,eisbr,misbr,
                   inta,selpc,exc,sepc,cause,mtc0,wepc,wcau,wsta,mfc0,isbr,
                   ove,cancel,exc_ovr,mexc_ovr);
    dffe32  c0_status (sta_in,clk,clrn,wsta,sta);     // status register
    dffe32  c0_cause  (cau_in,clk,clrn,wcau,cau);     // cause register
    dffe32  c0_epc    (epc_in,clk,clrn,wepc,epc);     // epc register
    mux2x32 sta_mx (stalr,db,mtc0,sta_in);            // mux for status reg
    mux2x32 cau_mx (cause,db,mtc0,cau_in);            // mux for cause reg
    mux2x32 epc_mx (epcin,db,mtc0,epc_in);            // mux for epc reg
    mux2x32 sta_lr ({4'h0,sta[31:4]},{sta[27:0],4'h0},exc,stalr);
    mux4x32 epc_10 (pc,pcd,pce,pcm,sepc,epcin);       // select epc source
    mux4x32 irq_pc (npc,epc,exc_base,32'h0,selpc,next_pc); // for pc
    mux4x32 fromc0 (epc8,sta,cau,epc,emfc0,pc8c0r);   // for mfc0
    // ID/EXE pipeline register
    always @(negedge clrn or posedge clk)
      if (!clrn) begin
          ewreg0 <= 0;          em2reg  <= 0;          ewmem <= 0;
          ealuc  <= 0;          ealuimm <= 0;          ea    <= 0;
          eb     <= 0;          eimm    <= 0;          ern0  <= 0;
          eshift <= 0;          ejal    <= 0;          epc4  <= 0;
          eove   <= 0;          ecancel <= 0;          eisbr <= 0;
          emfc0  <= 0;          pce     <= 0;
      end else begin
          ewreg0 <= wreg;       em2reg  <= m2reg;      ewmem <= wmem;
          ealuc  <= aluc;       ealuimm <= aluimm;     ea    <= da;
          eb     <= db;         eimm    <= imm;        ern0  <= rn;
          eshift <= shift;      ejal    <= jal;        epc4  <= dpc4;
          eove   <= ove;        ecancel <= cancel;     eisbr <= isbr;
          emfc0  <= mfc0;       pce     <= pcd;
      end
    // EXE stage
    assign      esa = {eimm[5:0],eimm[31:6]};
    cla32   ret_addr (epc4,32'h4,1'b0,epc8);
    mux2x32 alu_ina  (ea,esa,eshift,ealua);
    mux2x32 alu_inb  (eb,eimm,ealuimm,ealub);
    mux2x32 save_pc8 (ealu0,pc8c0r,ejal|emfc0[1]|emfc0[0],ealu); // c0 regs
    assign  ern = ern0 | {5{ejal}};
    alu_ov  al_unit (ealua,ealub,ealuc,ealu0,zero,ov);
    assign  exc_ovr = ov & eove;                     // overflow exception
    assign  ewreg   = ewreg0 & ~exc_ovr;             // cancel overflow inst
    // EXE/MEM pipeline register
    always @(negedge clrn or posedge clk)
      if (!clrn) begin
          mwreg  <= 0;          mm2reg  <= 0;          mwmem <= 0;
          malu   <= 0;          mb      <= 0;          mrn   <= 0;
          misbr  <= 0;          pcm     <= 0;          mexc_ovr <= 0;
      end else begin
          mwreg  <= ewreg;      mm2reg  <= em2reg;     mwmem <= ewmem;
          malu   <= ealu;       mb      <= eb;         mrn   <= ern;
          misbr  <= eisbr;      pcm     <= pce;        mexc_ovr <= exc_ovr;
      end
    // MEM stage
    pl_exc_d_mem data_mem (clk,mmo,mb,malu,mwmem);   // data mem
    // MEM/WB pipeline register
    always @(negedge clrn or posedge clk)
      if (!clrn) begin
          wwreg  <= 0;          wm2reg  <= 0;          wmo   <= 0;
          walu   <= 0;          wrn     <= 0;
      end else begin
          wwreg  <= mwreg;      wm2reg  <= mm2reg;     wmo   <= mmo;
          walu   <= malu;       wrn     <= mrn;
      end
    // WB stage
    mux2x32 wb_stage (walu,wmo,wm2reg,wdi);          // alu res or mem data
endmodule
