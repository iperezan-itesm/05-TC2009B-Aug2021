/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module inst_mem (a,inst);
    input  [31:0] a;
    output [31:0] inst;
    lpm_rom rom (.address(a[7:2]),.q(inst),
                 .inclock(),.outclock(),.memenab());
    defparam rom.lpm_width           = 32,
             rom.lpm_widthad         =  6,
             rom.lpm_file            = "inst_mem.hex",
             rom.lpm_outdata         = "UNREGISTERED",
             rom.lpm_address_control = "UNREGISTERED";
endmodule
