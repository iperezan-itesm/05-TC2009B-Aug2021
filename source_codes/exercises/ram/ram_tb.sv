// Define simulation scale
`timescale 1ns/100ps

// ========================================
// TESTBENCH MODULE DECLARATION
// ========================================
// There are no I/O ports in testbenches
module ram_tb;

// ========================================
// LOCAL PARAMETERS AND INTERNAL SIGNALS
// ========================================
// Local parameters to be used in testbench
// Note how we change the size of our ram
// without having to re-write our hdl
localparam DATA_WIDTH = 16;
localparam N_WORDS    = 32;

// I/O ports from ram are internal signals in the testbench
logic                       clk;
logic                       we;
logic                       re;
logic [$clog2(N_WORDS)-1:0] address;
logic      [DATA_WIDTH-1:0] data_in;
logic      [DATA_WIDTH-1:0] data_out;
logic      [DATA_WIDTH-1:0] data_out_reference;

// This variable is used for counting output mismatches
// between reference design and your ram
int error_count = 0;

// ========================================
// DESIGNS UNDER TEST INSTANTIATION
// ========================================
// Override parameters from ram_reference_model.sv
// using localparams from the testbench
ram_reference_model #(.DATA_WIDTH(DATA_WIDTH),
                      .N_WORDS(N_WORDS))
// Connect I/O ports from ram to testbench signals
// Notation:
//     .ram_port(testbench_signal)
// Here we used the same names for both I/O ports and local
// signals in the testbench.
// We could also have chosen different names such as:
//     .we(write_enable)
dut_ram_reference (.clk(clk),
                   .we(we),
                   .re(re),
                   .address(address),
                   .data_in(data_in),
                   .data_out(data_out_reference)
                  );

// Instantiate your ram
// Note that we connect the same inputs to both designs
// However, we must use different signals to distinguish each output
ram    #(.DATA_WIDTH(DATA_WIDTH),
         .N_WORDS(N_WORDS))
dut_ram (.clk(clk),
         .we(we),
         .re(re),
         .address(address),
         .data_in(data_in),
         .data_out(data_out)
         );

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

// ========================================
// STIMULUS (INPUTS TO DUTS)
// ========================================
// Drive data into ram
// Initial blocks are executed ONLY once
// These are only used for simulation
// They are NOT meant for initializing memories in RTL
// Note that the following code is executed sequentially
// whitin the intial block
initial begin
    we      = 0;
    re      = 0;
    address = 0;
    data_in = 0;
    #(10*TCLK); // wait 10 clock periods; nothing should happen in ram
    // Fill ram with data
    for(int ram_index=0; ram_index<N_WORDS; ram_index++) begin
	// Write data each clock cycle
        @(posedge clk)begin
            we      <= 1;
            address <= ram_index;
            data_in <= ram_index;
        end
    end
    // Do 100 random writes and reads to/from random addresses
    repeat(100) begin
        @(posedge clk)begin
            we      <= $random;
            re      <= $random;
            address <= $random;
            data_in <= $random;
        end
    end
    // Display whether the test was successful
    if(error_count > 0)begin
        $display("========================================");
        $display("Reference model and ram design do not match");
        $error("There were %0d errors",error_count);
        $display("========================================");
    end
    else begin
        $display("========================================");
        $display("Reference model and ram design match!");
        $display("========================================");
    end
    $stop;
end

// ========================================
// QUICK OUTPUT COMPARISON
// ========================================
// This alwasy block checks whether both ram_reference and ram
// provide the same outputs
always@(data_out_reference, data_out)
    assert (data_out_reference === data_out) else error_count++;

endmodule
