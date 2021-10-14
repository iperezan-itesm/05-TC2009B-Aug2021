/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module decoder3e_tb;
    reg  [2:0] n;
    reg        ena;
    wire [7:0] d;
    integer    i;
    decoder3e dec3e (n,ena,d);
    initial begin
        #0 $display("time\tena\tn\td");
        #0 ena = 1;
        #0 n   = 0;
        for (i = 1; i < 8; i = i + 1) begin
            #1 n = i;
        end
        #1 ena = 0;
           n   = 3'bxxx;
        #1 $finish;
    end
    initial begin
        $monitor("%1d\t%b\t%b\t%b",$time,ena,n,d);
    end
endmodule
