/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module iu_cache_tlb_cu (op,func,rs,rt,rd,fs,ft,rsrtequ,ewfpr,ewreg,em2reg,
                  ern,mwfpr,mwreg,mm2reg,mrn,e1w,e1n,e2w,e2n,e3w,e3n,
                  stall_div_sqrt,st,pcsrc,wpcir,wreg,m2reg,wmem,jal,aluc,
                  sta,aluimm,shift,sext,regrt,fwda,fwdb,swfp,fwdf,fwdfe,
                  wfpr,fwdla,fwdlb,fwdfa,fwdfb,fc,wf,fasmds,stall_lw,
                  stall_fp,stall_lwc1,stall_swc1,windex,wentlo,wcontx,
                  wenthi,rc0,wc0,tlbwi,tlbwr,c0rn,wepc,wcau,wsta,isbr,sepc,
                  cancel,cause,exce,selpc,ldst,wisbr,ecancel,itlb_exc,
                  dtlb_exc,itlb_exce,dtlb_exce);             // control unit
    input         rsrtequ, ewreg,em2reg,ewfpr, mwreg,mm2reg,mwfpr;
    input         e1w,e2w,e3w,stall_div_sqrt,st;
    input   [5:0] op,func;
    input   [4:0] rs,rt,rd,fs,ft,ern,mrn,e1n,e2n,e3n;
    input  [31:0] sta;  // IM[7:0] : x,x,dtlb_exc,itlb_exc,ov,unimpl,sys,int
    output        wpcir,wreg,m2reg,wmem,jal,aluimm,shift,sext,regrt;
    output        swfp,fwdf,fwdfe;
    output        fwdla,fwdlb,fwdfa,fwdfb;
    output        wfpr,wf,fasmds;
    output  [1:0] pcsrc,fwda,fwdb;
    output  [3:0] aluc;
    output  [2:0] fc;                // fp op
    output        stall_lw,stall_fp,stall_lwc1,stall_swc1; // stalls
    output        rc0;               // read  c0 regs, mfc0
    output        wc0;               // write c0 regs, mtc0
    output        tlbwi;             // write tlb by index
    output        tlbwr;             // write tlb by random
    output  [1:0] c0rn,sepc,selpc;   // mux select signals
    output        windex;            // cp0 index   write enable
    output        wentlo;            // cp0 entrylo write enable
    output        wcontx;            // cp0 context write enable
    output        wenthi;            // cp0 entryhi write enable
    output        wepc;              // cp0 epc     write enable
    output        wcau;              // cp0 cause   write enable
    output        wsta;              // cp0 status  write enable
    output        isbr;              // inst in id stage is a jump or branch
    output        cancel;            // cancel in id stage
    output        exce;              // itlb_exce | dtlb_exce, masked
    output        ldst;              // inst in id stage is a load or store
    output [31:0] cause;             // cp0 cause reg
    input         wisbr;             // inst in wb stage is a jump or branch
    input         ecancel;           // cancel in exe stage
    input         itlb_exc;          // itlb miss exception
    input         dtlb_exc;          // dtlb miss exception
    output        itlb_exce;         // itlb miss exception & its enable
    output        dtlb_exce;         // dtlb miss exception & its enable
    wire          stall_others;
    wire          rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;
    wire          i_addi,i_andi,i_ori,i_xori,i_beq,i_bne,i_lw,i_sw,i_j;
    wire          i_jal,i_eret,i_mtc0,i_mfc0;
    wire          ftype,i_lwc1,i_swc1,i_fadd,i_fsub,i_fmul,i_fdiv,i_fsqrt;
    assign        itlb_exce = itlb_exc & sta[4];             // & exc enable
    assign        dtlb_exce = dtlb_exc & sta[5];             // & exc enable
    wire          no_dtlb_exce = ~dtlb_exce;
    assign ldst = (i_lw | i_sw | i_lwc1 | i_swc1) & ~ecancel & no_dtlb_exce;
    assign isbr = i_beq | i_bne | i_j | i_jal;
    // itlb_exce dtlb_exce isbr wisbr EPC   sepc[1:0]
    // 1         x         0    x     V_PC  0 0
    // 1         x         1    x     PCD   0 1
    // 0         1         x    0     PCM   1 0
    // 0         1         x    1     PCW   1 1
    assign sepc[1]= ~itlb_exce & dtlb_exce;
    assign sepc[0]=  itlb_exce & isbr | ~itlb_exce & dtlb_exce & wisbr;
    assign exce   =  itlb_exce | dtlb_exce;
    assign cancel =  exce;
    // selpc:  0 0 : npc
    //         0 1 : epc
    //         1 0 : exc_base
    //         1 1 : x
    assign selpc[1] = exce;                                // go to handler
    assign selpc[0] = i_eret;                              // epc return
    // op     rs    rt    rd          func
    // 010000 00100 xxxxx xxxxx 00000 000000 mtc0 rt, rd; c0[rd] <- gpr[rt]
    // 010000 00000 xxxxx xxxxx 00000 000000 mfc0 rt, rd; gpr[rt] <- c0[rd]
    // 010000 10000 00000 00000 00000 000010 tlbwi
    // 010000 10000 00000 00000 00000 000110 tlbwr
    // 010000 10000 00000 00000 00000 011000 eret
    assign i_mtc0 = (op==6'h10) & (rs==5'h04) & (func==6'h00)& no_dtlb_exce;
    assign i_mfc0 = (op==6'h10) & (rs==5'h00) & (func==6'h00);
    assign i_eret = (op==6'h10) & (rs==5'h10) & (func==6'h18);
    assign tlbwi  = (op==6'h10) & (rs==5'h10) & (func==6'h02);
    assign tlbwr  = (op==6'h10) & (rs==5'h10) & (func==6'h06);
    assign windex = i_mtc0 & (rd==5'h00);                  // write index
    assign wentlo = i_mtc0 & (rd==5'h02);                  // write entry_lo
    assign wcontx = i_mtc0 & (rd==5'h04);                  // write context
    assign wenthi = i_mtc0 & (rd==5'h09);                  // write entry_hi
    assign wsta   = i_mtc0 & (rd==5'h0c) | exce | i_eret;  // write status
    assign wcau   = i_mtc0 & (rd==5'h0d) | exce;           // write cause
    assign wepc   = i_mtc0 & (rd==5'h0e) | exce;           // write epc
    //wire rcontx = i_mfc0 & (rd==5'h04);                  // read  context
    wire rstatus  = i_mfc0 & (rd==5'h0c);                  // read  status
    wire rcause   = i_mfc0 & (rd==5'h0d);                  // read  cause
    wire repc     = i_mfc0 & (rd==5'h0e);                  // read  epc
    assign c0rn[1]= rcause  | repc;            // c0rn:  00    01   10   11
    assign c0rn[0]= rstatus | repc;            //        contx sta  cau  epc
    assign rc0    = i_mfc0;                    // read  c0 regs
    assign wc0    = i_mtc0;                    // write c0 regs
    wire [2:0] exccode;                        // test itlb_exc and dtlb_exc
    //    000  interrupt                       // not  test here
    //    001  syscall                         // not  test here
    //    010  unimpl. inst.                   // not  test here
    //    011  overflow                        // not  test here
    //    100  itlb_exc                        // test here
    //    101  dtlb_exc                        // test here
    assign exccode[2] = itlb_exc | dtlb_exc; 
    assign exccode[1] = 0;                
    assign exccode[0] = dtlb_exc;            
    assign cause      = {27'h0,exccode,2'b00};
    and(rtype,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);        // r format
    and(i_add,rtype, func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and(i_sub,rtype, func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and(i_and,rtype, func[5],~func[4],~func[3], func[2],~func[1],~func[0]);
    and(i_or, rtype, func[5],~func[4],~func[3], func[2],~func[1], func[0]);
    and(i_xor,rtype, func[5],~func[4],~func[3], func[2], func[1],~func[0]);
    and(i_sll,rtype,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and(i_srl,rtype,~func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and(i_sra,rtype,~func[5],~func[4],~func[3],~func[2], func[1], func[0]);
    and(i_jr, rtype,~func[5],~func[4], func[3],~func[2],~func[1],~func[0]);
    and(i_addi,~op[5],~op[4], op[3],~op[2],~op[1],~op[0]);       // i format
    and(i_andi,~op[5],~op[4], op[3], op[2],~op[1],~op[0]);
    and(i_ori, ~op[5],~op[4], op[3], op[2],~op[1], op[0]);
    and(i_xori,~op[5],~op[4], op[3], op[2], op[1],~op[0]);
    and(i_lw,   op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    and(i_sw,   op[5],~op[4], op[3],~op[2], op[1], op[0]);
    and(i_beq, ~op[5],~op[4],~op[3], op[2],~op[1],~op[0]);
    and(i_bne, ~op[5],~op[4],~op[3], op[2],~op[1], op[0]);
    and(i_lui, ~op[5],~op[4], op[3], op[2], op[1], op[0]);
    and(i_j,   ~op[5],~op[4],~op[3],~op[2], op[1],~op[0]);       // j format
    and(i_jal, ~op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    and(ftype, ~op[5], op[4],~op[3],~op[2],~op[1], op[0]);       // f format
    and(i_lwc1, op[5], op[4],~op[3],~op[2],~op[1], op[0]);
    and(i_swc1, op[5], op[4], op[3],~op[2],~op[1], op[0]);
    and(i_fadd,ftype,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and(i_fsub,ftype,~func[5],~func[4],~func[3],~func[2],~func[1], func[0]);
    and(i_fmul,ftype,~func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and(i_fdiv,ftype,~func[5],~func[4],~func[3],~func[2], func[1], func[0]);
    and(i_fsqrt,ftype,~func[5],~func[4],~func[3],func[2],~func[1],~func[0]);
    wire i_rs = i_add  | i_sub | i_and  | i_or  | i_xor | i_jr  | i_addi |
                i_andi | i_ori | i_xori | i_lw  | i_sw  | i_beq | i_bne  |
                i_lwc1 | i_swc1;
    wire i_rt = i_add  | i_sub | i_and  | i_or  | i_xor | i_sll | i_srl  |
                i_sra  | i_sw  | i_beq  | i_bne | i_mtc0;
    assign stall_lw = ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) |
                                                     i_rt & (ern == rt));
    reg [1:0] fwda, fwdb;
    always @ (ewreg or mwreg or ern or mrn or em2reg or mm2reg or rs or
              rt) begin
        fwda = 2'b00;                                 // default: no hazards
        if (ewreg & (ern != 0) & (ern == rs) & ~em2reg) begin
            fwda = 2'b01;                             // select exe_alu
        end else begin
            if (mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg) begin
                fwda = 2'b10;                         // select mem_alu
            end else begin
                if (mwreg & (mrn != 0) & (mrn == rs) & mm2reg) begin
                    fwda = 2'b11;                     // select mem_lw
                end 
            end
        end
        fwdb = 2'b00;                                 // default: no hazards
        if (ewreg & (ern != 0) & (ern == rt) & ~em2reg) begin
            fwdb = 2'b01;                             // select exe_alu
        end else begin
            if (mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg) begin
                fwdb = 2'b10;                         // select mem_alu
            end else begin
                if (mwreg & (mrn != 0) & (mrn == rt) & mm2reg) begin
                    fwdb = 2'b11;                     // select mem_lw
                end 
            end
        end
    end
    assign wreg   =(i_add  | i_sub  | i_and  | i_or   | i_xor | i_sll  | 
                    i_srl  | i_sra  | i_addi | i_andi | i_ori | i_xori | 
                    i_lw   | i_lui  | i_jal  | i_mfc0) &
                    wpcir  & ~ecancel & no_dtlb_exce;
    assign regrt  = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui |
                    i_lwc1 | i_mfc0;
    assign jal    = i_jal;
    assign m2reg  = i_lw;
    assign shift  = i_sll  | i_srl  | i_sra;
    assign aluimm = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui |
                    i_sw | i_lwc1 | i_swc1;
    assign sext   = i_addi | i_lw | i_sw | i_beq | i_bne | i_lwc1 | i_swc1;
    assign aluc[3] = i_sra;
    assign aluc[2] = i_sub | i_or  | i_srl | i_sra | i_ori  | i_lui;
    assign aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq  | 
                     i_bne | i_lui;
    assign aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
    assign wmem    = (i_sw | i_swc1) & wpcir & ~ecancel & no_dtlb_exce;
    assign pcsrc[1] = i_jr | i_j | i_jal;
    assign pcsrc[0] = i_beq & rsrtequ | i_bne & ~rsrtequ | i_j | i_jal;
    // fop:  000: fadd  001: fsub  01x: fmul  10x: fdiv  11x: fsqrt
    wire [2:0]  fop;
    assign fop[0] = i_fsub;                    // fpu operation control code
    assign fop[1] = i_fmul | i_fsqrt;
    assign fop[2] = i_fdiv | i_fsqrt;
    // stall caused by fp data harzards
    wire i_fs     = i_fadd | i_fsub | i_fmul | i_fdiv | i_fsqrt; // use fs
    wire i_ft     = i_fadd | i_fsub | i_fmul | i_fdiv;           // use ft
    assign stall_fp = (e1w & (i_fs & (e1n == fs) | i_ft & (e1n == ft))) | 
                      (e2w & (i_fs & (e2n == fs) | i_ft & (e2n == ft)));
    assign fwdfa = e3w & (e3n == fs);             // forward fpu e3d to fp a
    assign fwdfb = e3w & (e3n == ft);             // forward fpu e3d to fp b
    assign wfpr  = i_lwc1 & wpcir & ~ecancel & no_dtlb_exce; // write fp reg
    assign fwdla = mwfpr & (mrn == fs);           // forward mmo to fp a
    assign fwdlb = mwfpr & (mrn == ft);           // forward mmo to fp b
    assign stall_lwc1 = ewfpr & (i_fs & (ern == fs) | i_ft & (ern == ft));
    assign swfp  = i_swc1;                        // select signal
    assign fwdf  = swfp & e3w & (ft == e3n);      // forward to id  stage
    assign fwdfe = swfp & e2w & (ft == e2n);      // forward to exe stage
    assign stall_swc1 = swfp & e1w & (ft == e1n); // stall
    assign wpcir = ~(stall_div_sqrt | stall_others);
    assign stall_others = stall_lw | stall_fp | stall_lwc1 | stall_swc1 |st;
    assign fc     = fop & {3{~stall_others}};     // fp operation control
    assign wf     = i_fs & wpcir & ~ecancel & no_dtlb_exce;  // write fp reg
    assign fasmds = i_fs;
endmodule
