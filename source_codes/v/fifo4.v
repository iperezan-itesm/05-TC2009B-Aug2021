/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module fifo4 (clr, write, din, read, dout, full, empty);
    input        clr;
    input        write;
    input  [7:0] din;
    input        read;
    output [7:0] dout;
    output       full;
    output       empty;
    wire         clk1, clk2, clk3, clk4;
    wire   [7:0] d12,  d23,  d34;
    wire         q1,   q2,   q3;
    wire         qn1,  qn2,  qn3,  qn4;
    wire         write_n;
    wire         pulse;
    ff8    r1 (clk1, din, d12);
    ff8    r2 (clk2, d12, d23);
    ff8    r3 (clk3, d23, d34);
    ff8    r4 (clk4, d34, dout);
    latch  f1 (clr, clk1, clk2, q1, qn1);
    latch  f2 (clr, clk2, clk3, q2, qn2);
    latch  f3 (clr, clk3, clk4, q3, qn3);
    latch  f4 (clr, clk4, read, q4, qn4);
    ffc    fc (write, clk1 | clr, ~clr, pulse);
    and #1 a1 (clk1, pulse, qn1);
    and #1 a2 (clk2, q1,    qn2);
    and #1 a3 (clk3, q2,    qn3);
    and #1 a4 (clk4, q3,    qn4, ~read);
    assign full  =  q1;
    assign empty = qn4;
endmodule

module latch (clr, s, r, q, qn);
    input  clr;
    input  s;
    input  r;
    output q;
    output qn;
    nor nor1 (q,  r, clr, qn);
    nor nor2 (qn, s, q);
endmodule

module ff8 (clk, d, q);
    input        clk;
    input  [7:0] d;
    output [7:0] q;
    reg    [7:0] q;
    always @ (posedge clk)
        q <= d;
endmodule

module ffc (clk, clr, d, q);
    input  clk, clr;
    input  d;
    output q;
    reg    q;
    always @ (posedge clk or posedge clr)
        if (clr) q <= 0;
        else     q <= d;
endmodule
