/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mux2x1_behavioral_if (a0,a1,s,y);       // multiplexer, default first
    input  s, a0, a1;                          // inputs
    output y;                                  // output
    reg    y;                                  // y cannot be a wire
    always @ (s or a0 or a1) begin             // always block
        y = a0;                                // y = a0;
        if (s) begin                           // if (s == 1)
            y = a1;                            //     y = a1; 
        end
    end
endmodule
