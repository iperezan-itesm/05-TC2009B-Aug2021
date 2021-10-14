/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/

#include<stdio.h>                  // fmul_test.c, rounding test
#define Near asm volatile("fldcw _RoundNear")
#define Down asm volatile("fldcw _RoundDown")
#define Up   asm volatile("fldcw _RoundUp")
#define Chop asm volatile("fldcw _RoundChop")
int _RoundNear = 0x103f;           // round code = 00 round to nearest
int _RoundDown = 0x143f;           // round code = 01 round toward -infinity
int _RoundUp   = 0x183f;           // round code = 10 round toward +infinity
int _RoundChop = 0x1c3f;           // round code = 11 round toward 0
int main(void){
    union {
        int intword;
        float floatword;
    } u, v, s;
    while (1) {
        fprintf (stderr,"input 1st f_p number in hex format: ");
        fscanf (stdin,"%x",&u.intword);
        fprintf (stderr,"input 2nd f_p number in hex format: ");
        fscanf (stdin,"%x",&v.intword);
        Near;                                      // round to nearest
        s.floatword = u.floatword * v.floatword;
        fprintf (stderr,"the prod of 2 fp numbers is (near): "
                 "%08x\n",s.intword);
        Down;                                      // round toward -infinity
        s.floatword = u.floatword * v.floatword;
        fprintf (stderr,"the prod of 2 fp numbers is (down): "
                 "%08x\n",s.intword);
        Up;                                        // round toward +infinity
        s.floatword = u.floatword * v.floatword;
        fprintf (stderr,"the prod of 2 fp numbers is ( up ): "
                 "%08x\n",s.intword);
        Chop;                                      // round toward 0
        s.floatword = u.floatword * v.floatword;
        fprintf (stderr,"the prod of 2 fp numbers is (chop): "
                 "%08x\n",s.intword);
    }
}
