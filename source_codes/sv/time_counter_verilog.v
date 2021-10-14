/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module time_counter_verilog (enable, clk, my_counter);  // a counter example
    input        enable;                                // input,  1 bit
    input        clk;                                   // input,  1 bit
    output [3:0] my_counter;                            // output, 4 bits
    reg    [3:0] my_counter = 0;                        // register type
    always @ (posedge clk) begin                        // positive edge 
        if (enable)                                     // if (enable == 1)
            my_counter <= my_counter + 4'h1;            //     my_counter++
    end
endmodule
