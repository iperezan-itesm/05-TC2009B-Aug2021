/************************************************
  The MIPS ASM code shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
/*
int sum(int *array, int n) {
    int i;
    int total = 0;
    for (i = 0; i < n; i++) {
        total += array[i];
    }
    return(total);
}
int main() {
    int a[] = {1, 2, 3};
    printf ("The sum is %d\n", sum(a, 3));
    return(0);
}
*/
.data                        # data segment
$LC0:                        # address of array a
    .word  1, 2, 3           # elements of array a
$LC1:                        # address of string
    .ascii "The sum is %d\n" # string
.text                        # code segment
sum:                         # entry of subroutine sum
    subi   $sp, $sp, 8       # reserve stack space
    move   $3,  $0           # i = 0
    move   $6,  $0           # total = 0
    blez   $5,  $L3          # goto $L3 if n <= 0
$L5:                         # for loop
    sll    $2,  $3,  2       # i * 4 (4 bytes per word)
    add    $2,  $2,  $4      # base address + i * 4
    lw     $2,  0($2)        # load a[i]
    addi   $3,  $3,  1       # i++
    add    $6,  $6,  $2      # total += a[i]
    bne    $3,  $5,  $L5     # goto $L5 if i != n
$L3:                         # end of loop
    move   $2,  $6           # move total to $2
    addi   $sp, $sp, 8       # release stack space
    jr     $ra               # return from subroutine
main:                        # program entry
    subi   $sp, $sp, 40      # reserve stack space
    sw     $ra, 32($sp)      # save return address
    la     $5,  $LC0         # address of array a
    lw     $2,  0($5)        # load a[0]
    lw     $3,  4($5)        # load a[1]
    lw     $4,  8($5)        # load a[2]
    sw     $2,  16($sp)      # store a[0] to stack
    sw     $3,  20($sp)      # store a[1] to stack
    sw     $4,  24($sp)      # store a[2] to stack
    addi   $4,  $sp, 16      # $4: address of a[0]
    li     $5,  3            # $5: n = 3
    jal    sum               # call subroutine sum
    la     $4,  $LC1         # $4: address of string
    move   $5,  $2           # $5: total
    jal    printf            # call printf
    move   $2,  $0           # return value 0
    lw     $ra, 32($sp)      # restore return address
    addi   $sp, $sp, 40      # release stack space
    jr     $ra               # return to operating system
.end                         # end of program
