/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module physical_memory (a,dout,din,strobe,rw,ready,clk,memclk,clrn);
    input         clk, memclk, clrn;                     // clocks and reset
    input  [31:0] a;                                     // memory address
    output [31:0] dout;                                  // data out
    input  [31:0] din;                                   // data in
    input         strobe;                                // strobe
    input         rw;                                    // read/write
    output        ready;                                 // memory ready
    wire   [31:0] mem_data_out0;
    wire   [31:0] mem_data_out1;
    wire   [31:0] mem_data_out2;
    wire   [31:0] mem_data_out3;
    // for memory ready
    reg     [2:0] wait_counter;
    reg           ready;
    always @ (negedge clrn or posedge clk) begin
        if (!clrn) begin
            wait_counter <= 3'b0;
        end else begin
            if (strobe) begin
                if (wait_counter == 3'h5) begin          // 6 clock cycles
                    ready <= 1;                          // ready
                    wait_counter <= 3'b0;
                end else begin
                    ready <= 0;
                    wait_counter <= wait_counter + 3'b1;
                end
            end else begin
                ready <= 0;
                wait_counter <= 3'b0;
            end
        end
    end
    // 31 30 29 28 ... 15 14 13 12 ...  3  2  1  0
    //  0  0  0  0      0  0  0  0      0  0  0  0   (0) 0x0000_0000
    //  0  0  0  1      0  0  0  0      0  0  0  0   (1) 0x1000_0000
    //  0  0  1  0      0  0  0  0      0  0  0  0   (2) 0x2000_0000
    //  0  0  1  0      0  0  1  0      0  0  0  0   (3) 0x2000_2000
    wire   [31:0] m_out32 = a[13] ? mem_data_out3 : mem_data_out2;
    wire   [31:0] m_out10 = a[28] ? mem_data_out1 : mem_data_out0;
    wire   [31:0] mem_out = a[29] ? m_out32       : m_out10;
    assign        dout    = ready ? mem_out       : 32'hzzzz_zzzz;
    // (0) 0x0000_0000- (virtual address 0x8000_0000-)
    wire          write_enable0 = ~a[29] & ~a[28] & rw;
    lpm_ram_dq ram0 (.data(din),.address(a[8:2]),.we(write_enable0),
                     .inclock(memclk),.outclock(memclk&strobe),
                     .q(mem_data_out0));
    defparam ram0.lpm_width           = 32;
    defparam ram0.lpm_widthad         =  7;
    defparam ram0.lpm_file            = "cpu_cache_tlb_0.hex";
    defparam ram0.lpm_indata          = "REGISTERED";
    defparam ram0.lpm_outdata         = "REGISTERED";
    defparam ram0.lpm_address_control = "REGISTERED";
    // (1) 0x1000_0000- (virtual address 0x9000_0000-)
    wire          write_enable1 = ~a[29] &  a[28] & rw;
    lpm_ram_dq ram1 (.data(din),.address(a[8:2]),.we(write_enable1),
                     .inclock(memclk),.outclock(memclk&strobe),
                     .q(mem_data_out1));
    defparam ram1.lpm_width           = 32;
    defparam ram1.lpm_widthad         =  7;
    defparam ram1.lpm_file            = "cpu_cache_tlb_1.hex";
    defparam ram1.lpm_indata          = "REGISTERED";
    defparam ram1.lpm_outdata         = "REGISTERED";
    defparam ram1.lpm_address_control = "REGISTERED";
    // (2) 0x2000_0000- (mapped va 0x0000_0000-)
    wire          write_enable2 = a[29] & ~a[13] & rw;
    lpm_ram_dq ram2 (.data(din),.address(a[8:2]),.we(write_enable2),
                     .inclock(memclk),.outclock(memclk&strobe),
                     .q(mem_data_out2));
    defparam ram2.lpm_width           = 32;
    defparam ram2.lpm_widthad         =  7;
    defparam ram2.lpm_file            = "cpu_cache_tlb_2.hex";
    defparam ram2.lpm_indata          = "REGISTERED";
    defparam ram2.lpm_outdata         = "REGISTERED";
    defparam ram2.lpm_address_control = "REGISTERED";
    // (3) 0x2000_2000- (mapped va 0x0000_1000-)
    wire          write_enable3 = a[29] & a[13] & rw;
    lpm_ram_dq ram3 (.data(din),.address(a[8:2]),.we(write_enable3),
                     .inclock(memclk),.outclock(memclk&strobe),
                     .q(mem_data_out3));
    defparam ram3.lpm_width           = 32;
    defparam ram3.lpm_widthad         = 7;
    defparam ram3.lpm_file            = "cpu_cache_tlb_3.hex";
    defparam ram3.lpm_indata          = "REGISTERED";
    defparam ram3.lpm_outdata         = "REGISTERED";
    defparam ram3.lpm_address_control = "REGISTERED";
endmodule
