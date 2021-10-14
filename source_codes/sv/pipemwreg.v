/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipemwreg (mwreg,mm2reg,mmo,malu,mrn,clk,clrn,wwreg,wm2reg,wmo,walu,
                  wrn);                      // MEM/WB pipeline register
    input         clk, clrn;                 // clock and reset
    input  [31:0] mmo;                       // memory data out in MEM stage
    input  [31:0] malu;                      // alu control in MEM stage
    input   [4:0] mrn;                       // register number in MEM stage
    input         mwreg, mm2reg;             // in MEM stage
    output [31:0] wmo;                       // memory data out in WB stage
    output [31:0] walu;                      // alu control in WB stage
    output  [4:0] wrn;                       // register number in WB stage
    output        wwreg, wm2reg;             // in WB stage
    reg    [31:0] wmo, walu;
    reg     [4:0] wrn;
    reg           wwreg,wm2reg;
    always @(negedge clrn or posedge clk)
      if (!clrn) begin                       // clear
          wwreg <= 0;                 wm2reg <= 0;
          wmo   <= 0;                 walu   <= 0;
          wrn   <= 0;
      end else begin                         // register
          wwreg <= mwreg;             wm2reg <= mm2reg;
          wmo   <= mmo;               walu   <= malu;
          wrn   <= mrn;
      end
endmodule
