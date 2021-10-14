// ==============================================
// addsub
// Module for adding/subtracting two numbers
// ==============================================
module addsub #(parameter DATA_WIDTH = 32)
               (input  logic [DATA_WIDTH-1:0] a,   // operand a
                input  logic [DATA_WIDTH-1:0] b,   // operand b
                input  logic                  sub, // add/!sub selector
                output logic [DATA_WIDTH-1:0] sum, // addition output
                output logic                  cout // carry out
               );

// Internal signals
logic [DATA_WIDTH:0] total_sum;         // cout and sum together
logic [DATA_WIDTH:0] a_sign_extended;   // sign extension for a
logic [DATA_WIDTH:0] b_sign_extended;   // sign extension for b

always_comb begin
    a_sign_extended = {a[DATA_WIDTH-1],a};     // extend a
    b_sign_extended = {b[DATA_WIDTH-1],b};     // extend b
    
    total_sum = a_sign_extended + (b_sign_extended ^ {(DATA_WIDTH+1){sub}}) + sub; // add/sub
    
    cout = total_sum[DATA_WIDTH];
    sum = total_sum[DATA_WIDTH-1:0];
end


endmodule
