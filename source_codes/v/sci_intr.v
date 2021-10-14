/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module sci_intr (a,inst);                                 // inst mem (rom)
    input  [31:0] a;                                      // mem address
    output [31:0] inst;                                   // mem data output
    lpm_rom rom (.address(a[7:2]),                        // word address
                 .q(inst),                                // mem data output
                 .inclock(),                              // no clock
                 .outclock(),                             // no clock
                 .memenab());                             // no write enable
    defparam rom.lpm_width           = 32,                // data: 32 bits
             rom.lpm_widthad         = 6,                 // 2^6 = 64 words
             rom.lpm_file            = "sci_intr.hex",    // mem init file
             rom.lpm_outdata         = "UNREGISTERED",    // no reg (data)
             rom.lpm_address_control = "UNREGISTERED";    // no reg (addr)
endmodule
