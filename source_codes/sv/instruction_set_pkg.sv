package instruction_set_pkg;

parameter OPCODE_WIDTH = 6;
parameter FUNC_WIDTH = 6;

typedef enum logic [2:0] {
    IF  = 3'b000,
    ID  = 3'b001,
    EXE = 3'b010,
    MEM = 3'b011,
    WB  = 3'b100
} state_t;
    

typedef enum logic [OPCODE_WIDTH-1:0]{
    //ADD = 6'b000000, // Register addition
    //SUB = 6'b000000, // Register subtraction
    //AND = 6'b000000, // Register logical AND
    //OR  = 6'b000000, // Register logical OR
    //XOR = 6'b000000, // Reigster logical XOR
    //SLL = 6'b000000, // Shift left logical
    //SRL = 6'b000000, // Shift right logical
    //SLA = 6'b000000, // Shift left arithmetic
    //SRA = 6'b000000, // Shift right arithmetic
    RTYPE = 6'b000000,
    ADDI  = 6'b001000, // Immediate addition 
    SUBI  = 6'b001001, // Immediate subtraction 
    ANDI  = 6'b001010, // Immediate AND
    ORI   = 6'b001011, // Immediate OR
    XORI  = 6'b001100, // Immediate XOR
    
    LW    = 6'b010000, // Load word from mem to reg
    SW    = 6'b010001, // Store word from reg to mem

    BEQ   = 6'b100000, // Branch if equal
    BNE   = 6'b100001, // Branch if not equal

    LUI   = 6'b110000, // Load Upper with immediate
    LLI   = 6'b110001, // Load Lower with immediate

    JR    = 6'b101000, // Register jump
    JMP   = 6'b101001, // Absolute jump
    JAL   = 6'b101010  // Jump and link
} opcode_t;

typedef enum logic [FUNC_WIDTH-1:0]{
    F_ADD = 6'b000000, // Register addition
    F_SUB = 6'b000001, // Register subtraction
    F_AND = 6'b000010, // Register logical AND
    F_OR  = 6'b000100, // Register logical OR
    F_XOR = 6'b001000, // Reigster logical XOR
    F_SLL = 6'b110000, // Shift left logical
    F_SRL = 6'b110001, // Shift right logical
    F_SLA = 6'b110010, // Shift left arithmetic
    F_SRA = 6'b110100, // Shift right arithmetic
    F_JR  = 6'b111000  // Register jump
} func_t;
endpackage
