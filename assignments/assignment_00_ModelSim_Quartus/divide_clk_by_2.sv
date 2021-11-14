// ======================================================================
// Module divide_clk_by_2
//   Divides input clock frequency by a factor of 2.
//   Inputs:  1-bit clk        - Clock signal
//            1-bit asyn_n_rst - Asynchronous, negative active reset
//   Outputs: 1-bit clk_div2   - Clock signal divided by 2
// ======================================================================

// Module declaration
module divide_clk_by_2 (input  logic clk,
                        input  logic asyn_n_rst,
                        output logic clk_div2
                       );

// Sequential logic
always_ff @ (posedge clk, negedge asyn_n_rst) begin
    if(!asyn_n_rst)
        clk_div2 <= 1'b0;
    else
        clk_div2 <= ~clk_div2;
end

//End of module
endmodule:divide_clk_by_2
