/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module div_restoring (a,b,start,clk,clrn,q,r,busy,ready,count);
    input  [31:0] a;                                            // dividend
    input  [15:0] b;                                            // divisor
    input         start;                                        // start
    input         clk, clrn;                                    // clk,reset
    output [31:0] q;                                            // quotient
    output [15:0] r;                                            // remainder
    output reg    busy;                                         // busy
    output reg    ready;                                        // ready
    output  [4:0] count;                                        // counter
    reg    [31:0] reg_q;
    reg    [15:0] reg_r;
    reg    [15:0] reg_b;
    reg     [4:0] count;
    wire   [16:0] sub_out = {reg_r,reg_q[31]} - {1'b0,reg_b};   // sub
    wire   [15:0] mux_out = sub_out[16]?                        // restoring
                  {reg_r[14:0],reg_q[31]} : sub_out[15:0];      // or not
    assign q = reg_q;
    assign r = reg_r;
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            busy  <= 0;
            ready <= 0;
        end else begin 
            if (start) begin
                reg_q <= a;                                     // load a
                reg_b <= b;                                     // load b
                reg_r <= 0;
                busy  <= 1;
                ready <= 0;
                count <= 0;
            end else if (busy) begin
                reg_q <= {reg_q[30:0],~sub_out[16]};            // << 1
                reg_r <= mux_out;
                count <= count + 5'b1;                          // counter++
                if (count == 5'h1f) begin                       // finished
                    busy  <= 0;
                    ready <= 1;                                 // q,r ready
                end
            end
        end
    end
endmodule
