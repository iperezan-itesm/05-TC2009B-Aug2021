/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module gates7_structural_tb;
    reg  a,b;
    wire f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor;
    gates7_structural g (a,b,f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor);
    initial begin
           a = 0; b = 0;
        #1 $display (" a=%b",a," b=%b",b," f_and=%b",f_and,
                     " f_or=%b",f_or," f_not=%b",f_not,
                     " f_nand=%b",f_nand," f_nor=%b",f_nor,
                     " f_xor=%b",f_xor," f_xnor=%b",f_xnor);
        #1 a = 1; b = 0;
        #1 $display (" a=%b",a," b=%b",b," f_and=%b",f_and,
                     " f_or=%b",f_or," f_not=%b",f_not,
                     " f_nand=%b",f_nand," f_nor=%b",f_nor,
                     " f_xor=%b",f_xor," f_xnor=%b",f_xnor);
        #1 a = 0; b = 1;
        #1 $display (" a=%b",a," b=%b",b," f_and=%b",f_and,
                     " f_or=%b",f_or," f_not=%b",f_not,
                     " f_nand=%b",f_nand," f_nor=%b",f_nor,
                     " f_xor=%b",f_xor," f_xnor=%b",f_xnor);
        #1 a = 1; b = 1;
        #1 $display (" a=%b",a," b=%b",b," f_and=%b",f_and,
                     " f_or=%b",f_or," f_not=%b",f_not,
                     " f_nand=%b",f_nand," f_nor=%b",f_nor,
                     " f_xor=%b",f_xor," f_xnor=%b",f_xnor);
        #1 a = 0; b = 0;
        #1 $finish;
    end
    initial begin
        $dumpfile("gates7_structural.vcd");
        $dumpvars;
    end
endmodule
