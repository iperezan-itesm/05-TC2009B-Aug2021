/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipewb (walu,wmo,wm2reg,wdi);      // WB stage
    input  [31:0] walu;                   // alu result or pc+8 in WB stage
    input  [31:0] wmo;                    // data out (from mem) in WB stage
    input         wm2reg;                 // memory to register in WB stage
    output [31:0] wdi;                    // data to be written into regfile
    mux2x32 wb (walu,wmo,wm2reg,wdi);     // select for wdi
endmodule
