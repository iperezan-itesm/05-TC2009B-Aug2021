/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module mul_signed (a,b,z);                          // 8x8 signed multiplier
    input   [7:0] a, b;                             // a, b
    output [15:0] z;                                // z = a * b
    wire    [7:0] ab0 = a & {8{b[0]}};              // a or 0 for b[0]
    wire    [7:0] ab1 = a & {8{b[1]}};              // a or 0 for b[1]
    wire    [7:0] ab2 = a & {8{b[2]}};              // a or 0 for b[2]
    wire    [7:0] ab3 = a & {8{b[3]}};              // a or 0 for b[3]
    wire    [7:0] ab4 = a & {8{b[4]}};              // a or 0 for b[4]
    wire    [7:0] ab5 = a & {8{b[5]}};              // a or 0 for b[5]
    wire    [7:0] ab6 = a & {8{b[6]}};              // a or 0 for b[6]
    wire    [7:0] ab7 = a & {8{b[7]}};              // a or 0 for b[7]
    assign z = (({8'b1,~ab0[7], ab0[6:0]}        +  // << 0, + 1 in bit 8
                 {7'b0,~ab1[7], ab1[6:0],1'b0})  +  // << 1
                ({6'b0,~ab2[7], ab2[6:0],2'b0}   +  // << 2
                 {5'b0,~ab3[7], ab3[6:0],3'b0})) +  // << 3
               (({4'b0,~ab4[7], ab4[6:0],4'b0}   +  // << 4
                 {3'b0,~ab5[7], ab5[6:0],5'b0})  +  // << 5
                ({2'b0,~ab6[7], ab6[6:0],6'b0}   +  // << 6
                 {1'b1, ab7[7],~ab7[6:0],7'b0}));   // << 7, + 1 in bit 15
endmodule
