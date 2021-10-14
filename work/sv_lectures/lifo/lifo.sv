module lifo #(parameter LIFO_DEPTH = 8,
              parameter DATA_WIDTH = 8
             )
             (input  logic                  clk,
              input  logic                  asyn_n_rst,
              input  logic                  push,
              input  logic                  pop,
              input  logic [DATA_WIDTH-1:0] data_in,
              output logic [DATA_WIDTH-1:0] data_out,
              output logic                  full,
              output logic                  empty
             );

logic [$clog2(LIFO_DEPTH):0] stack_pointer;
logic [DATA_WIDTH-1:0] lifo_mem [LIFO_DEPTH];

always_ff @ (posedge clk, negedge asyn_n_rst) begin
  if(!asyn_n_rst)begin
    lifo_mem      <= '{default:'0};
    stack_pointer <= '0;
    data_out      <= '0;
  end else begin
    if (push && !full) begin
      lifo_mem[stack_pointer] <= data_in;
      stack_pointer <= stack_pointer + 1'b1;
    end
    else if (pop && !empty) begin
      data_out <= lifo_mem[stack_pointer - 1'b1];
      stack_pointer <= stack_pointer - 1'b1;
    end
  end
end


assign full  = stack_pointer == LIFO_DEPTH;
assign empty = stack_pointer == 0;


endmodule
