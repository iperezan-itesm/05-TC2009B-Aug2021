/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module pci_target_mem_tb;
    reg         clk;
    reg         rstn;
    reg         framen;
    reg   [3:0] cben;
    reg  [31:0] ad_in;
    wire [31:0] ad;
    reg         irdyn;
    wire        trdyn;
    wire        devseln;
    wire        mem_read_write;
    reg         mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_data_write;
    reg  [31:0] mem_data_read;
    wire  [1:0] state;
    assign      ad = ad_in;
    pci_target_mem pci (clk,rstn,framen,cben,ad,irdyn,trdyn,
                        devseln,mem_read_write,mem_ready,mem_addr,
                        mem_data_write,mem_data_read,state);
    initial begin
            clk           = 0;
            rstn          = 0;
            framen        = 1;
            cben          = 0;
            ad_in         = 32'hzzzzzzzz;
            irdyn         = 1;
            mem_ready     = 0;
            mem_data_read = 32'hzzzzzzzz;
        #15 rstn          = 1;
        #5  framen        = 0;
            cben          = 4'h7;
            ad_in         = 32'hfffffff0;
        #20 irdyn         = 0;
            mem_ready     = 1;
            cben          = 0;
            ad_in         = 32'h55550000;
        #20 ad_in         = 32'h55551111;
        #20 irdyn         = 1;
            mem_ready     = 0;
        #20 framen        = 1;
            irdyn         = 0;
            ad_in         = 32'h55552222;
        #40 mem_ready     = 1;
        #20 irdyn         = 1;
            mem_ready     = 0;
            ad_in         = 32'hzzzzzzzz;
        #60 framen        = 0;
            cben          = 4'h6;
            ad_in         = 32'hfffffff0;
        #20 irdyn         = 0;
            cben          = 0;
            ad_in         = 32'hzzzzzzzz;
        #20 mem_ready     = 1;
            mem_data_read = 32'h55550000;
        #20 mem_ready     = 0;
            mem_data_read = 32'hzzzzzzzz;
        #20 mem_ready     = 1;
            mem_data_read = 32'h55551111;
        #20 irdyn         = 1;
            mem_data_read = 32'h55552222;
        #20 framen        = 1;
            irdyn         = 0;
        #20 irdyn         = 1;
            mem_ready     = 0;
            mem_data_read = 32'hzzzzzzzz;
    end
    always #10 clk = !clk;
endmodule
/*
  20 - 150 ns
 220 - 350 ns
*/
