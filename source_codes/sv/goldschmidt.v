/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module goldschmidt (a,b,start,clk,clrn,q,busy,ready,count,yn);
    input  [31:0] a;                                  // dividend: .1xxx...x
    input  [31:0] b;                                  // divisor:  .1xxx...x
    input         start;                              // start
    input         clk, clrn;                          // clock and reset
    output [31:0] q;                                  // quotient: x.xxx...x
    output reg    busy;                               // busy
    output reg    ready;                              // ready
    output  [2:0] count;                              // counter
    output [31:0] yn;                                 // .11111...1
    reg    [63:0] reg_a;                              // x.xxxx...x
    reg    [63:0] reg_b;                              // 0.xxxx...x
    reg     [2:0] count;    
    wire   [63:0] two_minus_yi = ~reg_b + 1'b1;       // 1.xxxx...x (2 - yi)
    wire  [127:0] xi = reg_a * two_minus_yi;          // 0x.xxx...x
    wire  [127:0] yi = reg_b * two_minus_yi;          // 0x.xxx...x
    assign        q  = reg_a[63:32] + |reg_a[31:29];  // rounding up
    assign        yn = reg_b[62:31];
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) begin
            busy  <= 0;
            ready <= 0;
        end else begin
            if (start) begin
                reg_a <= {1'b0,a,31'b0};              // 0.1x...x0...0
                reg_b <= {1'b0,b,31'b0};              // 0.1x...x0...0
                busy  <= 1;
                ready <= 0;
                count <= 0;
            end else begin
                reg_a <= xi[126:63];                  // x.xxx...x
                reg_b <= yi[126:63];                  // 0.xxx...x
                count <= count + 3'b1;                // count++
                if (count == 3'h4) begin              // finish
                    busy  <= 0;
                    ready <= 1;                       // q is ready
                end
            end
        end
    end
endmodule
