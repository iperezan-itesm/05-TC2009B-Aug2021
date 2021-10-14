// Import packages
import instruction_set_pkg::*;
import alu_pkg::*;

// Controller declaration
module controller(
                  input  opcode_t     opcode, // Instruction opcode
                  input    func_t       func, // Function type
                  output alu_op_t     alu_op, // ALU operation
                  output logic         rf_we, // Register file write enable
                  output logic         dm_we, // Data memory write enable
                  );

// Instantiate instruction decoder
instruction_decoder 
instruction_decoder (
                     .opcode(opcode),
                     .func(func),
                     .alu_op(alu_op)
                    );
                    
// Enable we signal in register file
always_comb begin
    rf_we = opcode==RTYPE;
end

endmodule
