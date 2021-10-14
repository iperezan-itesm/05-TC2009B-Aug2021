/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipeidcu (mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,op,rs,rt,
                 wreg,m2reg,wmem,aluc,regrt,aluimm,fwda,fwdb,nostall,sext,
                 pcsrc,shift,jal); // control unit in ID stage
    input   [5:0] op,func;  // op and func fields in instruction
    input   [4:0] rs,rt;    // rs and rt fields in instruction
    input   [4:0] ern;      // destination register number in EXE stage
    input   [4:0] mrn;      // destination register number in MEM stage
    input         ewreg;    // register file write enable in EXE stage
    input         em2reg;   // memory to register in EXE stage
    input         mwreg;    // register file write enable in MEM stage
    input         mm2reg;   // memory to register in MEM stage
    input         rsrtequ;  // reg[rs] == reg[rt]
    output  [3:0] aluc;     // alu control
    output  [1:0] pcsrc;    // next pc (npc) select
    output  [1:0] fwda;     // forward a: 00:qa; 01:exe; 10:mem; 11:mem_mem
    output  [1:0] fwdb;     // forward b: 00:qb; 01:exe; 10:mem; 11:mem_mem
    output        wreg;     // register file write enable
    output        m2reg;    // memory to register
    output        wmem;     // memory write
    output        aluimm;   // alu input b is an immediate
    output        shift;    // instruction in ID stage is a shift
    output        jal;      // instruction in ID stage is jal
    output        regrt;    // destination register number is rt
    output        sext;     // sign extend
    output        nostall;  // no stall (pipepc and pipeir write enable)
    // instruction decode
    wire rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;
    wire i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
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
    and (i_j,   ~op[5],~op[4],~op[3],~op[2], op[1],~op[0]);      // j format
    and (i_jal, ~op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    // instructions that use rs
    wire i_rs = i_add  | i_sub | i_and  | i_or  | i_xor | i_jr  | i_addi |
                i_andi | i_ori | i_xori | i_lw  | i_sw  | i_beq | i_bne;
    // instructions that use rt
    wire i_rt = i_add  | i_sub | i_and  | i_or  | i_xor | i_sll | i_srl  |
                i_sra  | i_sw  | i_beq  | i_bne;
    // pipeline stall caused by data dependency with lw instruction
    assign nostall = ~(ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) |
                                                      i_rt & (ern == rt)));
    reg [1:0] fwda, fwdb;  // forwarding, multiplexer's select signals
    always @ (ewreg, mwreg, ern, mrn, em2reg, mm2reg, rs, rt) begin
        // forward control signal for alu input a
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
        // forward control signal for alu input b
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
    // control signals
    assign wreg     =(i_add |i_sub |i_and |i_or  |i_xor |i_sll |i_srl |
                      i_sra |i_addi|i_andi|i_ori |i_xori|i_lw  |i_lui |
                      i_jal)& nostall;       // prevent from executing twice
    assign regrt    = i_addi|i_andi|i_ori |i_xori|i_lw  |i_lui;
    assign jal      = i_jal;
    assign m2reg    = i_lw;
    assign shift    = i_sll |i_srl |i_sra;
    assign aluimm   = i_addi|i_andi|i_ori |i_xori|i_lw  |i_lui |i_sw;
    assign sext     = i_addi|i_lw  |i_sw  |i_beq |i_bne;
    assign aluc[3]  = i_sra;
    assign aluc[2]  = i_sub |i_or  |i_srl |i_sra |i_ori |i_lui;
    assign aluc[1]  = i_xor |i_sll |i_srl |i_sra |i_xori|i_beq |i_bne|i_lui;
    assign aluc[0]  = i_and |i_or  |i_sll |i_srl |i_sra |i_andi|i_ori;
    assign wmem     = i_sw  & nostall;       // prevent from executing twice
    assign pcsrc[1] = i_jr  |i_j   |i_jal;
    assign pcsrc[0] = i_beq & rsrtequ | i_bne & ~rsrtequ | i_j | i_jal;
endmodule
