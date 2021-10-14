/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
// control unit of pipelined cpu with memories and interface to fpu
module iu_control (op,func,rs,rt,fs,ft,rsrtequ,ewfpr,ewreg,em2reg,ern,mwfpr,
                   mwreg,mm2reg,mrn,e1w,e1n,e2w,e2n,e3w,e3n,stall_div_sqrt,
                   st,pcsrc,wpcir,wreg,m2reg,wmem,jal,aluc,aluimm,shift,
                   sext,regrt,fwda,fwdb,swfp,fwdf,fwdfe,wfpr,fwdla,fwdlb,
                   fwdfa,fwdfb,fc,wf,fasmds,stall_lw,stall_fp,stall_lwc1,
                   stall_swc1);
    input        rsrtequ, ewreg,em2reg,ewfpr, mwreg,mm2reg,mwfpr;
    input        e1w,e2w,e3w,stall_div_sqrt,st;
    input  [5:0] op,func;
    input  [4:0] rs,rt,fs,ft,ern,mrn,e1n,e2n,e3n;
    output       wpcir,wreg,m2reg,wmem,jal,aluimm,shift,sext,regrt;
    output       swfp,fwdf,fwdfe;
    output       fwdla,fwdlb,fwdfa,fwdfb;
    output       wfpr,wf,fasmds;
    output [3:0] aluc;
    output [2:0] fc;
    output [1:0] pcsrc,fwda,fwdb;
    output       stall_lw,stall_fp,stall_lwc1,stall_swc1;
    wire         rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra;
    wire         i_jr,i_j,i_jal;
    wire         i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui;
    wire         ftype,i_lwc1,i_swc1,i_fadd,i_fsub,i_fmul,i_fdiv,i_fsqrt;
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
    and(ftype,~op[5], op[4],~op[3],~op[2],~op[1], op[0]);        // f format
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
                i_sra  | i_sw  | i_beq  | i_bne;
    assign stall_lw = ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) |
                                                     i_rt & (ern == rt));
    reg    [1:0] fwda, fwdb;
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
    assign wreg  =(i_add  | i_sub  | i_and  | i_or   | i_xor | i_sll  | 
                   i_srl  | i_sra  | i_addi | i_andi | i_ori | i_xori | 
                   i_lw   | i_lui  | i_jal) & wpcir;
    assign regrt = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui | i_lwc1;
    assign jal   = i_jal;
    assign m2reg = i_lw;
    assign shift = i_sll  | i_srl  | i_sra;
    assign aluimm= i_addi | i_andi | i_ori | i_xori | i_lw | i_lui | i_sw |
                   i_lwc1 | i_swc1;
    assign sext  = i_addi | i_lw  | i_sw | i_beq | i_bne | i_lwc1 | i_swc1;
    assign aluc[3] = i_sra;
    assign aluc[2] = i_sub | i_or  | i_srl | i_sra | i_ori  | i_lui;
    assign aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq  | 
                     i_bne | i_lui;
    assign aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
    assign wmem    = (i_sw | i_swc1) & wpcir;
    assign pcsrc[1] = i_jr | i_j | i_jal;
    assign pcsrc[0] = i_beq & rsrtequ | i_bne & ~rsrtequ | i_j | i_jal;
    // fop:  000: fadd  001: fsub  01x: fmul  10x: fdiv  11x: fsqrt
    wire   [2:0] fop;
    assign fop[0]   = i_fsub;                     // fpu control code
    assign fop[1]   = i_fmul | i_fsqrt;
    assign fop[2]   = i_fdiv | i_fsqrt;
    // stall caused by fp data harzards
    wire       i_fs = i_fadd | i_fsub | i_fmul | i_fdiv | i_fsqrt; // use fs
    wire       i_ft = i_fadd | i_fsub | i_fmul | i_fdiv;           // use ft
    assign stall_fp = (e1w & (i_fs & (e1n == fs) | i_ft & (e1n == ft))) | 
                      (e2w & (i_fs & (e2n == fs) | i_ft & (e2n == ft)));
    assign fwdfa    = e3w & (e3n == fs);          // forward fpu e3d to fp a
    assign fwdfb    = e3w & (e3n == ft);          // forward fpu e3d to fp b
    assign wfpr     = i_lwc1 & wpcir;             // fp rf y write enable
    assign fwdla    = mwfpr & (mrn == fs);        // forward mmo to fp a
    assign fwdlb    = mwfpr & (mrn == ft);        // forward mmo to fp b
    assign stall_lwc1 = ewfpr & (i_fs & (ern == fs) | i_ft & (ern == ft));
    assign swfp       = i_swc1;                   // select signal
    assign fwdf       = swfp & e3w & (ft == e3n); // forward to id  stage
    assign fwdfe      = swfp & e2w & (ft == e2n); // forward to exe stage
    assign stall_swc1 = swfp & e1w & (ft == e1n); // stall
    wire stall_others = stall_lw | stall_fp | stall_lwc1 | stall_swc1 | st;
    assign wpcir      = ~(stall_div_sqrt | stall_others);
    assign fc         = fop & {3{~stall_others}};
    assign wf         = i_fs & wpcir;             // fp rf x write enable
    assign fasmds     = i_fs;
endmodule
