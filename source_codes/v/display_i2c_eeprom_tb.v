/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`timescale 1ns/1ns
module display_i2c_eeprom_tb;
    reg        sys_clk,clrn;
    reg        scl_in,sda_in;       // for assigning values to inout signals
    wire       i2c_scl,i2c_sda;
    wire [7:0] r,g,b;
    wire       hs,vs;
    wire       vga_clk;
    wire       blankn;
    wire       syncn;
    display_i2c_eeprom ie (sys_clk,clrn,i2c_scl,i2c_sda,
                           r,g,b,hs,vs,vga_clk,blankn,syncn);
    assign     i2c_scl = scl_in;    // assign to inout signal
    assign     i2c_sda = sda_in;    // assign to inout signal
    initial begin
               sda_in  = 1'hz;
               scl_in  = 1'hz;
               sys_clk = 1;
               clrn    = 0;
        #5     clrn    = 1;
        // ack for writing eeprom[0x0a55] = 0x43
        #27515 sda_in  = 0;         // a0 ack
        #2500  sda_in  = 1'hz;
        #22500 sda_in  = 0;         // 0a ack
        #2500  sda_in  = 1'hz;
        #22500 sda_in  = 0;         // 55 ack
        #2500  sda_in  = 1'hz;
        #22500 sda_in  = 0;         // 43 ack
        #2500  sda_in  = 1'hz;
        // ack for reading eeprom[0x0a55]
        #32500 sda_in  = 1;         // a0 nack
        #2500  sda_in  = 1'hz;
        #27500 sda_in  = 1;         // a0 nack
        #2500  sda_in  = 1'hz;
        #27500 sda_in  = 0;         // a0 ack
        #2500  sda_in  = 1'hz;
        #22500 sda_in  = 0;         // 0a ack
        #2500  sda_in  = 1'hz;
        #22500 sda_in  = 0;         // 55 ack
        #2500  sda_in  = 1'hz;
        #27500 sda_in  = 0;         // a1 ack
        #2500  sda_in  = 1'hz;
        // 0x43 'C': output of eeprom[0x0a55]
        #2500  sda_in  = 0;         // bit 7
        #2500  sda_in  = 1;         // bit 6
        #2500  sda_in  = 0;         // bit 5
        #2500  sda_in  = 0;         // bit 4
        #2500  sda_in  = 0;         // bit 3
        #2500  sda_in  = 0;         // bit 2
        #2500  sda_in  = 1;         // bit 1
        #2500  sda_in  = 1;         // bit 0
        #2500  sda_in  = 1'hz;      // nack
        //  315 us
    end
    always #10 sys_clk = !sys_clk;  // 50 MHz
endmodule
/*
 1.   0 -  56 us
 2.  56 - 112 us
 3. 112 - 162 us
 4. 162 - 212 us
 5. 212 - 262 us
 6. 262 - 312 us
*/
