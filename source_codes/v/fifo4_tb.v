/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module fifo4_tb;
    reg        clr;
    reg        write;
    reg  [7:0] din;
    reg        read;
    wire [7:0] dout;
    wire       full;
    wire       empty;
    fifo4 queue4 (clr,write,din,read,dout,full,empty);
    initial begin
            clr   = 1;
            write = 0;
            read  = 0;
        #20 clr   = 0;
            din   = 8'he1;
        #5  write = 1;
        #10 write = 0;
        #5  din   = 8'he2;
        #5  write = 1;
        #10 write = 0;
        #5  din   = 8'he3;
        #5  write = 1;
        #10 write = 0;
        #5  din   = 8'he4;
        #5  write = 1;
        #10 write = 0;
        #10 read  = 1;
        #10 read  = 0;
        #10 read  = 1;
        #10 read  = 0;
        #10 read  = 1;
        #10 read  = 0;
        #10 read  = 1;
        #10 read  = 0;
    end
endmodule
