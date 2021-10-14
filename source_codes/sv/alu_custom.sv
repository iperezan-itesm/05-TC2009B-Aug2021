/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module alu #(
             parameter DATA_WIDTH = 32,
             parameter OPCODE_WIDTH = 4
            )
            (
             input  logic   [DATA_WIDTH-1:0] a,       // operand a
             input  logic   [DATA_WIDTH-1:0] b,       // operand b
             input  logic [OPCODE_WIDTH-1:0] opcode,  // opcode
             output logic   [DATA_WIDTH-1:0] alu_out, // result
             output logic                    ov,      // overflow flag
             output logic                    zero     // zero flag
            );

    typedef enum logic [OPCODE_WIDTH-1:0] {
      ADD = 4'bx000;
      SUB = 4'bx100;
      NOT = 4'b0001;
      AND = 4'b0011;
      OR  = 4'b0101;
      XOR = 4'b0110;
      LUI = 4'b0110;//
      SLA = 4'b0111;
      SLL = 4'b1001;
      SRL = 4'b1010;
      SRA = 4'b1011;
    } opcode_t;
    /*
    always_comb begin
      case(opcode)
        ADD: alu_out = a + b;
        SUB: alu_out = a - b;
        AND: alu_out = a & b;
        OR: alu_out = a | b;
        XOR: alu_out = a ^ b;
        LUI: alu_out = {b[DATA_WIDTH/2-1:0],{(DATA_WIDTH/2){1'b0}}};
        SLL: alu_out = a & b;
        SRL: alu_out = a & b;
        SRA: alu_out = a & b;
    end

    // internal signals
    logic   [DATA_WIDTH-1:0] d_and;      // x 0 0 1  AND
    logic   [DATA_WIDTH-1:0] d_or;       // x 1 0 1  OR
    logic   [DATA_WIDTH-1:0] d_xor;      // x 0 1 0  XOR
    logic   [DATA_WIDTH-1:0] d_lui;      // x 1 1 0  LUI
    logic   [DATA_WIDTH-1:0] d_and_or;   // 0 0 1 1  SLL
    logic   [DATA_WIDTH-1:0] d_xor_lui;  // 0 1 1 1  SRL
    logic   [DATA_WIDTH-1:0] d_shift;    // 1 1 1 1  SRA
    logic   [DATA_WIDTH-1:0] sum;
*/
    always_comb begin
        d_and     = a & b;                             // x 0 0 1  AND
        d_or      = a | b;                             // x 1 0 1  OR
        d_xor     = a ^ b;                             // x 0 1 0  XOR
        d_lui     = {b[DATA_WIDTH/2-1:0],{(DATA_WIDTH/2){1'b0}}};                   // x 1 1 0  LUI
        d_and_or  = opcode[2]? d_or  : d_and;      // 0 0 1 1  SLL
        d_xor_lui = opcode[2]? d_lui : d_xor;      // 0 1 1 1  SRL
    end
    // add/sub module
    addsub #(.DATA_WIDTH(DATA_WIDTH))
    addsub  (.a(a),
             .b(b),
             .sub(opcode[2]),
             .sum(sum),
             .cout(ov)
            );
    // arithmetic and logic shift
    shift #(.DATA_WIDTH(DATA_WIDTH))
    shift (.d(b),
           .shift_amount(a[4:0]),
           .right(opcode[2]),
           .arith(opcode[3]),
           .d_shift(d_shift)
           );
    // 4:1 mux
    mux4x32 #(.N_INPUTS(N_INPUTS),
              .DATA_WIDTH(DATA_WIDTH))
    res      (.a0(sum),
              .a1(d_and_or),
              .a2(d_xor_lui),
              .a3(d_shift),
              .selector(opcode[1:0]),
              .mux_out(alu_out)
             );
    assign zero = ~|alu_out;                                          // zero = (alu_out == 0)
endmodule
