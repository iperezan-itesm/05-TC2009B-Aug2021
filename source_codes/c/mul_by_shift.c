/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
#include <stdio.h>                                    // mul_by_shift.c
unsigned int mul16 (unsigned int x, unsigned int y) { // mul by shift
    unsigned int a, b, c;                             // c = a * b
    unsigned int i;                                   // counter
    a = x;                                            // multiplicand
    b = y;                                            // multiplier
    c = 0;                                            // product
    for (i = 0; i < 16; i++) {                        // for 16 bits
        if ((b & 1) == 1) {                           // LSB of b is 1
            c += a;                                   // c = c + a
        }
        a = a << 1;                                   // shift a 1-bit left
        b = b >> 1;                                   // shift b 1-bit right
    }
    return(c);                                        // return product
}
main() {
    unsigned int x,y;
    fprintf(stderr,"input 1st 16-bit unsigned integer in hex: ");
    fscanf(stdin,"%x",&x);
    fprintf(stderr,"input 2nd 16-bit unsigned integer in hex: ");
    fscanf(stdin,"%x",&y);
    x &= 0xffff;                                      // 16 bits
    y &= 0xffff;                                      // 16 bits
    fprintf(stderr,"%04x * %04x = %08x\n", x, y, mul16(x, y));
}
