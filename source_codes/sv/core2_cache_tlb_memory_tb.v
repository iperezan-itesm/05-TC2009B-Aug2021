/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module core2_cache_tlb_memory_tb;
    reg         clk,memclk,clrn;
    wire [31:0] v_pc1,v_pc2;
    wire [31:0] pc1,pc2;
    wire [31:0] inst1,inst2;
    wire [31:0] ealu1,ealu2;
    wire [31:0] malu1,malu2;
    wire [31:0] wdi1,wdi2;
    wire [31:0] wd1,wd2;
    wire  [4:0] wn1,wn2;
    wire        ww1,ww2;
    wire        stall_lw1,stall_lw2;
    wire        stall_fp1,stall_fp2;
    wire        stall_lwc11,stall_lwc12;
    wire        stall_swc11,stall_swc12;
    wire        stall1,stall2;
    wire [31:0] m_a;
    wire [31:0] m_d_r;
    wire [31:0] m_d_w;
    wire        m_access;
    wire        m_write;
    wire        m_ready;
    core2_cache_tlb_memory dualcore (v_pc1,pc1,inst1,ealu1,malu1,wdi1,wn1,
                                     wd1,ww1,stall_lw1,stall_fp1,
                                     stall_lwc11,stall_swc11,stall1,
                                     v_pc2,pc2,inst2,ealu2,malu2,wdi2,wn2,
                                     wd2,ww2,stall_lw2,stall_fp2,
                                     stall_lwc12,stall_swc12,stall2,
                                     clk,memclk,clrn,m_a,m_d_r,m_d_w,
                                     m_access,m_write,m_ready);
    initial begin
              clk    = 1;
              memclk = 0;
              clrn   = 0;
        #1    clrn   = 1;
        #8999 $finish; 
    end
    always #1 memclk = !memclk;
    always #2 clk    = !clk;
endmodule
/* 168
 1  004 -  172.001
 2  172 -  340.001
 3  340 -  508.001
 4  508 -  676.001
 5  676 -  844.001
 6  844 - 1012.001
 7 1012 - 1180.001
 8 1180 - 1348.001
 9 2332 - 2500.001
10 7096 - 7264.001
*/
