// State machine
always_ff @ (posedge clk) begin:state_reg
    state <= enable ? START : IDLE;
end:state_reg

// Counter
always_ff @ (posedge clk) begin:counter
    counter <= counter + 1'b1;
end:counter
