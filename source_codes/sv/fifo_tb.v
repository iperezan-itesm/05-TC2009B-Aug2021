/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module fifo_tb;
    reg        clk,clrn;
    reg        read;
    reg        write;
    reg  [7:0] data_in;
    wire [7:0] data_out;
    wire       ready;
    wire       overflow;
    fifo queue (clk,clrn,read,write,data_in,data_out,ready,overflow);
    initial begin
            clk     = 0;
            clrn    = 0;
            read    = 0;
            write   = 0;
        #20 clrn    = 1;
            data_in = 8'he0;
            write   = 1;
        #20 data_in = 8'he1;
        #20 data_in = 8'he2;
        #20 data_in = 8'he3;
        #20 data_in = 8'he4;
        #20 data_in = 8'he5;
            read    = 1;
        #20 data_in = 8'he6;
        #20 data_in = 8'he7;
        #20 data_in = 8'he8;
            read    = 0;
        #20 data_in = 8'he9;
        #20 data_in = 8'hea;
        #20 data_in = 8'heb;
        #20 data_in = 8'hec;
        #20 data_in = 8'hed;
        #20 data_in = 8'hee;
        #20 data_in = 8'hef;
        #20 data_in = 8'hf0;
            read    = 1;
        #20 data_in = 8'hf1;
        #20 data_in = 8'hf2;
            read    = 0;
        #20 data_in = 8'hf3;
            read    = 1;
        #20 data_in = 8'hf4;
            write    = 0;
    end
    always #10 clk = !clk;
endmodule
