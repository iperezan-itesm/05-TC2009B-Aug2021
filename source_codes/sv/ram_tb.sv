// Define simulation scale
`timescale 1ns/100ps

// Testbench module declaration
// There are no I/O ports in testbenches
module ram_tb;

// Local parameters to be used in testbench
localparam DATA_WIDTH = 8;
localparam N_WORDS = 16;

// I/O ports from ram are internal signals in testbench
logic                       clk;
logic                       we;
logic                       re;
logic [$clog2(N_WORDS)-1:0] address;
logic      [DATA_WIDTH-1:0] data_in;
logic      [DATA_WIDTH-1:0] data_out;

// ram instantiation 
// Override parameters from ram.sv 
// using localparams from testbench
ram_gold_model #(.DATA_WIDTH(DATA_WIDTH),
      .N_WORDS(N_WORDS))
// Connect I/O ports from ram to testbench signals
// Notation: .ram_port(testbench_signal)
// Here we used the same name for both I/O ports and local 
// signals in testbench. We could also have chosen different names such as:
// .we(write_enable)
dut_ram (.clk(clk),
         .wen(we),
         .re(re),
         .address(address),
         .data_in(data_in),
         .data_out(data_out)
         );

// This is an advanced testbench construct
// It allows us to make reference to the 
// create delays in multiples of clock cycles 
// rather than time units (ns, ps, etc)
// For example, in this testbench, 
// #1 creates a 1ns delay (due to the timescale)
// By contrast, ##1 creates a 1 clock cycle delay, i.e. 2ns
default clocking clock @(posedge clk); 
endclocking

/*
clocking cb_ram @(posedge clk);
  default input #2ns output #1ns;
  input #2ns data_out = dut_ram.data_out;
  output we, re, address, data_in;
endclocking
*/

// Create a clock signal with a period of 2ns
// Note that we MUST use a delay in time units
// for the clock generation
always begin
  clk = 1'b0;
  #1;
  clk = 1'b1;
  #1;
end

// Drive data into ram
// Initial blocks are executed ONLY once
// These are only used for simulation
// They are NOT meant for initializing memories in RTL
initial begin
    we = 0;
    re = 0;
    address = 0;
    data_in = 0;
    ##10; // wait 10 clock cycles; nothing should happen
  // Fill ram with data
  for(int ram_index=0; ram_index<N_WORDS; ram_index++) begin
    @(posedge clk)begin
      we <= 1;
      address <= ram_index;
      data_in <= ram_index;
    end
  end
  // Do 100 random writes and reads to/from random addresses
  repeat(100)
    @(posedge clk)begin
      we <= $random;
      re <= $random;
      address <= $random;
      data_in <= $random;
    end
    $stop;
end

endmodule

