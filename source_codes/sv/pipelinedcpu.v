/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipelinedcpu (clk,clrn,pc,inst,ealu,malu,wdi);       // pipelined cpu
    input         clk, clrn;    // clock and reset          // plus inst mem
    output [31:0] pc;           // program counter          // and  data mem
    output [31:0] inst;         // instruction in ID stage
    output [31:0] ealu;         // alu result in EXE stage
    output [31:0] malu;         // alu result in MEM stage
    output [31:0] wdi;          // data to be written into register file
    // signals in IF stage
    wire   [31:0] pc4;          // pc+4 in IF stage
    wire   [31:0] ins;          // instruction in IF stage
    wire   [31:0] npc;          // next pc in IF stage
    // signals in ID stage
    wire   [31:0] dpc4;         // pc+4 in ID stage
    wire   [31:0] bpc;          // branch target of beq and bne instructions
    wire   [31:0] jpc;          // jump target of jr instruction
    wire   [31:0] da,db;        // two operands a and b in ID stage
    wire   [31:0] dimm;         // 32-bit extended immediate in ID stage
    wire    [4:0] drn;          // destination register number in ID stage
    wire    [3:0] daluc;        // alu control in ID stage
    wire    [1:0] pcsrc;        // next pc (npc) select in ID stage
    wire          wpcir;        // pipepc and pipeir write enable
    wire          dwreg;        // register file write enable in ID stage
    wire          dm2reg;       // memory to register in ID stage
    wire          dwmem;        // memory write in ID stage
    wire          daluimm;      // alu input b is an immediate in ID stage
    wire          dshift;       // shift in ID stage
    wire          djal;         // jal in ID stage
    // signals in EXE stage
    wire   [31:0] epc4;         // pc+4 in EXE stage
    wire   [31:0] ea,eb;        // two operands a and b in EXE stage
    wire   [31:0] eimm;         // 32-bit extended immediate in EXE stage
    wire    [4:0] ern0;         // temporary register number in WB stage
    wire    [4:0] ern;          // destination register number in EXE stage
    wire    [3:0] ealuc;        // alu control in EXE stage
    wire          ewreg;        // register file write enable in EXE stage
    wire          em2reg;       // memory to register in EXE stage
    wire          ewmem;        // memory write in EXE stage
    wire          ealuimm;      // alu input b is an immediate in EXE stage
    wire          eshift;       // shift in EXE stage
    wire          ejal;         // jal in EXE stage
    // signals in MEM stage
    wire   [31:0] mb;           // operand b in MEM stage
    wire   [31:0] mmo;          // memory data out in MEM stage
    wire    [4:0] mrn;          // destination register number in MEM stage
    wire          mwreg;        // register file write enable in MEM stage
    wire          mm2reg;       // memory to register in MEM stage
    wire          mwmem;        // memory write in MEM stage
    // signals in WB stage
    wire   [31:0] wmo;          // memory data out in WB stage
    wire   [31:0] walu;         // alu result in WB stage
    wire    [4:0] wrn;          // destination register number in WB stage
    wire          wwreg;        // register file write enable in WB stage
    wire          wm2reg;       // memory to register in WB stage
    // program counter
    pipepc   prog_cnt (npc,wpcir,clk,clrn,pc);
    pipeif   if_stage (pcsrc,pc,bpc,da,jpc,npc,pc4,ins);        // IF stage
    // IF/ID pipeline register
    pipeir     fd_reg (pc4,ins,wpcir,clk,clrn,dpc4,inst);
    pipeid   id_stage (mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,wrn,wdi,
                       ealu,malu,mmo,wwreg,clk,clrn,bpc,jpc,pcsrc,wpcir,
                       dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,
                       dshift,djal);                            // ID stage
    // ID/EXE pipeline register
    pipedereg  de_reg (dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn, 
                       dshift,djal,dpc4,clk,clrn,ewreg,em2reg,ewmem,
                       ealuc,ealuimm,ea,eb,eimm,ern0,eshift,ejal,epc4);
    pipeexe exe_stage (ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,
                       ern,ealu);                               // EXE stage
    // EXE/MEM pipeline register
    pipeemreg  em_reg (ewreg,em2reg,ewmem,ealu,eb,ern,clk,clrn,mwreg,
                       mm2reg,mwmem,malu,mb,mrn);
    pipemem mem_stage (mwmem,malu,mb,clk,mmo);                  // MEM stage
    // MEM/WB pipeline register
    pipemwreg  mw_reg (mwreg,mm2reg,mmo,malu,mrn,clk,clrn,wwreg,wm2reg,
                       wmo,walu,wrn);
    pipewb   wb_stage (walu,wmo,wm2reg,wdi);                    // WB stage
endmodule
