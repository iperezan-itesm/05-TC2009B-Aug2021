/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module tlb_8_entry_tb;
    reg  [23:0] pte_in;
    reg         tlbwi,tlbwr;
    reg   [2:0] index;
    reg  [19:0] vpn;
    reg         clk,clrn;
    wire [23:0] pte_out;
    wire        tlb_hit;
    tlb_8_entry tlb (pte_in,tlbwi,tlbwr,index,vpn,clk,clrn,
                     pte_out,tlb_hit);
    initial begin
            clrn   = 0;
            clk    = 1;
            tlbwi  = 0;
            tlbwr  = 0;
            vpn    = 20'h00000;
            index  = 3'h0;
            pte_in = 24'h000000;
        // tlbwi
        #41 clrn   = 1;
            tlbwi  = 1;
            index  = 3'h0;
            vpn    = 20'h80000;
            pte_in = 24'hff0000;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h1;
            vpn    = 20'h80001;
            pte_in = 24'hff0001;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h2;
            vpn    = 20'h80002;
            pte_in = 24'hff0002;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h3;
            vpn    = 20'h80003;
            pte_in = 24'hff0003;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h4;
            vpn    = 20'h80004;
            pte_in = 24'hff0004;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h5;
            vpn    = 20'h80005;
            pte_in = 24'hff0005;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h6;
            vpn    = 20'h80006;
            pte_in = 24'hff0006;
        #40 tlbwi  = 0;
        #40 tlbwi  = 1;
            index  = 3'h7;
            vpn    = 20'h80007;
            pte_in = 24'hff0007;
        #40 tlbwi  = 0;
        // tlbwr
        #40 tlbwr  = 1;
            vpn    = 20'h80008;
            pte_in = 24'hff0008;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h80009;
            pte_in = 24'hff0009;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h8000a;
            pte_in = 24'hff000a;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h8000b;
            pte_in = 24'hff000b;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h8000c;
            pte_in = 24'hff000c;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h8000d;
            pte_in = 24'hff000d;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h8000e;
            pte_in = 24'hff000e;
        #40 tlbwr  = 0;
        #40 tlbwr  = 1;
            vpn    = 20'h8000f;
            pte_in = 24'hff000f;
        #40 tlbwr  = 0;
    end
    always #20 clk = !clk;
endmodule
