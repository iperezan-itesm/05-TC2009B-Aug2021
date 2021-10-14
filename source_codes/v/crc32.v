/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module crc32 (clk,clrn,m,crc);  // G = x^{32} + x^{26} + x^{23} + x^{22} + 
    // x^{16} + x^{12} + x^{11} + x^{10} + x^{8} + x^{7} + x^{5} + x^{4} +
    // x^{2} + x + 1
    // D = 1_0000_0100_1100_0001_0001_1101_1011_0111 = 0x104c11db7
    input             clk, clrn;                      // clock and reset
    input             m;                              // message or dividend
    output reg [31:0] crc;                            // 32-bit crc code
    wire              m_xor_crc31 = m ^ crc[31]; 
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            crc <= 0;
        end else begin
            crc[00] <=           m_xor_crc31;         // x^{00}
            crc[01] <= crc[00] ^ m_xor_crc31;         // x^{01}
            crc[02] <= crc[01] ^ m_xor_crc31;         // x^{02}
            crc[03] <= crc[02];
            crc[04] <= crc[03] ^ m_xor_crc31;         // x^{04}
            crc[05] <= crc[04] ^ m_xor_crc31;         // x^{05}
            crc[06] <= crc[05];
            crc[07] <= crc[06] ^ m_xor_crc31;         // x^{07}
            crc[08] <= crc[07] ^ m_xor_crc31;         // x^{08}
            crc[09] <= crc[08];
            crc[10] <= crc[09] ^ m_xor_crc31;         // x^{10}
            crc[11] <= crc[10] ^ m_xor_crc31;         // x^{11}
            crc[12] <= crc[11] ^ m_xor_crc31;         // x^{12}
            crc[13] <= crc[12];
            crc[14] <= crc[13];
            crc[15] <= crc[14];
            crc[16] <= crc[15] ^ m_xor_crc31;         // x^{16}
            crc[17] <= crc[16];
            crc[18] <= crc[17];
            crc[19] <= crc[18];
            crc[20] <= crc[19];
            crc[21] <= crc[20];
            crc[22] <= crc[21] ^ m_xor_crc31;         // x^{22}
            crc[23] <= crc[22] ^ m_xor_crc31;         // x^{23}
            crc[24] <= crc[23];
            crc[25] <= crc[24];
            crc[26] <= crc[25] ^ m_xor_crc31;         // x^{26}
            crc[27] <= crc[26];
            crc[28] <= crc[27];
            crc[29] <= crc[28];
            crc[30] <= crc[29];
            crc[31] <= crc[30];
        end
    end
endmodule
