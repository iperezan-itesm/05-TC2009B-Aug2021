/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module counter_6_tb;
    reg        u,clk,clrn;
    wire [2:0] q;
    wire       a,b,c,d,e,f,g;
    counter_6 cnt (u,clk,clrn,q,a,b,c,d,e,f,g);
    initial begin
                   clk = 1;
        forever #5 clk = !clk;
    end
    initial begin
            $display("time\tu\tq\ta\tb\tc\td\te\tf\tg");
            clrn = 0;
            u    = 1;
        #5  clrn = 1;
        #80 u    = 0;
        #90 u    = 1;
        #1  $finish;
    end
    initial begin
        $monitor("%1d\t%b\t%d\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time,u,q,a,b,c,d,e,f,g);
    end
endmodule
