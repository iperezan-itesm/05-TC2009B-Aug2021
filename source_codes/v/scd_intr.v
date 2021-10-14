/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module scd_intr (dataout,datain,addr,we,memclk);          // data mem (sram)
    input  [31:0] datain;                                 // mem data input
    input  [31:0] addr;                                   // mem address
    input         we;                                     // write enable
    input         memclk;                                 // sync ram clock
    output [31:0] dataout;                                // mem data output
    wire          inclk  = memclk;                        // in reg clock
    wire          outclk = memclk;                        // out reg clock
    lpm_ram_dq ram (.data(datain),                        // data in
                    .address(addr[6:2]),                  // word address
                    .we(we),                              // write enable
                    .inclock(inclk),                      // in reg clock
                    .outclock(outclk),                    // out reg clock
                    .q(dataout));                         // mem data out
    defparam ram.lpm_width           = 32;                // data: 32 bits
    defparam ram.lpm_widthad         = 5;                 // 2^5 = 32 words
    defparam ram.lpm_file            = "scd_intr.hex";    // mem init file
    defparam ram.lpm_indata          = "REGISTERED";      // in reg (data)
    defparam ram.lpm_outdata         = "REGISTERED";      // out reg (data)
    defparam ram.lpm_address_control = "REGISTERED";      // in reg (a, we)
endmodule
