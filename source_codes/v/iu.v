/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
// pipelined cpu with instruction memory, data memory, and interface to fpu
module iu (e1n,e2n,e3n, e1w,e2w,e3w, stall,st,dfb,e3d, clk,memclk,clrn,
           fs,ft,wmo,wrn,wwfpr,mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,fasmds,
           pc,inst,ealu,malu,walu,stall_lw,stall_fp,stall_lwc1,stall_swc1);
    input  [31:0] dfb, e3d;
    input   [4:0] e1n, e2n, e3n;
    input         e1w, e2w, e3w, stall, st;
    input         clk, memclk, clrn;                        // clocks, reset
    output [31:0] pc, inst, ealu, malu, walu;
    output [31:0] mmo, wmo;
    output  [4:0] fs, ft, fd, wrn;
    output  [2:0] fc;
    output        wwfpr, fwdla, fwdlb, fwdfa, fwdfb, wf, fasmds;
    output        stall_lw, stall_fp, stall_lwc1, stall_swc1;
    wire   [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,qa,qb,da,db,dimm,dc,dd;
    wire   [31:0] simm,epc8,alua,alub,ealu0,ealu,sa,eb,mmo,wdi;
    wire    [5:0] op,func;
    wire    [4:0] rs,rt,rd,drn,ern;
    wire    [3:0] aluc;
    wire    [1:0] pcsrc,fwda,fwdb;
    wire          wpcir,wreg,m2reg,wmem,aluimm,shift,jal,z;
    reg           ewfpr,ewreg,em2reg,ewmem,ejal,efwdfe,ealuimm,eshift;
    reg           mwfpr,mwreg,mm2reg,mwmem;
    reg           wwfpr,wwreg,wm2reg;
    reg    [31:0] epc4,ea,ed,eimm,malu,mb,wmo,walu;
    reg     [4:0] ern0,mrn,wrn;
    reg     [3:0] ealuc;
    dffe32 program_counter (npc,clk,clrn,wpcir,pc);         // pc
    cla32 pc_plus4 (pc,32'h4,1'b0,pc4);                     // pc+4
    mux4x32 next_pc (pc4,bpc,da,jpc,pcsrc,npc);             // next pc
    inst_mem i_mem (pc,ins);                                // inst memory
    dffe32 pc_4_r (pc4,clk,clrn,wpcir,dpc4);                // pc+4 reg
    dffe32 inst_r (ins,clk,clrn,wpcir,inst);                // ir
    wire swfp,regrt,sext,fwdf,fwdfe,wfpr;
    assign op   = inst[31:26];
    assign rs   = inst[25:21];
    assign rt   = inst[20:16];
    assign rd   = inst[15:11];
    assign ft   = inst[20:16];
    assign fs   = inst[15:11];
    assign fd   = inst[10:6];
    assign func = inst[5:0];
    assign simm = {{16{sext&inst[15]}},inst[15:0]};
    assign jpc  = {dpc4[31:28],inst[25:0],2'b00};           // jump target
    cla32 br_addr (dpc4,{simm[29:0],2'b00},1'b0,bpc);       // branch target
    regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb);       // reg file
    mux4x32 alu_a (qa,ealu,malu,mmo,fwda,da);               // forward A
    mux4x32 alu_b (qb,ealu,malu,mmo,fwdb,db);               // forward B
    mux2x32 store_f (db,dfb,swfp,dc);                       // swc1
    mux2x32 fwd_f_d (dc,e3d,fwdf,dd);                       // forward
    wire    rsrtequ = ~|(da^db);                            // (da == db)
    mux2x5 des_reg_no (rd,rt,regrt,drn);                    // dest reg
    iu_control cu (op,func,rs,rt,fs,ft,rsrtequ,ewfpr,ewreg, // control unit
                   em2reg,ern,mwfpr,mwreg,mm2reg,mrn,e1w,
                   e1n,e2w,e2n,e3w,e3n,stall,st,pcsrc,wpcir,
                   wreg,m2reg,wmem,jal,aluc,aluimm,shift,
                   sext,regrt,fwda,fwdb,swfp,fwdf,fwdfe,wfpr,
                   fwdla,fwdlb,fwdfa,fwdfb,fc,wf,fasmds,
                   stall_lw,stall_fp,stall_lwc1,stall_swc1);
    always @(negedge clrn or posedge clk)                   // ID/EXE regs
      if (!clrn) begin
          ewfpr   <= 0;              ewreg   <= 0;
          em2reg  <= 0;              ewmem   <= 0;
          ejal    <= 0;              ealuimm <= 0;
          efwdfe  <= 0;              ealuc   <= 0;
          eshift  <= 0;              epc4    <= 0;
          ea      <= 0;              ed      <= 0;
          eimm    <= 0;              ern0    <= 0;
      end else begin
          ewfpr   <= wfpr;           ewreg   <= wreg;
          em2reg  <= m2reg;          ewmem   <= wmem;
          ejal    <= jal;            ealuimm <= aluimm;
          efwdfe  <= fwdfe;          ealuc   <= aluc;
          eshift  <= shift;          epc4    <= dpc4;
          ea      <= da;             ed      <= dd;
          eimm    <= simm;           ern0    <= drn;
      end
    cla32 ret_addr (epc4,32'h4,1'b0,epc8);                  // pc+8
    assign sa = {eimm[5:0],eimm[31:6]};                     // shift amount
    mux2x32 alu_ina (ea,sa,eshift,alua);                    // alu input a
    mux2x32 alu_inb (ed,eimm,ealuimm,alub);                 // alu input b
    mux2x32 save_pc8 (ealu0,epc8,ejal,ealu);                // pc+8 if jal
    alu al_unit (alua,alub,ealuc,ealu0,z);                  // alu
    assign ern = ern0 | {5{ejal}};                          // $31 for jal
    mux2x32 fwd_f_e (ed,e3d,efwdfe,eb);                     // forward
    always @(negedge clrn or posedge clk)                   // EXE/MEM regs
      if (!clrn) begin
          mwfpr   <= 0;              mwreg   <= 0;
          mm2reg  <= 0;              mwmem   <= 0;
          malu    <= 0;              mb      <= 0;
          mrn     <= 0;
      end else begin
          mwfpr   <= ewfpr;          mwreg   <= ewreg;
          mm2reg  <= em2reg;         mwmem   <= ewmem;
          malu    <= ealu;           mb      <= eb;
          mrn     <= ern;
      end
    data_mem d_mem (mwmem,malu,mb,memclk,mmo);              // data memory
    always @(negedge clrn or posedge clk)                   // MEM/WB regs
      if (!clrn) begin
          wwfpr   <= 0;              wwreg   <= 0;
          wm2reg  <= 0;              wmo     <= 0;
          walu    <= 0;              wrn     <= 0;
      end else begin
          wwfpr   <= mwfpr;          wwreg   <= mwreg;
          wm2reg  <= mm2reg;         wmo     <= mmo;
          walu    <= malu;           wrn     <= mrn;
      end
    mux2x32 wb_sel (walu,wmo,wm2reg,wdi);
endmodule
