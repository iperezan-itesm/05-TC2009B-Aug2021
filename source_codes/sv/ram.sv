// Single port ram
// Supports one write or read per cycle
// Writes have priority over reads

module ram #(parameter DATA_WIDTH=8,
             parameter N_WORDS=16)
            (input  logic                       clk,
             input  logic                       we,
             input  logic                       re,
             input  logic [$clog2(N_WORDS)-1:0] address,
             input  logic      [DATA_WIDTH-1:0] data_in,
             output logic      [DATA_WIDTH-1:0] data_out
            );
`pragma protect begin
logic [DATA_WIDTH-1:0] mem [N_WORDS];

always_ff@(posedge clk) begin
    if(we)begin
        mem[address] <= data_in;
        data_out <= 'z;
    end else if(re) begin
        data_out <= mem[address];
    end else begin 
        data_out <= 'z;
    end
end

`pragma protect end
endmodule
