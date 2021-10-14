/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux2x1_behavioral_case_default (a0,a1,s,y);   // multiplexer, default
    input  s, a0, a1;                                // inputs
    output y;                                        // output
    reg    y;                                        // y cannot be a wire
    always @ (s or a0 or a1) begin                   // always block
        case (s)                                     // cases:
            1'b1:    y = a1;                         // if (s == 1) y = a1;
            default: y = a0;                         // other cases y = a0;
        endcase
    end
endmodule
