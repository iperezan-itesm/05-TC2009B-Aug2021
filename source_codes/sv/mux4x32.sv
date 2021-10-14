/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux4x32 #(parameter N_INPUTS=4,
                 parameter DATA_WIDTH = 32
                ) 
                (input  logic       [DATA_WIDTH-1:0] a0,
                 input  logic       [DATA_WIDTH-1:0] a1,
                 input  logic       [DATA_WIDTH-1:0] a2,
                 input  logic       [DATA_WIDTH-1:0] a3,
                 input  logic [$clog2(N_INPUTS)-1:0] selector,
                 output logic       [DATA_WIDTH-1:0] mux_output
                );
    
    always_comb begin
        case(selector)
            2'b00: mux_output = a0;
            2'b01: mux_output = a1;
            2'b10: mux_output = a2;
            2'b11: mux_output = a3;
        endcase
    end
endmodule
