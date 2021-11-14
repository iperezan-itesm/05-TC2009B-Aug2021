import alu_pkg::*;

module alu #(parameter DATA_WIDTH = 4)
           (input  logic    signed [DATA_WIDTH-1:0]      a,
            input  logic    signed [DATA_WIDTH-1:0]      b,
            input  alu_op_t                             op,
            output logic    signed [DATA_WIDTH-1:0] result,
            output logic                                 z,
            output logic                                 n,
            output logic                                 v,
            output logic                                 c
           );

always_comb begin:alu_case
  case(op)
    ALU_ADD:  = ;
    ALU_SUB:  = ;
    ALU_AND:  = ;
    ALU_OR:   = ;
    default:  = '0;
  endcase

end:alu_case

endmodule:alu
