module rom_tb;

localparam INST_WIDTH=32;
localparam MAX_NUM_INST=128;
localparam BIN_CODE_FILE="program.dat";

logic [$clog2(MAX_NUM_INST)-1:0] address;
logic           [INST_WIDTH-1:0] instruction;


rom #(.INST_WIDTH(INST_WIDTH),
      .MAX_NUM_INST(MAX_NUM_INST),
      .BIN_CODE_FILE(BIN_CODE_FILE)
     )
inst_mem(.address(address),
         .instruction(instruction)
);

initial begin
    for(int pc=0; pc<MAX_NUM_INST; pc++)begin
        address=pc;
        #10ns;
    end
    $stop;
end
endmodule
