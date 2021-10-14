/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module demux1to8_tb;
    reg  [2:0] s;
    reg        y;
    wire [7:0] a;
    integer    i;
    demux1to8 dm (s,y,a);
    initial begin
        #0 $display("time\ts\ty\ta");
        #0 s = 0;
        #0 y = 1;
        for (i = 1; i < 8; i = i + 1) begin
            #1 s = i;
        end
        #1 s = 0;
           y = 0;
        for (i = 1; i < 8; i = i + 1) begin
            #1 s = i;
        end
        #1 $finish;
    end
    initial begin
        $monitor("%1d\t%b\t%b\t%b",$time,s,y,a);
    end
endmodule
