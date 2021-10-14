// State machine
always_ff @ (posedge clk) begin:state_reg
    state <= nxt_state;
end:state_reg

always_comb begin:nxt_state_logic
    nxt_state = enable ? START : IDLE;
end:nxt_state_logic

// Counter
always_ff @ (posedge clk) begin:counter
    count <= nxt_count;
end:counter

always_comb begin:nxt_state_logic
    nxt_count = count + 1'b1;
end:nxt_state_logic

