/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module regfile_dataflow_tb;
    reg   [4:0] rna,rnb,wn;
    reg  [31:0] d;
    reg         we,clk,clrn;
    wire [31:0] qa,qb;
    regfile_dataflow rf (rna,rnb,d,wn,we,clk,clrn,qa,qb);
    initial begin
           clk  = 0;
           clrn = 0;
        #2 clrn = 1;
           we   = 1;
           d    = 32'hffff0000;
           wn   = 0;
           rna  = 0;
           rnb  = 5'd31;
        #4 we   = 0;
        #2 we   = 1;
    end
    always #1 clk = !clk;
    always #2 d   = d + 1;
    always #2 wn  = wn + 1;
    always #2 rna = rna + 1;
    always #2 rnb = rnb + 1;
endmodule
