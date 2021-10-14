// Name of package
package alu_pkg;

// Parameters definition
parameter ALU_DATA_WIDTH = 32;
parameter ALU_OP_WIDTH = 4;

// Define a data type for ALU's operation
// Use an enumerate data structure
// enums are used for declaring a group of constants
// In SV, we may delimit the number of bits used to 
// represent the constants.
// The enum corresponds to a logic data type with 
// fixed number of bits.
// The data type is ALU_OP_WIDTH bits wide
typedef enum logic [ALU_OP_WIDTH-1:0] {
  ALU_ADD = 4'b0000,  // Addition
  ALU_SUB = 4'b0001,  // Subtraction
  ALU_AND = 4'b0010,  // Logical AND
  ALU_OR  = 4'b0011,  // Logical OR
  ALU_XOR = 4'b0100,  // Logical XOR
  ALU_LUI = 4'b0101,  // Load upper with immediate
  ALU_LLI = 4'b0110,  // Load lower with immediate
  ALU_SLL = 4'b0111,  // Shift left logical
  ALU_SRL = 4'b1000,  // Shift right logical
  ALU_SLA = 4'b1001,  // Shift left arithmetic
  ALU_SRA = 4'b1010,  // Shift right arithmetic
  ALU_NOP = 4'b1111   // Output zero
} alu_op_t;

typedef logic signed [ALU_DATA_WIDTH-1:0] alu_data_t;

endpackage
