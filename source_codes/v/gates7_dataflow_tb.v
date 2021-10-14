/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module gates7_dataflow_tb;
    reg  a,b;
    wire f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor;
    gates7_dataflow g7 (a,b,f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor);
    initial begin
        $display("time\ta\tb\tand\tor\tnot\tnand\tnor\txor\txnor");
        a = 0; 
        b = 0;
        #5 $finish;
    end
    initial begin
        $monitor ("%2d:\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                  $time,a,b,f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor);
    end
    always #1 a = !a;
    always #2 b = !b;
endmodule
