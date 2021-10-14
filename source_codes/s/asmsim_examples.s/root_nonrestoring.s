/************************************************
  The MIPS ASM code shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
/*
// Non-Restoring Square Root, Copyright by Li Yamin, yamin@ieee.org
#include <stdio.h>                                 // root_nonrestoring.c
unsigned squart(unsigned d, int *remainder) {
    unsigned q = 0;                  // q: 16-bit unsigned integer (root)
    int r = 0;                       // r: 17-bit integer (remainder)
    int i;
    for (i = 15; i >= 0; i--) {
        printf("%02d: q=%04x ", i, q);
        if (r >= 0) {
            r = ((r << 2) | ((d >> (i+i)) & 3)) - ((q << 2) | 1); // -q01
            printf("r=((r<<2)|((d>>(i+i))&3))-((q<<2)|1)=%08x ", r);
        } else {
            r = ((r << 2) | ((d >> (i+i)) & 3)) + ((q << 2) | 3); // +q11
            printf("r=((r<<2)|((d>>(i+i))&3))+((q<<2)|3)=%08x ", r);
        }
        if (r >= 0) {q = (q << 1) | 1; printf("q=q*2+1=%04x\n", q);}
        else        {q = (q << 1) | 0; printf("q=q*2+0=%04x\n", q);}
    }
    if (r < 0) {r = r + ((q << 1) | 1);}          // remainder adjusting
    *remainder = r;                               // return remainder
    return(q);                                    // return root
}

int main() {
    unsigned radicand, root;
    int remainder;
    printf("Input an unsigned integer in hex (ex. c0000000): d = ");
    scanf("%x", &radicand);
    root = squart(radicand, & remainder);
    printf("hex: q = %08x, r = %08x, d = q*q + r = %08x\n",
            root, remainder, root * root + remainder);
    printf("dec: q = %08d, r = %08d, d = q*q + r = %u\n",
            root, remainder, root * root + remainder);
}
*/
.data
$LC0:   .ascii  "%02d: q=%04x "
$LC1:   .ascii  "r=((r<<2)|((d>>(i+i))&3))-((q<<2)|1)=%08x "
$LC2:   .ascii  "r=((r<<2)|((d>>(i+i))&3))+((q<<2)|3)=%08x "
$LC3:   .ascii  "q=q*2+1=%04x\n"
$LC4:   .ascii  "q=q*2+0=%04x\n"
$LC5:   .ascii  "Input an unsigned integer in hex (ex. c0000000): d = "
$LC6:   .ascii  "%x"
$LC7:   .ascii  "hex: q = %08x, r = %08x, d = q*q + r = %08x\n"
$LC8:   .ascii  "dec: q = %08d, r = %08d, d = q*q + r = %u\n"
.text
squart: subi  $sp,  $sp,  40     # 
        sw    $19,  28($sp)      # 
        move  $19,  $4           # 
        sw    $20,  32($sp)      # 
        move  $20,  $5           # 
        sw    $17,  20($sp)      # 
        move  $17,  $0           # 
        sw    $16,  16($sp)      # 
        move  $16,  $0           # 
        sw    $18,  24($sp)      # 
        li    $18,  0x0000000f   # 
        sw    $31,  36($sp)      # 
$L5:    la    $4,   $LC0         # 
        move  $5,   $18          # 
        move  $6,   $17          # 
        jal   printf             # 
        bltz  $16,  $L6          # 
        sll   $2,   $16,  2      # 
        sll   $3,   $18,  1      # 
        srl   $3,   $19,  $3     # 
        andi  $3,   $3,   0x0003 # 
        or    $2,   $2,   $3     # 
        sll   $3,   $17,  2      # 
        ori   $3,   $3,   0x0001 # 
        subu  $16,  $2,   $3     # 
        la    $4,   $LC1         # 
        j     $L12               # 
$L6:    sll   $2,   $16,  2      # 
        sll   $3,   $18,  1      # 
        srl   $3,   $19,  $3     # 
        andi  $3,   $3,   0x0003 # 
        or    $2,   $2,   $3     # 
        sll   $3,   $17,  2      # 
        ori   $3,   $3,   0x0003 # 
        addu  $16,  $2,   $3     # 
        la    $4,   $LC2         # 
$L12:   move  $5,   $16          # 
        jal   printf             # 
        bltz  $16,  $L8          # 
        sll   $2,   $17,  1      # 
        ori   $17,  $2,   0x0001 # 
        la    $4,   $LC3         # 
        j     $L13               # 
$L8:    sll   $17,  $17,  1      # 
        la    $4,   $LC4         # 
$L13:   move  $5,   $17          # 
        jal   printf             # 
        subi  $18,  $18,  1      # 
        bgez  $18,  $L5          # 
        bgez  $16,  $L11         # 
        sll   $2,   $17,  1      # 
        ori   $2,   $2,   0x0001 # 
        addu  $16,  $16,  $2     # 
$L11:   sw    $16,  0($20)       # 
        move  $2,   $17          # 
        lw    $31,  36($sp)      # 
        lw    $20,  32($sp)      # 
        lw    $19,  28($sp)      # 
        lw    $18,  24($sp)      # 
        lw    $17,  20($sp)      # 
        lw    $16,  16($sp)      # 
        addi  $sp,  $sp,  40     # 
        jr    $31                # 
main:   subi  $sp,  $sp,  40     # 
        sw    $31,  32($sp)      # 
        sw    $17,  28($sp)      # 
        sw    $16,  24($sp)      # 
        la    $4,   $LC5         # 
        jal   printf             # 
        la    $4,   $LC6         # 
        addi  $5,   $sp,  16     # 
        jal   scanf              # 
        lw    $4,   16($sp)      # 
        addi  $5,   $sp,  20     # 
        jal   squart             # 
        move  $16,  $2           # 
        mult  $16,  $16          # 
        mflo  $17                # 
        lw    $7,   20($sp)      # 
        la    $4,   $LC7         # 
        move  $5,   $16          # 
        move  $6,   $7           # 
        addu  $7,   $17,  $7     # 
        jal   printf             # 
        lw    $7,   20($sp)      # 
        la    $4,   $LC8         # 
        move  $5,   $16          # 
        move  $6,   $7           # 
        addu  $7,   $17,  $7     # 
        jal   printf             # 
        lw    $31,  32($sp)      # 
        lw    $17,  28($sp)      # 
        lw    $16,  24($sp)      # 
        addi  $sp,  $sp,  40     # 
        jr    $31                # 
.end
