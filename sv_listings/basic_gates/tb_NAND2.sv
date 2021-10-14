/* Testbench for a 2-input NAND gate */
// Define simulation step
// For this example:
// #1 will result in 1ns delay
// The smallest delay is #0.1 or 100ps
`timescale 1ns/100ps;

// Testbench module name
module tb_NAND2;

// I/O ports from NAND2.sv are internal 
// signals in the testbench.
logic input_A;
logic input_B;
logic output_X;

// Instantiate NAND2 module as our DUT (Desing Under Test)
// Here, we connect the ports from NAND2.sv
// Here, A, B and X are the ports defined in NAND2.sv
// On the other hand, input_A and input_B and output_X
// are our internal signals declared above.
NAND2 dut_NAND2(.A(input_A),.B(input_B),
                .X(output_X)
               );

// Create some stimulus for the NAND2 gate
initial begin
    // Do the same thing 20 times
    repeat(20) begin
        // Drive random bits to NAND2 inputs
        input_A = $random;
        input_B = $random;
        // Simulate a 1ns delay
        #1;
    end
    // Don't let the simulator run indefinitely
    // We force the simulator to stop after driving
    // 20 random inputs into our design.
    $stop;
end

endmodule
