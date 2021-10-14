/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module d_cache_tb;
    reg  [31:0] p_a;
    reg  [31:0] p_dout;
    wire [31:0] p_din;
    reg         p_strobe;
    reg         p_rw;
    reg         uncached;
    wire        p_ready;
    reg         clk,clrn;
    wire [31:0] m_a;
    reg  [31:0] m_dout;
    wire [31:0] m_din;
    wire        m_strobe;
    wire        m_rw;
    reg         m_ready;
    d_cache dcache (p_a,p_dout,p_din,p_strobe,p_rw,uncached,p_ready,
                    clk,clrn,m_a,m_dout,m_din,m_strobe,m_rw,m_ready);
    initial begin
             clrn     = 0;
             clk      = 1;
             p_a      = 32'h00000100;
             p_dout   = 32'h00000000;
             p_strobe = 1;
             p_rw     = 0;
             m_dout   = 32'h00000000;
             uncached = 0;
             m_ready  = 0;
        #10  clrn     = 1;
        #80  m_dout   = 32'hffffffff;
             m_ready  = 1;
        #20  p_a      = 32'h00000000;
             p_strobe = 0;
             m_dout   = 32'h00000000;
             m_ready  = 0;
        #60  p_a      = 32'h00000100;
             p_strobe = 1;
        #20  p_a      = 32'h00000000;
             p_strobe = 0;
        #80  p_a      = 32'h00000104;
             p_dout   = 32'h5555aaaa;
             p_rw     = 1;
             p_strobe = 1;
        #100 m_ready  = 1;
        #20  p_a      = 32'h00000000;
             p_dout   = 32'h00000000;
             p_strobe = 0;
             p_rw     = 0;
             m_ready  = 0;
        #20  p_a      = 32'h00000104;
             p_strobe = 1;
        #20  p_a      = 32'h00000000;
             p_strobe = 0;
    end
    always #10 clk = !clk;
endmodule
