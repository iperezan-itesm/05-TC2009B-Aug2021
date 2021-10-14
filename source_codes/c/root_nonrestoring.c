/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
// Non-Restoring Square Root, Copyright by Yamin Li, yamin@ieee.org
#include <stdio.h>                                    // root_nonrestoring.c
unsigned squart(unsigned d, int *remainder) {
    unsigned q = 0;                                   // q: 16-bit root
    int r = 0;                                        // r: 17-bit remainder
    int i;
    for (i = 15; i >= 0; i-- ) {
        printf("%02d: q=%04x ",i,q);
        if (r >= 0) {
            r = ((r << 2) | ((d >> (i+i)) & 3)) - ((q << 2) | 1);    // -q01
            printf("r=((r<<2)|((d>>(i+i))&3))-((q<<2)|1)=%08x ",r);
        } else {
            r = ((r << 2) | ((d >> (i+i)) & 3)) + ((q << 2) | 3);    // +q11
            printf("r=((r<<2)|((d>>(i+i))&3))+((q<<2)|3)=%08x ",r);
        }
        if (r >= 0) {q = (q << 1) | 1; printf("q=q*2+1=%04x\n",q);}
        else        {q = (q << 1) | 0; printf("q=q*2+0=%04x\n",q);}
    }
    if (r < 0) {r = r + ((q << 1) | 1);}              // remainder adjusting
    *remainder = r;                                   // return remainder
    return(q);                                        // return root
}
int main(void){
    unsigned radicand, root;
    int remainder;
    printf("Input an unsigned integer in hex (ex. c0000000): d = ");
    scanf("%x", &radicand);                           // read a radicand
    root = squart(radicand, & remainder);
    printf("hex: q = %08x, r = %08x, d = q*q + r = %08x\n",
            root,remainder,root*root + remainder);
    printf("dec: q = %08d, r = %08d, d = q*q + r = %08u\n",
            root,remainder,root*root + remainder);
}
