/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipeemreg (ewreg,em2reg,ewmem,ealu,eb,ern,clk,clrn,mwreg,mm2reg,
                  mwmem,malu,mb,mrn);        // EXE/MEM pipeline register
    input         clk, clrn;                 // clock and reset
    input  [31:0] ealu;                      // alu control in EXE stage
    input  [31:0] eb;                        // b in EXE stage
    input   [4:0] ern;                       // register number in EXE stage
    input         ewreg,em2reg,ewmem;        // in EXE stage
    output [31:0] malu;                      // alu control in MEM stage
    output [31:0] mb;                        // b in MEM stage
    output  [4:0] mrn;                       // register number in MEM stage
    output        mwreg,mm2reg,mwmem;        // in MEM stage
    reg    [31:0] malu,mb;
    reg     [4:0] mrn;
    reg           mwreg,mm2reg,mwmem;
    always @(negedge clrn or posedge clk)
        if (!clrn) begin                     // clear
            mwreg  <= 0;              mm2reg <= 0;
            mwmem  <= 0;              malu   <= 0;
            mb     <= 0;              mrn    <= 0;
        end else begin                       // register
            mwreg  <= ewreg;          mm2reg <= em2reg;
            mwmem  <= ewmem;          malu   <= ealu;
            mb     <= eb;             mrn    <= ern;
        end
endmodule
