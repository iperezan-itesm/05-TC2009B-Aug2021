`timescale 1ns/100ps

module tb_lifo;

localparam  LIFO_DEPTH = 8;
localparam  DATA_WIDTH = 8;

logic                  clk;
logic                  asyn_n_rst;
logic                  push;
logic                  pop;
logic [DATA_WIDTH-1:0] data_in;
logic [DATA_WIDTH-1:0] data_out;
logic                  full;
logic                  empty;



lifo #(.LIFO_DEPTH(LIFO_DEPTH),
       .DATA_WIDTH(DATA_WIDTH)
      )
dut_lifo (.clk(clk),
          .asyn_n_rst(asyn_n_rst),
          .push(push),
          .pop(pop),
          .data_in(data_in),
          .data_out(data_out),
          .full(full),
          .empty(empty)
         );

always begin
  clk = 1'b1;
  #1;
  clk = 1'b0;
  #1;
end

initial begin
  asyn_n_rst = 1'b1;
  #3.4;
  asyn_n_rst = 1'b0;
  #2;
  asyn_n_rst = 1'b1;
end

initial begin
  push = 0;
  pop = 0;
  data_in = 0;
  wait(!asyn_n_rst);
  wait(asyn_n_rst);
  #2.1

  // LIFO full test
  repeat(LIFO_DEPTH+2)
    @(posedge clk)begin
      push    <= 1;
      pop     <= 0;
      data_in <= data_in + 1;
    end
  #10;

  // LIFO empty test
  repeat(LIFO_DEPTH+2)
    @(posedge clk)begin
      push    <= 0;
      pop     <= 1;
      data_in <= data_in + 1;
    end
  #10;
  push    <= 0;
  pop     <= 0;
  data_in <= 0;
  #10;
  // LIFO random tests
  repeat(LIFO_DEPTH*100)
    @(posedge clk)begin
      push    <= ($urandom%100)<=40;
      pop     <= ($urandom%100)<=70;
      data_in <= $random;
    end
  #10;
  $stop;
end

endmodule
