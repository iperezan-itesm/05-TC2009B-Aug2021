package alu_pkg;

parameter DATA_WIDTH = 4;

typedef enum logic {
  ALU_ADD = 1'b0,
  ALU_SUB = 1'b1
} alu_opcode_t;

endpackage:alu_pkg
