/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module f2i_tb;
    reg  [31:0] a;
    wire [31:0] d;
    wire        p_lost;
    wire        denorm;
    wire        invalid;
    f2i f_i (a,d,p_lost,denorm,invalid);
    initial begin
        #00 a = 32'h4effffff;
        #10 a = 32'h4f000000;
        #10 a = 32'h3f800000;
        #10 a = 32'h3f000000;
        #10 a = 32'h00000001;
        #10 a = 32'h7f800000;
        #10 a = 32'h3fc00000;
        #10 a = 32'hcf000000;
        #10 a = 32'hcf000001;
        #10 a = 32'hbf800000;
        #10 a = 32'hbf7fffff;
        #10 a = 32'h80000001;
        #10 a = 32'hff800000;
        #10 a = 32'h00000000;
    end
endmodule
