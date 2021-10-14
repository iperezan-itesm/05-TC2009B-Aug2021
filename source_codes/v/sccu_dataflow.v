/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module sccu_dataflow (op,func,z,wmem,wreg,regrt,m2reg,aluc,shift,aluimm,
                      pcsrc,jal,sext);            // control unit
  input  [5:0] op, func;                          // op, func 
  input        z;                                 // alu zero tag
  output [3:0] aluc;                              // alu operation control
  output [1:0] pcsrc;                             // select pc source
  output       wreg;                              // write regfile
  output       regrt;                             // dest reg number is rt
  output       m2reg;                             // instruction is an lw
  output       shift;                             // instruction is a shift
  output       aluimm;                            // alu input b is an i32
  output       jal;                               // instruction is a jal
  output       sext;                              // is sign extension
  output       wmem;                              // write data memory
  // decode instructions
  wire rtype  = ~|op;                                            // r format
  wire i_add  = rtype& func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];
  wire i_sub  = rtype& func[5]&~func[4]&~func[3]&~func[2]& func[1]&~func[0];
  wire i_and  = rtype& func[5]&~func[4]&~func[3]& func[2]&~func[1]&~func[0];
  wire i_or   = rtype& func[5]&~func[4]&~func[3]& func[2]&~func[1]& func[0];
  wire i_xor  = rtype& func[5]&~func[4]&~func[3]& func[2]& func[1]&~func[0];
  wire i_sll  = rtype&~func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];
  wire i_srl  = rtype&~func[5]&~func[4]&~func[3]&~func[2]& func[1]&~func[0];
  wire i_sra  = rtype&~func[5]&~func[4]&~func[3]&~func[2]& func[1]& func[0];
  wire i_jr   = rtype&~func[5]&~func[4]& func[3]&~func[2]&~func[1]&~func[0];
  wire i_addi = ~op[5]&~op[4]& op[3]&~op[2]&~op[1]&~op[0];       // i format
  wire i_andi = ~op[5]&~op[4]& op[3]& op[2]&~op[1]&~op[0];
  wire i_ori  = ~op[5]&~op[4]& op[3]& op[2]&~op[1]& op[0];
  wire i_xori = ~op[5]&~op[4]& op[3]& op[2]& op[1]&~op[0];
  wire i_lw   =  op[5]&~op[4]&~op[3]&~op[2]& op[1]& op[0];
  wire i_sw   =  op[5]&~op[4]& op[3]&~op[2]& op[1]& op[0];
  wire i_beq  = ~op[5]&~op[4]&~op[3]& op[2]&~op[1]&~op[0];
  wire i_bne  = ~op[5]&~op[4]&~op[3]& op[2]&~op[1]& op[0];
  wire i_lui  = ~op[5]&~op[4]& op[3]& op[2]& op[1]& op[0];
  wire i_j    = ~op[5]&~op[4]&~op[3]&~op[2]& op[1]&~op[0];       // j format
  wire i_jal  = ~op[5]&~op[4]&~op[3]&~op[2]& op[1]& op[0];
  // generate control signals
  assign regrt   = i_addi | i_andi | i_ori  | i_xori | i_lw  | i_lui;
  assign jal     = i_jal;
  assign m2reg   = i_lw;
  assign wmem    = i_sw;
  assign aluc[3] = i_sra;                         // refer to alu.v for aluc
  assign aluc[2] = i_sub  | i_or   | i_srl  | i_sra  | i_ori  | i_lui;
  assign aluc[1] = i_xor  | i_sll  | i_srl  | i_sra  | i_xori | i_beq |
                   i_bne  | i_lui;
  assign aluc[0] = i_and  | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
  assign shift   = i_sll  | i_srl  | i_sra;
  assign aluimm  = i_addi | i_andi | i_ori  | i_xori | i_lw  | i_lui | i_sw;
  assign sext    = i_addi | i_lw   | i_sw   | i_beq  | i_bne;
  assign pcsrc[1]= i_jr   | i_j    | i_jal;
  assign pcsrc[0]= i_beq & z | i_bne & ~z | i_j | i_jal;
  assign wreg    = i_add  | i_sub  | i_and  | i_or   | i_xor | i_sll  |
                   i_srl  | i_sra  | i_addi | i_andi | i_ori | i_xori |
                   i_lw   | i_lui  | i_jal;
endmodule
