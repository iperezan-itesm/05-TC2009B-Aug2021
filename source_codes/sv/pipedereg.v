/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module pipedereg (dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,
                  djal,dpc4,clk,clrn,ewreg,em2reg,ewmem,ealuc,ealuimm,ea,
                  eb,eimm,ern,eshift,ejal,epc4); // ID/EXE pipeline register
    input         clk, clrn;                 // clock and reset
    input  [31:0] da, db;                    // a and b in ID stage
    input  [31:0] dimm;                      // immediate in ID stage
    input  [31:0] dpc4;                      // pc+4 in ID stage
    input   [4:0] drn;                       // register number in ID stage
    input   [3:0] daluc;                     // alu control in ID stage
    input         dwreg,dm2reg,dwmem,daluimm,dshift,djal;    // in ID stage
    output [31:0] ea, eb;                    // a and b in EXE stage
    output [31:0] eimm;                      // immediate in EXE stage
    output [31:0] epc4;                      // pc+4 in EXE stage
    output  [4:0] ern;                       // register number in EXE stage
    output  [3:0] ealuc;                     // alu control in EXE stage
    output        ewreg,em2reg,ewmem,ealuimm,eshift,ejal;    // in EXE stage
    reg    [31:0] ea, eb, eimm, epc4;
    reg     [4:0] ern;
    reg     [3:0] ealuc;
    reg           ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
    always @(negedge clrn or posedge clk)
        if (!clrn) begin                     // clear
            ewreg   <= 0;             em2reg  <= 0;
            ewmem   <= 0;             ealuc   <= 0;
            ealuimm <= 0;             ea      <= 0;
            eb      <= 0;             eimm    <= 0;
            ern     <= 0;             eshift  <= 0;
            ejal    <= 0;             epc4    <= 0;
        end else begin                       // register
            ewreg   <= dwreg;         em2reg  <= dm2reg;
            ewmem   <= dwmem;         ealuc   <= daluc;
            ealuimm <= daluimm;       ea      <= da;
            eb      <= db;            eimm    <= dimm;
            ern     <= drn;           eshift  <= dshift;
            ejal    <= djal;          epc4    <= dpc4;
        end
endmodule
