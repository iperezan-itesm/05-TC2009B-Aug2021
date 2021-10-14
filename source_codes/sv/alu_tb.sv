`timescale 1ns/100ps
import alu_pkg::*;

module alu_tb;

localparam DATA_WIDTH = 32;
localparam OP_WIDTH   = 4;

alu_data_t a;  // operand a
alu_data_t b;  // operand b
alu_op_t   op; // operation type
alu_data_t r;  // result
logic                  z;  // zero flag

alu #(.DATA_WIDTH(DATA_WIDTH),
      .OP_WIDTH(OP_WIDTH)
     )
dut_alu(.a(a),
        .b(b),
        .op(op),
        .r(r),
        .z(z)
       );

initial begin
    a = 0;
    b = 0;
    op = ADD;
    #10;

    a = 12345;
    b = 54321;
    op = ADD; // We can simply refer to the operation type by its name
    #10;

    a = 54321;
    b = 43210;
    op = SUB;
    #10;


    a = -12345;
    b = -54321;
    op = ADD; // We can simply refer to the operation type by its name
    #10;

    a = -54321;
    b = -43210;
    op = SUB;
    #10;
    
    a = 32'h12345678;
    b = 32'hEDCBA987;
    op = AND;
    #10;

    a = $random;
    b = $random;
    op = OR;
    #10;

    a = $random;
    b = $random;
    op = XOR;
    #10;

    a = $random;
    b = $random;
    op = LUI;
    #10;

    a = $random;
    b = $random;
    op = LLI;
    #10;

    a = 12345;
    b = 2;
    op = SLL;
    #10;

    a = 12345;
    b = 3;
    op = SRL;
    #10;

    a = -12345;
    b = 2;
    op = SLL;
    #10;

    a = -12345;
    b = 3;
    op = SRL;
    #10;

    a = 12345;
    b = 4;
    op = SLA;
    #10;

    a = 12345;
    b = 5;
    op = SRA;
    #10;

    a = -12345;
    b = 4;
    op = SLA;
    #10;

    a = -12345;
    b = 5;
    op = SRA;
    #10;
end
endmodule
