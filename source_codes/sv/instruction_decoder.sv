import instruction_decoder_pkg::*;
import alu_pkg::*;

module instruction_decoder(
                           input  opcode_t     opcode, // Instruction opcode
                           input    func_t       func, // Function type
                           output alu_op_t     alu_op, // ALU operation
                          );

always_comb begin
    case(opcode)
        RTYPE: begin
            case(func)
                  F_ADD: alu_op = ALU_ADD;
                  F_SUB: alu_op = ALU_SUB;
                  F_AND: alu_op = ALU_AND;
                  F_OR:  alu_op = ALU_OR;
                  F_XOR: alu_op = ALU_XOR;
				  F_SLL: alu_op = ALU_SLL;
                  F_SRL: alu_op = ALU_SRL;
                  F_SLL: alu_op = ALU_SLL;
                  F_SRA: alu_op = ALU_SRA;
                default: alu_op = ALU_NOP;
            endcase
        end
           ADDI: alu_op = ALU_ADD;
           SUBI: alu_op = ALU_SUB;
           ANDI: alu_op = ALU_AND;
            ORI: alu_op = ALU_OR;
           XORI: alu_op = ALU_XOR;
        default: alu_op = ALU_NOP;
    endcase
end

endmodule
