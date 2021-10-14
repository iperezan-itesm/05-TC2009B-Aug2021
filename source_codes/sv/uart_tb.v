/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module uart_tb;
    reg         clk16x,clrn;
    reg         rdn;
    wire        rxd;
    wire  [7:0] d_out;
    wire        r_ready;
    wire        parity_error;
    wire        frame_error;
    reg   [7:0] d_in;
    reg         wrn;
    wire        txd;
    wire        t_empty;
    wire [10:0] r_buffer;
    wire  [7:0] r_data;
    wire  [7:0] t_buffer;
    wire  [7:0] t_data;
    wire  [3:0] cnt16x;
    wire  [3:0] no_bits_rcvd;
    wire  [3:0] no_bits_sent;
    wire        sampling;
    wire        r_clk1x;
    wire        sending;
    wire        t_clk1x;
    assign      rxd = txd;
    uart u1 (clk16x,clrn,rdn,d_out,r_ready,rxd,parity_error,
             frame_error,wrn,d_in, t_empty,txd,cnt16x,
             no_bits_rcvd,r_buffer,r_clk1x,sampling,r_data,
             no_bits_sent,t_buffer,t_clk1x,sending, t_data);
    initial begin
            clk16x = 1;
            clrn   = 0;
            wrn    = 1;
            d_in   = 8'he1;
        #10 clrn   = 1;
        #10 wrn    = 0;
        #20 wrn    = 1;
        #20 d_in   = 8'h55;
            wrn    = 0;
        #20 wrn    = 1;
    end
    always @(posedge clk16x) begin
        if (!clrn) rdn <= 1;
        else       rdn <= !r_ready;
    end
    always #10 clk16x = !clk16x;
endmodule
/*
    0 - 4001 ns
 3520 - 7521 ns
*/
