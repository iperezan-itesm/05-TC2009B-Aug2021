/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module mux2x1_dataflow1_tb;
    reg  s,a0,a1;
    wire y;
    mux2x1_dataflow1 mux2x1 (a0,a1,s,y);
    initial begin
           a0 = 0;
           a1 = 0;
           s  = 0;
           $display("time\ts\ta1\ta0\ty");
           $monitor("%2d:\t%b\t%b\t%b\t%b",$time,s,a1,a0,y);
        #8 $finish;
    end
    always #1 a0 = !a0;
    always #2 a1 = !a1;
    always #4 s  = !s;
endmodule
