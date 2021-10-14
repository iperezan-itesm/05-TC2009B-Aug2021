/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mccu (op,func,z,clk,clrn,wpc,wir,wmem,wreg,iord,regrt,m2reg,aluc,
             shift,alusrca,alusrcb,pcsrc,jal,sext,state);    // control unit
    input      [5:0] op, func;                     // op, func 
    input            clk, clrn;                    // clock and reset
    input            z;                            // alu zero flag
    output reg       wpc;                          // write pc
    output reg       wir;                          // write ir
    output reg       wmem;                         // memory write enable
    output reg       wreg;                         // write regfile
    output reg       iord;                         // select memory address
    output reg       regrt;                        // dest reg number is rt
    output reg       m2reg;                        // instruction is an lw
    output reg       shift;                        // instruction is a shift
    output reg       alusrca;                      // select pc
    output reg       jal;                          // instruction is a jal
    output reg       sext;                         // is sign extension
    output reg [3:0] aluc;                         // alu operation control
    output reg [1:0] alusrcb;                      // alu input b selection
    output reg [1:0] pcsrc;                        // select pc source
    output reg [2:0] state;                        // state
    reg        [2:0] next_state;                   // next state
    parameter  [2:0] sif  = 3'b000,                // IF  state
                     sid  = 3'b001,                // ID  state
                     sexe = 3'b010,                // EXE state
                     smem = 3'b011,                // MEM state
                     swb  = 3'b100;                // WB  state
    wire rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;
    wire i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
    // and (out, in1, in2, ...);                   // instruction decode
    and (rtype,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);
    and (i_add,rtype, func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and (i_sub,rtype, func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and (i_and,rtype, func[5],~func[4],~func[3], func[2],~func[1],~func[0]);
    and (i_or, rtype, func[5],~func[4],~func[3], func[2],~func[1], func[0]);
    and (i_xor,rtype, func[5],~func[4],~func[3], func[2], func[1],~func[0]);
    and (i_sll,rtype,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and (i_srl,rtype,~func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
    and (i_sra,rtype,~func[5],~func[4],~func[3],~func[2], func[1], func[0]);
    and (i_jr, rtype,~func[5],~func[4], func[3],~func[2],~func[1],~func[0]);
    and (i_addi,~op[5],~op[4], op[3],~op[2],~op[1],~op[0]);
    and (i_andi,~op[5],~op[4], op[3], op[2],~op[1],~op[0]);
    and (i_ori, ~op[5],~op[4], op[3], op[2],~op[1], op[0]);
    and (i_xori,~op[5],~op[4], op[3], op[2], op[1],~op[0]);
    and (i_lw,   op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    and (i_sw,   op[5],~op[4], op[3],~op[2], op[1], op[0]);
    and (i_beq, ~op[5],~op[4],~op[3], op[2],~op[1],~op[0]);
    and (i_bne, ~op[5],~op[4],~op[3], op[2],~op[1], op[0]);
    and (i_lui, ~op[5],~op[4], op[3], op[2], op[1], op[0]);
    and (i_j,   ~op[5],~op[4],~op[3],~op[2], op[1],~op[0]);
    and (i_jal, ~op[5],~op[4],~op[3],~op[2], op[1], op[0]);
    wire i_shift = i_sll | i_srl | i_sra;
    always @* begin                                // default outputs:
        wpc     = 0;                               // do not write pc
        wir     = 0;                               // do not write ir
        wmem    = 0;                               // do not write memory
        wreg    = 0;                               // do not write regfile
        iord    = 0;                               // select pc as address
        aluc    = 4'bx000;                         // alu operation: add
        alusrca = 0;                               // alu a: reg a or sa
        alusrcb = 2'h0;                            // alu input b: reg b
        regrt   = 0;                               // reg dest no: rd
        m2reg   = 0;                               // select reg c
        shift   = 0;                               // select reg a
        pcsrc   = 2'h0;                            // select alu output
        jal     = 0;                               // not a jal
        sext    = 1;                               // sign extend
        case (state) //------------------------------------------------- IF:
            sif: begin                             // IF state
                wpc     = 1;                       // write PC
                wir     = 1;                       // write IR
                alusrca = 1;                       // PC
                alusrcb = 2'h1;                    // 4
                next_state = sid;                  // next state: ID
            end //------------------------------------------------------ ID:
            sid: begin                             // ID state
                if (i_j) begin                     // j instruction
                    pcsrc = 2'h3;                  // jump address
                    wpc   = 1;                     // write PC
                    next_state = sif;              // next state: IF
                end else if (i_jal) begin          // jal instruction
                    pcsrc = 2'h3;                  // jump address
                    wpc   = 1;                     // write PC
                    jal   = 1;                     // reg no = 31
                    wreg  = 1;                     // save PC+4
                    next_state = sif;              // next state: IF
                end else if (i_jr) begin           // jr instruction
                    pcsrc = 2'h2;                  // jump register
                    wpc   = 1;                     // write PC
                    next_state = sif;              // next state: IF
                end else begin                     // other instructions
                    aluc    = 4'bx000;             // add
                    alusrca = 1;                   // PC
                    alusrcb = 2'h3;                // branch offset
                    next_state = sexe;             // next state: EXE
                end
            end //----------------------------------------------------- EXE:
//       add sub and or xor sll srl sra lw sw beq bne addi andi ori xori lui
// aluc[3] X  X   X   X  X   0   0   1  X  X   X   X    X    X   X    X   X
// aluc[2] 0  1   0   1  0   0   1   1  0  0   0   0    0    0   1    0   1
// aluc[1] 0  0   0   0  1   1   1   1  0  0   1   1    0    0   0    1   1
// aluc[0] 0  0   1   1  0   1   1   1  0  0   0   0    0    1   1    0   0
            sexe: begin                            // EXE state
                aluc[3] = i_sra;
                aluc[2] = i_sub | i_or  | i_srl | i_sra | i_ori  | i_lui;
                aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq  |
                          i_bne | i_lui;
                aluc[0] = i_and | i_or  | i_sll | i_srl | i_sra  | i_andi |
                          i_ori;
                if (i_beq || i_bne) begin          // beq or bne inst
                    pcsrc = 2'h1;                  // branch address
                    wpc = i_beq & z | i_bne & ~z;  // write PC
                    next_state = sif;              // next state: IF
                end else begin                     // other instruction
                    if (i_lw || i_sw) begin        // lw or sw inst
                        alusrcb = 2'h2;            // select offset
                        next_state = smem;         // next state: MEM
                    end else begin                 // other instruction
                        if (i_shift) shift = 1;    // shift instruction
                        if (i_addi || i_andi || i_ori || i_xori || i_lui)
                            alusrcb = 2'h2;        // select immediate
                        if (i_andi || i_ori || i_xori) sext=0;   // 0 extend
                        next_state = swb;          // next state: WB
                    end
                end
            end //----------------------------------------------------- MEM:
            smem: begin                            // MEM state
                iord = 1;                          // memory address = C
                if (i_lw) begin                    // load
                    next_state = swb;              // next state: WB
                end else begin                     // store
                    wmem = 1;                      // write memory
                    next_state = sif;              // next state: IF
                end
            end //------------------------------------------------------ WB:
            swb: begin                             // WB state
                if (i_lw) m2reg = 1;               // select memory data
                if (i_lw || i_addi || i_andi || i_ori || i_xori || i_lui)
                    regrt = 1;                     // reg dest no: rt
                wreg = 1;                          // write register file
                next_state = sif;                  // next state: IF
            end //------------------------------------------------------ END
            default: begin
                next_state = sif;                  // default state: IF
            end
        endcase
    end
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            state <= sif;                          // reset state to IF
        end else begin
            state <= next_state;                   // state transition
        end
    end
endmodule
