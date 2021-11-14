// Analyse the code and answer the questions

module counter #(parameter N_BITS = 4)
                (input  logic              clk,
                 input  logic              asyn_n_rst
                 output logic [N_BITS-1:0] count
                );

always_ff @ (posedge clk, negedge asyn_n_rst) begin
   // Q: What does the lines 12 to 13 do?
   // A:
    if(!asyn_n_rst)
        count <= 0;
    else
        count <= count + 1'b1


endmodule:counter
