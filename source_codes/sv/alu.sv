/************************************************
************************************************/
// Import alu package
import alu_pkg::*;

// ALU module definition
// We can use all parameters, data types and enum types 
// defined in the package
module alu #(
             parameter DATA_WIDTH = ALU_DATA_WIDTH, // Operand bits
             parameter OP_WIDTH = ALU_OP_WIDTH      // Number of bits for alu opcode
            )
            (
             input  alu_data_t a,  // operand a
             input  alu_data_t b,  // operand b
             input    alu_op_t op, // operation type
             output alu_data_t r,  // result
             output logic      z   // zero flag
            );

// Select between different operations
always_comb begin
  case(op)
        ADD: r = a + b;
        SUB: r = a - b;
        AND: r = a & b;
         OR: r = a | b;
        XOR: r = a ^ b;
        LUI: r = {b[DATA_WIDTH/2-1:0],{(DATA_WIDTH/2){1'b0}}};
        LLI: r = {{(DATA_WIDTH/2){1'b0}},b[DATA_WIDTH/2-1:0]};
        SLL: r = a << b;
        SRL: r = a >> b;
        SLA: r = a <<< b;
        SRA: r = a >>> b;
    default: r = '0;
  endcase
  z = r == 0; // zero flag
end

endmodule
