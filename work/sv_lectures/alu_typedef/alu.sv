import alu_pkg::*;

module alu (input  logic        [DATA_WIDTH-1:0]      a,
            input  logic        [DATA_WIDTH-1:0]      b,
            input  alu_opcode_t                      op,
            output logic        [DATA_WIDTH-1:0] result
           );

always_comb begin:alu_case
  case(op)
    ALU_ADD: result = a + b;
    ALU_SUB: result = a - b;
    default: result = '0;
  endcase
end:alu_case

endmodule:alu
