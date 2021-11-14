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
    ALU_ADD: {c,result} = a + b;         // Addition
    ALU_SUB: {c,result} = a - b;         // Subtraction
    ALU_AND: {c,result} = {1'b0, a & b}; // Logic AND, no carry
    ALU_OR:  {c,result} = {1'b0, a | b}; // Logic OR, no carry
    default: {c,result} = '0;            // Everything zero by default
  endcase

  // Zero flag
  z = result == '0;

  // Negative flag
  n = result[DATA_WIDTH-1];

  // Overflow flag
  if(op==ALU_ADD)begin
    // Overflow when adding
    // Same sign operands AND cout different than sign of result
    v = (a[DATA_WIDTH-1] ~^ b[DATA_WIDTH-1]) & (c ^ result[DATA_WIDTH-1]);
  end else if(op==ALU_SUB) begin
    // Overflow when subtracting
    // Different sign operands AND cout different than sign of result
    v =  (a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]) & (c ^ result[DATA_WIDTH-1]);
  end else begin
    // Logical operations do not produce overflow
    v = 0;
  end

end:alu_case

endmodule:alu
