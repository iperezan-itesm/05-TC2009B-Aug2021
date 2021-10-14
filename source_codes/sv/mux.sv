/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux #(parameter N_INPUTS=4,
             parameter DATA_WIDTH = 32
            )
            (input  logic       [DATA_WIDTH-1:0] mux_input [N_INPUTS],
             input  logic [$clog2(N_INPUTS)-1:0] selector,
             output logic       [DATA_WIDTH-1:0] mux_output
            );

    assign mux_output = mux_input[selector];

endmodule
