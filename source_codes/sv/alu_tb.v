/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module alu_tb;
    reg  [31:0] a,b;
    reg  [3:0]  aluc;
    wire [31:0] r;
    wire        z;
    alu al (a,b,aluc,r,z);
    initial begin
            aluc = 4'b0000;      // ADD
            a    = 32'h1;
            b    = 32'h2;
        #10 aluc = 4'b0100;      // SUB
        #10 aluc = 4'b0001;      // AND
            a    = 32'hcccccccc;
            b    = 32'haaaaaaaa;
        #10 aluc = 4'b0101;      // OR
        #10 aluc = 4'b0010;      // XOR
            a    = 32'h33333333;
            b    = 32'hff005555;
        #10 aluc = 4'b0110;      // LUI
        #10 aluc = 4'b0011;      // SLL
            a    = 32'h0000000f;
            b    = 32'hffffffff;
        #10 aluc = 4'b0111;      // SRL
        #10 aluc = 4'b1111;      // SRA
            a    = 32'h00000010;
            b    = 32'h7f000000;
        #10 b    = 32'hffffff00;
        #10 aluc = 4'b0100;      // SUB
            a    = 32'hffffffff;
            b    = 32'hffffffff;
        #10 aluc = 4'b0000;      // ADD
        #10        $finish;
    end
endmodule
