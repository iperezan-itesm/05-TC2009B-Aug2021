/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module crc3 (clk,clrn,m,crc);                  // G = x^3 + x + 1 (D = 1011)
    input            clk, clrn;                // clock and reset
    input            m;                        // message or dividend
    output reg [2:0] crc;                      // 3-bit crc code
    wire             m_xor_crc2 = m ^ crc[2]; 
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            crc <= 0;
        end else begin
            crc[0] <=         m_xor_crc2;      // 1
            crc[1] <= crc[0]^ m_xor_crc2;      // x
            crc[2] <= crc[1];
        end
    end
endmodule
