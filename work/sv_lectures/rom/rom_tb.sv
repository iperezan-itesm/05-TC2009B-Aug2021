module rom_tb;

localparam DATA_WIDTH=32;
localparam N_WORDS=128;
localparam BIN_CODE_FILE="program_bin.txt";
localparam HEX_CODE_FILE="program_hex.txt";

logic [$clog2(N_WORDS)-1:0] address;
logic           [DATA_WIDTH-1:0] data_from_bin_rom;
logic           [DATA_WIDTH-1:0] data_from_hex_rom;

rom #(.DATA_WIDTH(DATA_WIDTH),
      .N_WORDS(N_WORDS)
     )
dut_rom_bin (.address(address),
             .data_out(data_from_bin_rom)
            );

rom #(.DATA_WIDTH(DATA_WIDTH),
      .N_WORDS(N_WORDS)
     )
dut_rom_hex (.address(address),
             .data_out(data_from_hex_rom)
            );

// Initialise memories
// Reading binary and hex files
initial begin
    $readmemb(BIN_CODE_FILE, rom_tb.dut_rom_bin.rom_mem);
    $readmemh(HEX_CODE_FILE, rom_tb.dut_rom_hex.rom_mem);
end

initial begin
    for(int pc=0; pc<N_WORDS; pc++)begin
        address=pc;
        #10ns;
    end
    $stop;
end
endmodule
