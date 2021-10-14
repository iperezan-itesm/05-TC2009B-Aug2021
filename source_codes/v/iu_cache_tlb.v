/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module iu_cache_tlb (e1n,e2n,e3n, e1w,e2w,e3w, stall,st,dfb,e3d,clk,
                     memclk,clrn,no_cache_stall,dtlb,fs,ft,wmo,wrn,wwfpr,
                     mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,fasmds,v_pc,pc,
                     inst,ealu,malu,wdi,stall_lw,stall_fp,stall_lwc1,
                     stall_swc1,mem_a,mem_data,mem_st_data,mem_access,
                     mem_write,mem_ready,io);  // iu + cache + tlb
    input         clk, memclk, clrn;           // clocks and reset
    input  [31:0] mem_data;                    // main mem data read
    input  [31:0] dfb;                         // fpu b in id stage
    input  [31:0] e3d;                         // fpu data in e3 stage
    input   [4:0] e1n, e2n, e3n;               // fp reg numbers
    input         e1w, e2w, e3w;               // fp reg write enables
    input         stall;                       // stall by div and sqrt
    input         st;                          // not used
    input         mem_ready;                   // main mem ready
    output [31:0] v_pc;                        // virtual pc
    output [31:0] pc;                          // real pc
    output [31:0] inst;                        // inst
    output [31:0] ealu;                        // alu output in exe stage
    output [31:0] malu;                        // alu output in mem stage
    output [31:0] wdi;                         // data to iu reg file
    output [31:0] mmo;                         // main mem out in mem stage
    output [31:0] wmo;                         // main mem out in wb stage
    output [31:0] mem_a;                       // main mem address
    output [31:0] mem_st_data;                 // main mem data write
    output  [4:0] fs, ft, fd;                  // fpu fs, ft, fd
    output  [4:0] wrn;                         // regfile2w write # for lwc1
    output  [2:0] fc;                          // fpu op
    output        mem_access;                  // main mem access
    output        mem_write;                   // main mem write enable
    output        wwfpr;                       // regfile2w we for lwc1
    output        fwdla;                       // forward lwc1 data to a
    output        fwdlb;                       // forward lwc1 data to b
    output        fwdfa;                       // forward fp data to b
    output        fwdfb;                       // forward fp data to b
    output        wf;                          // write fp regfile, id stage
    output        fasmds;                      // is fp calc, id stage
    output        stall_lw;                    // stall by lw
    output        stall_fp;                    // stall by fp data depend.
    output        stall_lwc1;                  // stall by lwc1
    output        stall_swc1;                  // stall by swc1
    output        no_cache_stall;              // no cache stall
    output        dtlb;                        // dtlb hit
    output        io;                          // inst rom or data i/o
    parameter     exc_base = 32'h80000008;     // int/exc handler entry
    wire   [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,qa,qb,da,db,dc,dd;
    wire   [31:0] simm,epc8,alua,alub,ealu0,ealu1,ealu,sa,eb;
    wire    [5:0] op,func;
    wire    [4:0] rs,rt,rd,fs,ft,fd,drn,ern;
    wire    [3:0] aluc;
    wire    [1:0] pcsrc,fwda,fwdb;
    wire          wpcir,wreg,m2reg,wmem,aluimm,shift,jal;
    wire    [4:0] e1n,e2n,e3n;
    reg           ewfpr,ewreg,em2reg,ewmem,ejal,efwdfe,ealuimm,eshift;
    reg           mwfpr,mwreg,mm2reg,mwmem;
    reg           wwfpr,wwreg,wm2reg;
    reg    [31:0] epc4,ea,ed,eimm,malu,mb,wmo,walu;
    reg     [4:0] ern0,mrn,wrn;
    reg     [3:0] ealuc;
    wire   [23:0] ipte_out;
    wire          itlb_hit;
    wire   [31:0] pcd;
    wire   [31:0] index;                       // cp0 reg 0: index
    wire   [31:0] entlo;                       // cp0 reg 2: entry lo
    reg    [31:0] contx;                       // cp0 reg 4: context
    wire   [31:0] enthi;                       // cp0 reg 9: entry hi
    wire          windex,wentlo,wcontx,wenthi; // write enables
    wire          rc0,wc0;                     // read,write c0 res
    wire    [1:0] c0rn;                        // c0 reg # for mux
    wire          swfp,regrt,sext,fwdf,fwdfe,wfpr;
    wire          i_ready,i_cache_miss;
    wire          tlbwi,tlbwr;
    wire          wepc,wcau,wsta,isbr,cancel,exce,ldst;
    wire    [1:0] sepc,selpc;
    wire   [31:0] sta,cau,epc,sta_in,cau_in,epc_in;
    wire   [31:0] stalr,epcin,cause,c0reg,next_pc;
    reg    [31:0] pce;
    reg     [1:0] ec0rn;
    reg           erc0,ecancel,eisbr,eldst;
    reg    [31:0] pcm;
    reg           misbr,mldst;
    wire   [23:0] dpte_out;
    wire          dtlb_hit;
    reg    [31:0] pcw;
    reg           wisbr;
    wire          m_fetch,m_ld_st,m_st;
    wire   [31:0] m_i_a,m_d_a;
    wire          itlb_exc, dtlb_exc;
    wire          itlb_exce,dtlb_exce;
    wire          m_i_ready;
    wire          m_d_ready;
    // IF stage
    vpc v_p_c (next_pc,clk,clrn,wpcir&no_cache_stall,v_pc);    // vpc
    cla32 pc_plus4 (v_pc,32'h4,1'b0,pc4);                      // vpc+4
    mux4x32 nextpc (pc4,bpc,da,jpc,pcsrc,npc);                 // next pc
    wire          itlbwi = tlbwi & ~index[30];                 // itlb write
    wire          itlbwr = tlbwr & ~index[30];
    wire          dtlbwi = tlbwi &  index[30];                 // dtlb write
    wire          dtlbwr = tlbwr &  index[30];
    wire   [19:0] ipattern = (itlbwi | itlbwr)? enthi[19:0] : v_pc[31:12];
    wire          pc_unmapped = v_pc[31]  &  ~v_pc[30];        // 10xx...xx
    wire          pc_uncached = pc_unmapped & v_pc[29];        // 101x...xx
    assign pc = pc_unmapped?{3'b0,v_pc[28:0]} : {ipte_out[19:0],v_pc[11:0]};
    tlb_8_entry itlb (entlo[23:0],itlbwi,itlbwr,index[2:0],ipattern, // itlb
                      clk,clrn,ipte_out,itlb_hit);
    assign        itlb_exc = ~itlb_hit & ~pc_unmapped;
    i_cache icache (pc,ins,1'b1,pc_uncached,i_ready,i_cache_miss,  // icache
                    clk,clrn,m_i_a,mem_data,m_fetch,m_i_ready);
    // IF/ID pipeline registers
    dffe32 pc_4_r (pc4, clk,clrn,wpcir&no_cache_stall,dpc4);       // pc4
    dffe32 inst_r (ins, clk,clrn,wpcir&no_cache_stall,inst);       // ir
    dffe32 pcd_r  (v_pc,clk,clrn,wpcir&no_cache_stall,pcd);        // pcd
    // ID stage
    assign op   = inst[31:26];
    assign rs   = inst[25:21];
    assign rt   = inst[20:16];
    assign rd   = inst[15:11];
    assign ft   = inst[20:16];
    assign fs   = inst[15:11];
    assign fd   = inst[10:6];
    assign func = inst[5:0];
    assign simm = {{16{sext&inst[15]}},inst[15:0]};
    assign jpc  = {dpc4[31:28],inst[25:0],2'b00};       // jump target
    cla32 br_addr (dpc4,{simm[29:0],2'b00},1'b0,bpc);   // branch target
    regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb);   // reg file
    mux4x32 alu_a(qa,ealu,malu,mmo,fwda,da);            // forward A
    mux4x32 alu_b(qb,ealu,malu,mmo,fwdb,db);            // forward B
    mux2x32 store_f (db,dfb,swfp,dc);                   // swc1
    mux2x32 fwd_f_d (dc,e3d,fwdf,dd);                   // forward fp result
    wire rsrtequ = ~|(da^db);                           // (da == db)
    mux2x5 des_reg_no (rd,rt,regrt,drn);                // destination reg
    iu_cache_tlb_cu cu (op,func,rs,rt,rd,fs,ft,rsrtequ, // control unit
                  ewfpr,ewreg,em2reg,ern,mwfpr,mwreg,mm2reg,mrn,e1w,e1n,e2w,
                  e2n,e3w,e3n,stall,st,pcsrc,wpcir,wreg,m2reg,wmem,jal,aluc,
                  sta,aluimm,shift,sext,regrt,fwda,fwdb,swfp,fwdf,fwdfe,
                  wfpr,fwdla,fwdlb,fwdfa,fwdfb,fc,wf,fasmds,stall_lw,
                  stall_fp,stall_lwc1,stall_swc1,windex,wentlo,wcontx,
                  wenthi,rc0,wc0,tlbwi,tlbwr,c0rn,wepc,wcau,wsta,isbr,sepc,
                  cancel,cause,exce,selpc,ldst,wisbr,ecancel,itlb_exc,
                  dtlb_exc,itlb_exce,dtlb_exce);
    assign dtlb = ~dtlb_exce;                                    // dtlb hit
    dffe32 c0_Index (db,clk,clrn,windex&no_cache_stall,index);   // index
    dffe32 c0_Entlo (db,clk,clrn,wentlo&no_cache_stall,entlo);   // entlo
    dffe32 c0_Enthi (db,clk,clrn,wenthi&no_cache_stall,enthi);   // enthi
    always @(negedge clrn or posedge clk)                        // contx
      if (!clrn) begin
          contx <= 0;
      end else begin
          if      (wcontx)   contx[31:22] <= db[31:22];           // PTEBase
          if      (itlb_exce) contx[21:0] <= {v_pc[31:12],2'b00}; // BadVPN
          else if (dtlb_exce) contx[21:0] <= {malu[31:12],2'b00};
      end
    dffe32  c0_status (sta_in,clk,clrn,wsta&no_cache_stall,sta);  // sta
    dffe32  c0_cause  (cau_in,clk,clrn,wcau&no_cache_stall,cau);  // cau
    dffe32  c0_epc    (epc_in,clk,clrn,wepc&no_cache_stall,epc);  // epc
    mux2x32 sta_mx (stalr,db,wc0,sta_in);              // mux for status reg
    mux2x32 cau_mx (cause,db,wc0,cau_in);              // mux for cause reg
    mux2x32 epc_mx (epcin,db,wc0,epc_in);              // mux for epc reg
    mux2x32 sta_lr ({8'h0,sta[31:8]},{sta[23:0],8'h0},exce,stalr);
    mux4x32 epc_04 (v_pc,pcd,pcm,pcw,sepc,epcin);          // epc source
    mux4x32 irq_pc (npc,epc,exc_base,32'h0,selpc,next_pc); // for pc
    mux4x32 fromc0 (contx,sta,cau,epc,ec0rn,c0reg);        // for mfc0
    // ID/EXE pipeline registers
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            ewfpr   <= 0;          ewreg   <= 0;
            eldst   <= 0;          ewmem   <= 0;
            ejal    <= 0;          ealuimm <= 0;
            efwdfe  <= 0;          ealuc   <= 0;
            eshift  <= 0;          epc4    <= 0;
            ea      <= 0;          ed      <= 0;
            eimm    <= 0;          ern0    <= 0;
            erc0    <= 0;          ec0rn   <= 0;
            ecancel <= 0;          eisbr   <= 0;
            pce     <= 0;          em2reg  <= 0;
        end else if (no_cache_stall) begin
            ewfpr   <= wfpr;       ewreg   <= wreg;
            ewmem   <= wmem;       eldst   <= ldst;
            ejal    <= jal;        ealuimm <= aluimm;
            efwdfe  <= fwdfe;      ealuc   <= aluc;
            eshift  <= shift;      epc4    <= dpc4;
            ea      <= da;         ed      <= dd;
            eimm    <= simm;       ern0    <= drn;
            erc0    <= rc0;        ec0rn   <= c0rn;
            ecancel <= cancel;     eisbr   <= isbr;
            pce     <= pcd;        em2reg  <= m2reg;
        end
    end
    // EXE stage
    cla32 ret_addr (epc4,32'h4,1'b0,epc8);             // pc+8
    assign  sa = {eimm[5:0],eimm[31:6]};               // shift amount
    mux2x32 alu_ina (ea,sa,eshift,alua);               // alu input A
    mux2x32 alu_inb (eb,eimm,ealuimm,alub);            // alu input B
    mux2x32 save_pc8 (ealu0,epc8,ejal,ealu1);          // pc+8 if jal
    mux2x32 read_cr0 (ealu1,c0reg,erc0,ealu);          // read c0 regs
    wire z;
    alu al_unit (alua,alub,ealuc,ealu0,z);             // alu
    assign        ern = ern0 | {5{ejal}};              // $31 for jal
    mux2x32 fwd_f_e (ed,e3d,efwdfe,eb);                // forward fp result
    // EXE/MEM pipeline registers
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            mwfpr   <= 0;          mwreg  <= 0;
            mldst   <= 0;          mwmem  <= 0;
            malu    <= 0;          mb     <= 0;
            mrn     <= 0;          misbr  <= 0;
            pcm     <= 0;          mm2reg <= 0;
        end else if (no_cache_stall) begin
            mwfpr   <= ewfpr & ~dtlb_exce;             // cancel exe
            mwreg   <= ewreg & ~dtlb_exce;             // cancel exe
            mwmem   <= ewmem & ~dtlb_exce;             // cancel exe
            mldst   <= eldst & ~dtlb_exce;             // cancel exe
            malu    <= ealu;       mb     <= eb;
            mrn     <= ern;        misbr  <= eisbr;
            pcm     <= pce;        mm2reg <= em2reg;
        end
    end
    // MEM stage
    wire   [19:0] dpattern = (dtlbwi | dtlbwr) ? enthi[19:0] : malu[31:12];
    wire          ma_unmapped = malu[31]  &  ~malu[30]; // 10xx...xx
    wire          ma_uncached = ma_unmapped & malu[29]; // 101x...xx
    wire   [31:0] m_addr = ma_unmapped? {3'b0,malu[28:0]} :
                                        {dpte_out[19:0],malu[11:0]};
    tlb_8_entry d_tlb (entlo[23:0],dtlbwi,dtlbwr,index[2:0],       // dtlb
                       dpattern,clk,clrn,dpte_out,dtlb_hit);
    assign        dtlb_exc = ~dtlb_hit & ~ma_unmapped & mldst;
    wire          d_ready;
    wire          w_mem = mwmem & ~dtlb_exce;        // cancel mem (sw/swc1)
    d_cache dcache (m_addr,mb,mmo,mldst,w_mem,ma_uncached,d_ready, // dcache
                    clk,clrn,m_d_a,mem_data,mem_st_data,m_ld_st,
                    m_st,m_d_ready);
    assign        io = pc_uncached | ma_uncached;    // 101x...xx
    // MEM/WB pipeline registers
    always @(negedge clrn or posedge clk) begin
        if (!clrn) begin
            wwfpr   <= 0;          wwreg <= 0;
            wm2reg  <= 0;          wmo   <= 0;
            walu    <= 0;          wrn   <= 0;
            pcw     <= 0;          wisbr <= 0;
        end else if (no_cache_stall) begin
            wwfpr   <= mwfpr & ~dtlb_exce;             // cancel mem
            wwreg   <= mwreg & ~dtlb_exce;             // cancel mem
            wm2reg  <= mm2reg;     wmo   <= mmo;
            walu    <= malu;       wrn   <= mrn;
            pcw     <= pcm;        wisbr <= misbr;
        end
    end
    // WB stage
    mux2x32 wb_sel (walu,wmo,wm2reg,wdi);
    // mux, i_cache has higher priority than d_cache
    wire        sel_i = i_cache_miss;                  // fetch inst first
    assign      mem_a = sel_i ? m_i_a   : m_d_a;       // mem address
    assign mem_access = sel_i ? m_fetch : m_ld_st;     // mem access
    assign mem_write  = sel_i ? 1'b0    : m_st;        // mem write enable
    // demux the main mem ready
    assign m_i_ready  = mem_ready &  sel_i;            // ready for inst
    assign m_d_ready  = mem_ready & ~sel_i;            // ready for mem data
    assign no_cache_stall = ~(~i_ready & ~itlb_exce |  // no itlb miss exce
                      mldst & ~d_ready & ~dtlb_exce);  // no dtlb miss exce
endmodule
