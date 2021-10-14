/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module display_i2c_eeprom (sys_clk,clrn,i2c_scl,i2c_sda,r,g,b,hs,vs,vga_clk,
                           blankn,syncn); // write & display chars in eeprom
    input        sys_clk, clrn;                       // sys_clk: 50MHz
    inout        i2c_scl, i2c_sda;                    // i2c clk and data
    output [7:0] r, g, b;                             // vga r,g,b colors
    output       hs, vs;                              // vga h and v synch
    output       vga_clk;                             // for ADV7123 VGA DAC
    output       blankn;                              // for ADV7123 VGA DAC
    output       syncn;                               // for ADV7123 VGA DAC
    wire         font_dot;                            // font dot
    wire  [31:0] inst,pc,d_t_mem,cpu_mem_a,d_f_mem;
    wire         write,read,io_rdn,io_wrn,wvram,rvram;
    wire         ready,overflow;
    reg          vga_clk = 1;                         // vga_clk: 25MHz
    always @(posedge sys_clk)
        vga_clk <= ~vga_clk;                          // vga_clk: 25MHz
    // vga interface controller
    assign blankn = 1;
    assign syncn  = 0;
    wire   [8:0] row_addr;                            // pixel ram row addr
    wire   [9:0] col_addr;                            // pixel ram col addr
    wire         vga_rdn;
    wire  [23:0] vga_pixel = font_dot? 24'hffffff : 24'h0000ff; //white/blue
    vgac vga (vga_clk,clrn,vga_pixel,row_addr,col_addr,vga_rdn,r,g,b,hs,vs);
    wire   [5:0] char_row = row_addr[8:3];            // char row
    wire   [2:0] font_row = row_addr[2:0];            // font row
    wire   [6:0] char_col = col_addr[9:3];            // char col
    wire   [2:0] font_col = col_addr[2:0];            // font col
    // character ram, 640/8 = 80 = 64 + 16; 480/8 = 60;
    wire  [12:0] vga_cram_addr = {1'b0,char_row,6'h0} +
                                 {3'b0,char_row,4'h0} + {6'h0,char_col};
    wire  [12:0] char_ram_addr = wvram ? cpu_mem_a[14:2] : vga_cram_addr;
    reg    [6:0] char_ram [0:4799];                   // 80 * 60 = 4800
    wire   [6:0] ascii = char_ram[char_ram_addr];
    always @(posedge sys_clk) begin
        if (wvram) char_ram[char_ram_addr] <= d_t_mem[6:0];
    end
    // font_table 128 x 8 x 8 x 1
    wire [12:0] ft_a = {ascii,font_row,font_col};     // ascii,row,col
    font_table ft (ft_a,font_dot);
    // i2c master controller
    wire        csn  = io_rdn & io_wrn;               // chip select
    wire  [1:0] addr = cpu_mem_a[3:2];                // i2c address
    wire  [7:0] d_in = d_t_mem[7:0];                  // data to be sent
    wire  [7:0] d_out;                                // data out
    i2c eeprom (sys_clk,clrn,csn,addr,io_wrn,d_in,io_rdn,d_out,i2c_sda,
                i2c_scl);
    // cpu
    single_cycle_cpu_io cpu (sys_clk,clrn,pc,inst,cpu_mem_a,d_f_mem,
                             d_t_mem,write,io_rdn,io_wrn,rvram,wvram);
    // instruction memory
    scinstmem_i2c_eeprom imem (pc,inst);
    // data memory
    wire [31:0] dm_out;                               // data mem data out
    scdatamem_i2c_eeprom dmem (sys_clk,cpu_mem_a,d_t_mem,write,dm_out);
    assign d_f_mem = io_rdn ? dm_out : {24'h0,d_out};
 endmodule
