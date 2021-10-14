// Single port ram
// Supports one write or read per cycle
// Writes have priority over reads
// data_out must be set to high impedance (z) if
//     there are no read or writes (ram is inactive)
//     there is a write

// This is an empty shell
// You will have to include your code below
// Verilog shell
module ram #(parameter DATA_WIDTH=8,
             parameter N_WORDS=16)
            (input                         clk,
             input                         we,
             input                         re,
             input   [$clog2(N_WORDS)-1:0] address,
             input        [DATA_WIDTH-1:0] data_in,
             output       [DATA_WIDTH-1:0] data_out
            );

// YOUR CODE GOES HERE

endmodule
