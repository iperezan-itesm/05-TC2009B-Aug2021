/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
#include <stdio.h>  // gen_font_table_v.c, generate font table (verilog HDL)
extern unsigned char Font[][8];
main() {
    unsigned char char_row_bitmap;
    int addr = 0;
    int char_no, i, j;
    printf ("module font_table (a,d);\n");
    printf ("    input  [12:0] a; // 8*8*128=2^3*2^3*2^7\n");
    printf ("    output        d; // font dot\n");
    printf ("    wire          rom [0:8191];\n");
    printf ("    assign        d = rom[a];\n\n");
    for (char_no = 0; char_no < 128; char_no++) {
        for (i = 0; i < 8; i++) {                        // 8 rows per char
            if (char_no >= 0x20) {                       // <space>
                char_row_bitmap = Font[char_no - 0x20][i];
            } else {
                char_row_bitmap = 0;
            }
            for (j = 7; j >= 0; j--) {                   // 8 pixels per row
                printf ("    assign rom[13'h%04x] = ", addr++);
                if (((char_row_bitmap >> j) & 1) == 1) {
                    printf ("1;\n");                     // a dot
                } else {
                    printf ("0;\n");                     // blank
                } 
            }
        }
    }
    printf ("endmodule\n");
}
