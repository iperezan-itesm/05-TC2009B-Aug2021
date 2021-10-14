/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module decoder3e (n,ena,d);         // 3-8 decoder with enable
    input  [2:0] n;                 // inputs:  n, 3 bits
    input        ena;               // input:   enable
    output [7:0] d;                 // outputs: d, 2^3 = 8 bits
    reg    [7:0] d;                 // d cannot be a wire
    always @ (ena or n) begin       // always block
        d    = 8'b0;                // let d = 00000000 first
        d[n] = ena;                 // then let n-th bit of d = ena (0 or 1)
    end
endmodule
