module dff_async_reset(
                       input  logic clk,
                       input  logic async_reset,
                       input  logic D,
                       output logic Q
                      );

always @ (posedge clk, posedge async_reset) begin
    if(async_reset)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule
