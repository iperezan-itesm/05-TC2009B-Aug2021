/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module shift #(parameter N_bits = 32)
              (input  logic         [N_bits-1:0] d,            // data to be shifted
               input  logic [$clog2(N_bits)-1:0] shift_amount, // shift amount
               input  logic                      right,        // 1: shift right; 0: shift left
               input  logic                      arith,        // 1: arithmetic shift; 0: logical
               output logic         [N_bits-1:0] d_shift       // shifted result
              );                   

always_comb begin
    if (arith) begin    // arithmetic shift
        if(right) begin 
            d_shift = $signed(d) >>> shift_amount;
        end else begin
            d_shift = $signed(d) <<< shift_amount;
        end
    end else begin      // logical shift
        if(right) begin
            d_shift = d >> shift_amount;
        end else begin
            d_shift = d << shift_amount; 
        end
    end 
end
     

/*
always_comb begin                   // always block
    if (right && arith) begin               // if shift left
        d_shift = $signed(d) >>> shift_amount;               //    shift left sa bits
    end
    else if(right && !arith) begin
        d_shift = d >> shift_amount;
    end
    else if (!right && arith) begin
        d_shift = $signed(d) <<< shift_amount; 
    end
    else if (!right && !arith) begin
        d_shift = d << shift_amount;
    end 
end
*/
/*
    always_comb begin                   // always block
        if (!right) begin                         // if shift left
            d_shift = d << shift_amount;          //    shift left sa bits
        end 
        else if (!arith) begin                    // if shift right logical
            d_shift = d >> shift_amount;          //    shift right logical sa bits
        end 
        else begin                                // if shift right arithmetic
            d_shift = $signed(d) >>> shif_amount; //    shift right arithmetic sa bits
        end
    end
*/
endmodule
