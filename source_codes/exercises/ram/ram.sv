// Single port ram
// Supports one write or read per cycle
// Writes have priority over reads
// data_out must be set to high impedance (z) if
//     there are no read or writes (ram is inactive)
//     there is a write

// This is an empty shell
// You will have to include your code below
// SystemVerilog shell
module ram #(parameter DATA_WIDTH=8,
             parameter N_WORDS=16)
            (input  logic                       clk,
             input  logic                       we,
             input  logic                       re,
             input  logic [$clog2(N_WORDS)-1:0] address,
             input  logic      [DATA_WIDTH-1:0] data_in,
             output logic      [DATA_WIDTH-1:0] data_out
            );

// YOUR CODE GOES HERE
// Create memory space
logic [DATA_WIDTH-1:0] mem [N_WORDS];

always_ff@(posedge clk) begin
    // Writes take priority over reads
    if(we)begin
        mem[address] <= data_in;
    end
end

always_comb begin
    data_out = (re && !we) ? mem[address] : 'z;
end

endmodule
