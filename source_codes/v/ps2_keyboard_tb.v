/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module ps2_keyboard_tb;
    reg        clk,clrn,ps2_clk,ps2_data;
    reg        rdn;
    wire [7:0] data;
    wire       ready;
    wire       overflow;
    ps2_keyboard kbd (clk,clrn,ps2_clk,ps2_data,rdn,data,ready,overflow);
    initial begin
            clk      = 0;
            clrn     = 0;
            ps2_clk  = 1;
            ps2_data = 0;
            rdn      = 1;
        #20 clrn     = 1;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 1;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #40 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 0;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 1;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 0;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #40 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 1;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 0;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #20 ps2_data = 1;
        #20 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #40 ps2_clk  = 0;
        #40 ps2_clk  = 1;
        #100 rdn     = 0;
        #20  rdn     = 1;
    end
    always #10 clk = !clk;
endmodule
