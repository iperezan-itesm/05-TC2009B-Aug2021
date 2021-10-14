/* Module divide_clk_by_2
   Divides input clock frequency by a factor of 2.
   Inputs:  1-bit clk      - Clock signal
            1-bit an_rst   - Asynchronous, negative active reset
   Outputs: 1-bit clk_div2 - Clock signal divided by 2
*/
// Module declaration

module divide_clk_by_2 (input  logic clk,
                        input  logic asyn_n_rst,
                        output logic Q
								       );

always_ff @ (posedge clk, negedge asyn_n_rst)
    if(!asyn_n_rst)
        Q <= 1'b0;
    else
        Q <= ~Q;

endmodule:divide_clk_by_2
