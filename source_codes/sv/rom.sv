module rom #(parameter INST_WIDTH=32,
             parameter MAX_NUM_INST=128,
             parameter BIN_CODE_FILE="program.dat"
            )
            (input  logic [$clog2(MAX_NUM_INST)-1:0] address,
             output logic           [INST_WIDTH-1:0] instruction
            );

logic [INST_WIDTH-1:0] inst_mem [MAX_NUM_INST];

initial begin
    $readmemb(BIN_CODE_FILE, inst_mem);
end

always_comb begin
    instruction = inst_mem[address];
end

endmodule
