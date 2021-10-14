/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module addsub4_tb;
    reg  [3:0] a,b;
    reg        ci;
    reg        sub;
    wire [3:0] s;
    wire       co;
    addsub4 as4 (a,b,ci,sub,s,co);
    initial begin
            a   = 4'h2; // +2
            b   = 4'h3; // +3
            ci  = 0;
            sub = 0;
        #20 a   = 4'he; // -2
            b   = 4'hd; // -3
    end
    always #5  ci  = !ci;
    always #10 sub = !sub;
endmodule
