/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
#include <stdio.h>                               // display ascii font shape
extern unsigned char Font[][8];                  // 128 - 32 = 96 characters
main() {
    int chars_per_line = 16;                     // fit to book text width
    int char_no;
    unsigned char char_row_bitmap;
    int row, col;
    int i;
    for (char_no = 0; char_no < 96; char_no += chars_per_line) {
        for (row = 0; row < 8; row++) {
            for (i = 0; i < chars_per_line; i++) {
                if ((char_no + i) < 96) {
                    char_row_bitmap = Font[char_no + i][row];
                    for (col = 7; col >= 0; col--) {
                        if (((char_row_bitmap >> col) & 1) == 1) {
                            printf ("O");        // a dot
                        } else {
                            printf (" ");        // blank
                        } 
                    }
                }
            }
            printf ("\n");                       // next row
        }
    }
}
