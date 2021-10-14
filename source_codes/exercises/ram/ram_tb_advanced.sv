// Define simulation scale
`timescale 1ns/100ps

// Testbench module declaration
// There are no I/O ports in testbenches
module ram_tb;

// Local parameters to be used in testbench
// Note how we can choose different values 
// for our design without having to re-write
// our ram
localparam DATA_WIDTH = 16;
localparam N_WORDS    = 32;

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

// reference model
ram_reference_model #(.DATA_WIDTH(DATA_WIDTH),
                      .N_WORDS(N_WORDS))
// Connect I/O ports from ram to testbench signals
// Notation: .ram_port(testbench_signal)
// Here we used the same name for both I/O ports and local 
// signals in testbench. We could also have chosen different names such as:
// .we(write_enable)
dut_ram_reference (.clk(clk),
                   .we(we),
                   .re(re),
                   .address(address),
                   .data_in(data_in),
                   .data_out(data_out)
                  );

// Instantiate your ram design
ram #(.DATA_WIDTH(DATA_WIDTH),
      .N_WORDS(N_WORDS))
dut_ram (.clk(clk),
         .we(we),
         .re(re),
         .address(address),
         .data_in(data_in),
         .data_out(data_out)
         );


// Create a clock signal with a period of 10ns
// Note that we MUST use a delay in time units
// for the clock generation
// define clock period as 10 time units - 10ns 
localparam real TCLK = 10;
always begin
    clk = 1'b0;
    #(0.5*TCLK);
    clk = 1'b1;
    #(0.5*TCLK);
end

// This is an advanced testbench construct
// It allows us to create delays in terms of multiples of clock cycles 
// rather than time units (ns, ps, etc)
// For example, in this testbench, 
// #1 creates a 1ns delay (due to the timescale)
// By contrast, ##1 creates a 1 clock cycle delay, i.e. 10ns
default clocking clock @(posedge clk); 
endclocking

// This testbench constructs allows us to drive data into our DUT
// simulating a delay after the clock edge
// This helps in understanding how sequential logic works since we
// can see exactly what data is being latched at the clock edge
localparam INPUT_DELAY = (0.1*TCLK);
localparam OUTPUT_DELAY= (0.2*TCLK);
clocking cb_ram @(posedge clk);
    default input #(INPUT_DELAY) output #(OUTPUT_DELAY);
    //input  data_out  =  dut_ram_reference.data_out;
    input  data_out;
    output we, re, address, data_in;
endclocking

// Drive data into ram
// Initial blocks are executed ONLY once
// These are only used for simulation
// They are NOT meant for initializing memories in RTL
initial begin
    cb_ram.we      <= 0;
    cb_ram.re      <= 0;
    cb_ram.address <= 0;
    cb_ram.data_in <= 0;
    ##10; // wait 10 clock cycles; nothing should happen
    // Fill ram with data
    for(int ram_index=0; ram_index<N_WORDS; ram_index++) begin
        @(posedge clk)begin
            cb_ram.we      <= 1;
            cb_ram.address <= ram_index;
            cb_ram.data_in <= ram_index;
        end
    end
    // Do 100 random writes and reads to/from random addresses
    repeat(100) begin
        @(posedge clk)begin
            cb_ram.we      <= $random;
            cb_ram.re      <= $random;
            cb_ram.address <= $random;
            cb_ram.data_in <= $random;
        end
    end
    $stop;
end

endmodule
