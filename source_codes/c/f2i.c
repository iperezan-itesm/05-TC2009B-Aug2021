/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
#include <stdio.h>                       // f2i.c, x86 FPU float to int test
#define Chop_disable_exception \
asm volatile("fldcw _RoundChop_disable_exception")     // write control word
int _RoundChop_disable_exception = 0x1c3f;             // mask exceptions
#define Read_fp_state_word \
asm volatile("fstsw _fp_state_word")                   // read state word
int _fp_state_word;                                    // FPU state
#define Clear_exceptions_of_sw \
asm volatile("fclex")                                  // clear state
int main (void) {
    union {
        int intword;
        float floatword;
    } u;
    int d;
    while (1) {
        fprintf (stderr,"input a float number in hex format: ");
        fscanf (stdin,"%x",&u.intword);                // read an fp number
        Chop_disable_exception;                        // mask exceptions
        Clear_exceptions_of_sw;                        // clear state
        d = u.floatword;                               // f2i
        fprintf (stderr,"f = %08x = %0.6f\n",  u.intword, u.floatword);
        fprintf (stderr,"d = %08x = %08d\n", d, d);    // display integer
        Read_fp_state_word;                            // read FPU state
        fprintf (stderr,"fp_state_word = %04X\n",_fp_state_word);
    }
}
