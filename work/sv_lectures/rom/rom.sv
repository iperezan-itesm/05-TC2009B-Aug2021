module rom #(parameter DATA_WIDTH=32,
             parameter N_WORDS=128
            )
            (input  logic [$clog2(N_WORDS)-1:0] address,
             output logic      [DATA_WIDTH-1:0] data_out
            );

logic [DATA_WIDTH-1:0] rom_mem [N_WORDS];

always_comb begin
    data_out = rom_mem[address];
end

endmodule
