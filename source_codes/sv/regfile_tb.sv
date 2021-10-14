// Define simulation scale
`timescale 1ns/100ps

// ========================================
// TESTBENCH MODULE DECLARATION
// ========================================
// There are no I/O ports in testbenches
module regfile_tb;

// ========================================
// LOCAL PARAMETERS AND INTERNAL SIGNALS
// ========================================
// Local parameters to be used in testbench
// Note how we change the size of our ram
// without having to re-write our hdl
localparam DATA_WIDTH = 32;
localparam NUM_REGS   = 32;

// I/O ports from register file are internal signals in the testbench
logic                        clk; // clock signal
logic       [DATA_WIDTH-1:0] d;   // data of write port
logic [$clog2(NUM_REGS)-1:0] ra;  // read address a
logic [$clog2(NUM_REGS)-1:0] rb;  // read address b
logic [$clog2(NUM_REGS)-1:0] rd;  // write address 
logic                        we;  // write enable
logic       [DATA_WIDTH-1:0] qa;  // output port for address a 
logic       [DATA_WIDTH-1:0] qb;  // output port for address b


// This variable is used for counting output mismatches
// between reference design and your ram
//int error_count = 0;

// ========================================
// DESIGNS UNDER TEST INSTANTIATION
// ========================================
// Override parameters from ram_reference_model.sv
// using localparams from the testbench
regfile #(.DATA_WIDTH(DATA_WIDTH),
                          .NUM_REGS(NUM_REGS))
// Connect I/O ports from ram to testbench signals
// Notation:
//     .ram_port(testbench_signal)
// Here we used the same names for both I/O ports and local
// signals in the testbench.
// We could also have chosen different names such as:
//     .we(write_enable)
dut_regfile (.clk(clk), // clock signal
             .d(d),   // data of write port
             .ra(ra),  // read address a
             .rb(rb),  // read address b
             .rd(rd),  // write address 
             .we(we),  // write enable
             .qa(qa),  // output port for address a 
             .qb(qb)   // output port for address b
            );

// Instantiate your ram
// Note that we connect the same inputs to both designs
// However, we must use different signals to distinguish each output
// ram    #(.DATA_WIDTH(DATA_WIDTH),
//          .N_WORDS(N_WORDS))
// dut_ram (.clk(clk),
//          .we(we),
//          .re(re),
//          .address(address),
//          .data_in(data_in),
//          .data_out(data_out)
//          );

// ========================================
// STIMULUS (INPUTS TO DUTS)
// ========================================
// Create a clock signal with a period of 10ns
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

// ========================================
// STIMULUS (INPUTS TO DUTS)
// ========================================
// Drive data into regfile
// Initial blocks are executed ONLY once
// These are only used for simulation
// They are NOT meant for initializing memories in RTL
// Note that the following code is executed sequentially
// whitin the intial block
initial begin
    // Do nothing for a while
    we = 0;
    d  = 0;
    ra = 0;
    rb = 0;
    rd = 0;
    ##10; // wait 10 clock cycles

    // Write data into all registers
    for(int reg_index=0; reg_index<=NUM_REGS; reg_index++)begin
        @(posedge clk)begin
            we <= 1;
            d  <= reg_index;
            rd <= reg_index;
        end
    end
    ##1;
    we = 0;
    ##10;

    repeat(100)
        @(posedge clk) begin
            we = $random;
            ra = $random;
            rb = $random;
            d  = $random;
            rd = $random;
        end
    $stop;
end 
    
endmodule
