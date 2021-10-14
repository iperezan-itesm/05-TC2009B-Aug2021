/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipemem (we,addr,datain,clk,dataout);          // MEM stage
    input         clk;                                // clock
    input  [31:0] addr;                               // address
    input  [31:0] datain;                             // data in (to mem)
    input         we;                                 // memory write
    output [31:0] dataout;                            // data out (from mem)
    pl_data_mem dmem (clk,dataout,datain,addr,we);    // data memory
endmodule
