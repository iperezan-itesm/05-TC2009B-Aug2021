/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cu_exc_int (mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,op,rs,rt,
                   rd,op1,wreg,m2reg,wmem,aluc,regrt,aluimm,fwda,fwdb,wpcir,
                   sext,pcsrc,shift,jal,irq,sta,ecancel,eis_branch,
                   mis_branch,inta,selpc,exc,sepc,cause,mtc0,wepc,wcau,wsta,
                   mfc0,is_branch,ove,cancel,exc_ovr,mexc_ovr); // ctrl unit
    input  [31:0] sta;                // status: IM[3:0]: ov,unimpl,sys,int 
    input   [5:0] op,func;
    input   [4:0] mrn,ern,rs,rt,rd;
    input   [4:0] op1;                // for decode mfc0, mtc0, and eret
    input         mwreg,ewreg,em2reg,mm2reg,rsrtequ;
    input         irq;                // interrupt request
    input         ecancel;            // cancel in EXE stage
    input         eis_branch;         // is_branch in EXE stage
    input         mis_branch;         // is_branch in MEM stage
    input         exc_ovr;            // overflow exception occurs
    input         mexc_ovr;           // exc_ovr in MEM stage
    output [31:0] cause;              // cause content
    output  [3:0] aluc;
    output  [1:0] pcsrc,fwda,fwdb;
    output  [1:0] selpc;              // 00: npc;  01: epc; 10: exc_base
    output  [1:0] mfc0;               // 00: epc8; 01: sta; 10: cau; 11: epc
    output  [1:0] sepc;               // 00: pc;   01: pcd; 10: pce; 11: pcm
    output        wpcir,wreg,m2reg,wmem,regrt,aluimm,sext,shift,jal;
    output        inta;               // interrupt acknowledgement
    output        exc;                // any int or exc happened
    output        mtc0;               // is mtc0 instruction
    output        wsta;               // status register write enable
    output        wcau;               // cause  register write enable
    output        wepc;               // epc    register write enable
    output        is_branch;          // is a branch or a jump
    output        ove;                // ov enable = arith & sta[3]
    output        cancel;             // exception cancels next instruction
    reg     [1:0] fwda,fwdb;
    wire    [1:0] exccode;            // exccode
    wire          rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra;
    wire          i_jr,i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne;
    wire          i_lui,i_j,i_jal,i_rs,i_rt;
    wire          exc_int;            // exception of interrupt
    wire          exc_sys;            // exception of system call
    wire          exc_uni;            // exception of unimplemented inst
    wire          c0_type;            // cp0 instructions
    wire          i_syscall;          // is syscall instruction
    wire          i_mfc0;             // is mfc0 instruction
    wire          i_mtc0;             // is mtc0 instruction
    wire          i_eret;             // is eret instruction
    wire          unimplemented_inst; // is an unimplemented inst
    wire          rd_is_status;       // rd is status
    wire          rd_is_cause;        // rd is cause
    wire          rd_is_epc;          // rd is epc
    wire   arith     = i_add | i_sub | i_addi;             // for overflow
    assign is_branch = i_beq | i_bne | i_jr | i_j | i_jal; // has delay slot
    assign exc_int   = sta[0] & irq;                    // 0. exc_int
    assign exc_sys   = sta[1] & i_syscall;              // 1. exc_sys
    assign exc_uni   = sta[2] & unimplemented_inst;     // 2. exc_uni
    assign ove       = sta[3] & arith;                  // 3. exc_ovr enable
    assign inta      = exc_int;                         // ack immediately
    assign exc       = exc_int | exc_sys | exc_uni | exc_ovr; // all int_exc
    assign cancel    = exc | i_eret;   // always cancel next inst, eret also
    // sel epc:    id is_branch   eis_branch    mis_branch     others
    // exc_int     PCD (01)       PC  (00)      PC  (00)       PC  (00)
    // exc_sys     x              x             PCD (01)       PCD (01)
    // exc_uni     x              x             PCD (01)       PCD (01)
    // exc_ovr     x              x             PCM (11)       PCE (10)
    assign sepc[0] = exc_int &  is_branch | exc_sys | exc_uni |
                     exc_ovr & mis_branch;
    assign sepc[1] = exc_ovr;
    // exccode:  0 0 : irq
    //           0 1 : i_syscall
    //           1 0 : unimplemented_inst
    //           1 1 : exc_ovr
    assign exccode[0]   = i_syscall          | exc_ovr;
    assign exccode[1]   = unimplemented_inst | exc_ovr;
    assign cause        = {eis_branch,27'h0,exccode,2'b00}; // BD
    assign mtc0         = i_mtc0;
    assign wsta         = exc | mtc0 & rd_is_status | i_eret;
    assign wcau         = exc | mtc0 & rd_is_cause;
    assign wepc         = exc | mtc0 & rd_is_epc;
    assign rd_is_status = (rd == 5'd12);              // cp0 status register
    assign rd_is_cause  = (rd == 5'd13);              // cp0 cause register
    assign rd_is_epc    = (rd == 5'd14);              // cp0 epc register
    // mfc0:     0 0 : epc8
    //           0 1 : sta
    //           1 0 : cau
    //           1 1 : epc
    assign mfc0[0] = i_mfc0 & rd_is_status | i_mfc0 & rd_is_epc;
    assign mfc0[1] = i_mfc0 & rd_is_cause  | i_mfc0 & rd_is_epc;
    // selpc:    0 0 : npc
    //           0 1 : epc
    //           1 0 : exc_base
    //           1 1 : x
    assign selpc[0] = i_eret;
    assign selpc[1] = exc;
    assign c0_type  = ~op[5]  & op[4]  & ~op[3] & ~op[2] & ~op[1] & ~op[0];
    assign i_mfc0   = c0_type &~op1[4] &~op1[3] &~op1[2] &~op1[1] &~op1[0];
    assign i_mtc0   = c0_type &~op1[4] &~op1[3] & op1[2] &~op1[1] &~op1[0];
    assign i_eret   = c0_type & op1[4] &~op1[3] &~op1[2] &~op1[1] &~op1[0] &
                 ~func[5] & func[4] & func[3] &~func[2] &~func[1] &~func[0];
    assign i_syscall = rtype  & ~func[5] & ~func[4] & func[3] & func[2] &
                      ~func[1] & ~func[0];
    assign unimplemented_inst = ~(i_mfc0 | i_mtc0 | i_eret | i_syscall |
           i_add | i_sub  | i_and  | i_or | i_xor | i_sll | i_srl | i_sra |
           i_jr  | i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_beq |
           i_bne | i_lui  | i_j    | i_jal); // except for implemented insts
    and (rtype,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);       // r format
    and (i_add,rtype, func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and (i_sub,rtype, func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and (i_and,rtype, func[5],~func[4],~func[3], func[2],~func[1],~func[0]);
    and (i_or, rtype, func[5],~func[4],~func[3], func[2],~func[1], func[0]);
    and (i_xor,rtype, func[5],~func[4],~func[3], func[2], func[1],~func[0]);
    and (i_sll,rtype,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and (i_srl,rtype,~func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and (i_sra,rtype,~func[5],~func[4],~func[3],~func[2], func[1], func[0]);
    and (i_jr, rtype,~func[5],~func[4], func[3],~func[2],~func[1],~func[0]);
    and (i_addi,~op[5],~op[4], op[3],~op[2],~op[1],~op[0]);      // i format
    and (i_andi,~op[5],~op[4], op[3], op[2],~op[1],~op[0]);
    and (i_ori, ~op[5],~op[4], op[3], op[2],~op[1], op[0]);
    and (i_xori,~op[5],~op[4], op[3], op[2], op[1],~op[0]);
    and (i_lw,   op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    and (i_sw,   op[5],~op[4], op[3],~op[2], op[1], op[0]);
    and (i_beq, ~op[5],~op[4],~op[3], op[2],~op[1],~op[0]);
    and (i_bne, ~op[5],~op[4],~op[3], op[2],~op[1], op[0]);
    and (i_lui, ~op[5],~op[4], op[3], op[2], op[1], op[0]);
    and (i_j,   ~op[5],~op[4],~op[3],~op[2], op[1],~op[0]);      // i format
    and (i_jal, ~op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    assign i_rs = i_add  | i_sub | i_and  | i_or  | i_xor | i_jr  | i_addi |
                  i_andi | i_ori | i_xori | i_lw  | i_sw  | i_beq | i_bne;
    assign i_rt = i_add  | i_sub | i_and  | i_or  | i_xor | i_sll | i_srl  |
                  i_sra  | i_sw  | i_beq  | i_bne | i_mtc0;    // mtc0 added
    assign wpcir = ~(ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) |
                                                    i_rt & (ern == rt)));
    always @ (ewreg or mwreg or ern or mrn or em2reg or mm2reg or rs or rt)
        begin
            fwda = 2'b00;                             // default: no hazards
            if (ewreg & (ern != 0) & (ern == rs) & ~em2reg) begin
                fwda = 2'b01;                         // select exe_alu
            end else begin
                if (mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg) begin
                    fwda = 2'b10;                     // select mem_alu
                end else begin
                    if (mwreg & (mrn != 0) & (mrn == rs) & mm2reg) begin
                        fwda = 2'b11;                 // select mem_lw
                    end 
                end
            end
            fwdb = 2'b00;                             // default: no hazards
            if (ewreg & (ern != 0) & (ern == rt) & ~em2reg) begin
                fwdb = 2'b01;                         // select exe_alu
            end else begin
                if (mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg) begin
                    fwdb = 2'b10;                     // select mem_alu
                end else begin
                    if (mwreg & (mrn != 0) & (mrn == rt) & mm2reg) begin
                        fwdb = 2'b11;                 // select mem_lw
                    end 
                end
            end
        end
    assign wmem     = i_sw & wpcir & ~ecancel & ~exc_ovr & ~mexc_ovr;
    assign regrt    = i_addi|i_andi|i_ori |i_xori|i_lw |i_lui |i_mfc0;
    assign jal      = i_jal;
    assign m2reg    = i_lw;
    assign shift    = i_sll |i_srl |i_sra;
    assign aluimm   = i_addi|i_andi|i_ori |i_xori|i_lw |i_lui |i_sw;
    assign sext     = i_addi|i_lw  |i_sw  |i_beq |i_bne;
    assign aluc[3]  = i_sra;
    assign aluc[2]  = i_sub |i_or  |i_srl |i_sra |i_ori |i_lui;
    assign aluc[1]  = i_xor |i_sll |i_srl |i_sra |i_xori|i_beq |i_bne|i_lui;
    assign aluc[0]  = i_and |i_or  |i_sll |i_srl |i_sra |i_andi|i_ori;
    assign pcsrc[1] = i_jr  |i_j   |i_jal;
    assign pcsrc[0] = i_beq & rsrtequ |i_bne & ~rsrtequ | i_j | i_jal;
    assign wreg     =(i_add |i_sub |i_and |i_or  |i_xor|i_sll  |
                      i_srl |i_sra |i_addi|i_andi|i_ori|i_xori |
                      i_lw  |i_lui |i_jal |i_mfc0) &  // mfc0 added
                      wpcir & ~ecancel & ~exc_ovr & ~mexc_ovr;
endmodule
