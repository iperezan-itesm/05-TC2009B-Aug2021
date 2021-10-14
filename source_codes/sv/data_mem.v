/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module data_mem (we,addr,datain,memclk,dataout);
    input  [31:0] addr,datain;
    input         we,memclk;
    output [31:0] dataout;
    lpm_ram_dq ram (.data(datain),.address(addr[6:2]),.we(we),
                    .inclock(memclk),.outclock(memclk),.q(dataout));
    defparam ram.lpm_width           = 32;
    defparam ram.lpm_widthad         =  5;
    defparam ram.lpm_file            = "data_mem.hex";
    defparam ram.lpm_indata          = "REGISTERED";
    defparam ram.lpm_outdata         = "REGISTERED";
    defparam ram.lpm_address_control = "REGISTERED";
endmodule
