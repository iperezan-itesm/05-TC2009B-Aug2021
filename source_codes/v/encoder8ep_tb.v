/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module encoder8ep_tb;
    reg  [7:0] d;
    reg        ena;
    wire [2:0] n;
    wire       g;
    integer    i;
    encoder8ep enc (d,ena,n,g);
    initial begin
        #0 $display("time\tena\td\t\tn\tg");
        #0 ena = 1;
        #0 d   = 8'b1xxxxxxx;
        for (i = 0; i < 8; i = i + 1)
            #1 d = d >> 1;
        #1 ena = 0;
           d   = 8'bxxxxxxxx;
        #1 $finish;
    end
    initial begin
        $monitor("%1d\t%b\t%b\t%b\t%b",$time,ena,d,n,g);
    end
endmodule
