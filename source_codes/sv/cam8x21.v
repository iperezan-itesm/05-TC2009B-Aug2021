/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module cam8x21 (clk,pattern,wraddress,wren,maddress,mfound);          // cam
    input        clk;            // clock
    input        wren;           // cam write enable
    input [19:0] pattern;        // vpn to be compared to all 8 lines
    input  [2:0] wraddress;      // write address
    output [2:0] maddress;       // matched address
    output       mfound;         // a match was found
    reg   [20:0] ram [0:7];      // ram 8-line * 21-bit: valid (1), vpn (20)
    // write cam, update a line with pattern, valid bit <-- 1
    always @ (posedge clk) begin
        if (wren) ram[wraddress] <= {1'b1,pattern};    // valid, pattern
    end
    // fully associative search, should be implemented with CAM cells
    wire   [7:0] match_line;                           // match line
    assign match_line[7] = (ram[7] == {1'b1,pattern}); // valid, pattern
    assign match_line[6] = (ram[6] == {1'b1,pattern}); // valid, pattern
    assign match_line[5] = (ram[5] == {1'b1,pattern}); // valid, pattern
    assign match_line[4] = (ram[4] == {1'b1,pattern}); // valid, pattern
    assign match_line[3] = (ram[3] == {1'b1,pattern}); // valid, pattern
    assign match_line[2] = (ram[2] == {1'b1,pattern}); // valid, pattern
    assign match_line[1] = (ram[1] == {1'b1,pattern}); // valid, pattern
    assign match_line[0] = (ram[0] == {1'b1,pattern}); // valid, pattern
    assign mfound        = |match_line;                // a match was found
    // encoder for matched address, no multiple-match is allowed
    assign maddress[2] = match_line[7] | match_line[6] |
                         match_line[5] | match_line[4];
    assign maddress[1] = match_line[7] | match_line[6] |
                         match_line[3] | match_line[2];
    assign maddress[0] = match_line[7] | match_line[5] |
                         match_line[3] | match_line[1];
    // initialize cam, mainly clear valid bit of each line
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1)
            ram[i] = 0;
    end
endmodule
