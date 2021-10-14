/*
 * recursive.s
 * This example shows the recursive call with Fibonacci Numbers. 
 * A recursive call is one where procedure A calls itself
 * or calls procedure B which then calls procedure A again.
 * The Fibonacci numbers are the numbers in the following sequence:
 * 0,1,1,2,3,5,8,13,21,34,55,89,144,..., i.e. f(n) = f(n-2) + f(n-1)
 */
.text                           # code segment
main:                           # program entry
    subu  $sp,  $sp,  32        # reserve stack space
    sw    $ra,  28($sp)         # save return address
    sw    $fp,  24($sp)         # save frame pointer
    move  $fp,  $sp             # new frame pointer
user_main:                      # f = fib(n) for n: [0, 20]
    li    $2,   -1              # a while guard for inputting n
    sw    $2,   16($fp)         # place for storing n
    la    $4,   what_is_this    # show it is a fibonacci calc.
    jal   printf                # print out
check_n:                        # n: [0, 20] ?
    lw    $2,   16($fp)         # if n
    bltz  $2,   input_n         # < 0, input again
    lw    $2,   16($fp)         # if n
    slt   $3,   $2,  21         # >= 21
    beq   $3,   $0,  input_n    # input again
    j     n_is_ok               # n: [0, 20]
input_n:                        # try to input n
    la    $4,   input_msg       # address of input message
    jal   printf                # print out
    la    $4,   data_format     # in dec format
    addu  $5,   $fp,  16        # place for storing n
    jal   scanf                 # input n
    j     check_n               # to check n
n_is_ok:                        # ready to call
    lw    $4,   16($fp)         # fib(n)
    jal   fib                   # call fib function
    la    $4,   result_msg      # address of result message
    lw    $5,   16($fp)         # n
    move  $6,   $2              # f = fib(n)
    jal   printf                # print out result
return_to_caller(os):           # exit();
    move  $sp,  $fp             # restore stack pointer
    lw    $ra,  28($sp)         # restore return address
    lw    $fp,  24($sp)         # restore frame pointer
    addu  $sp,  $sp,  32        # release stack space
    jr    $ra                   # return to operating system
fib:                            # f = fib(n)function entry
    subu  $sp,  $sp,  32        # reserve stack space
    sw    $ra,  24($sp)         # save return address
    sw    $fp,  20($sp)         # save frame pointer
    sw    $16,  16($sp)         # store f = fib(n - 1)
    move  $fp,  $sp             # new frame pointer
    sw    $4,   32($fp)         # store n
    lw    $2,   32($fp)         # load n
    bne   $2,   $0,  check_1    # if (n != 0) check 1
    li    $2,   0x00000000      # else
    j     return_to_caller      # return(0)
check_1:                        # check if n == 1
    lw    $2,   32($fp)         # if n
    li    $3,   0x00000001      # != 1
    bne   $2,   $3,  go_on      # go on
    li    $2,   0x00000001      # else
    j     return_to_caller      # return(1)
go_on:                          # start recursive call
    lw    $3,   32($fp)         # load n
    subu  $2,   $3,  1          # n - 1
    move  $4,   $2              # fib(n - 1)
    jal   fib                   # recursive call
    move  $16,  $2              # f = fib(n - 1)
    lw    $3,   32($fp)         # n
    subu  $2,   $3,  2          # n - 2
    move  $4,   $2              # fib(n - 2)
    jal   fib                   # recursive call
    addu  $3,   $16,  $2        # fib(n) = fib(n -1) + fib(n - 2)
    move  $2,   $3              # f = fib(n)
return_to_caller:               # return()
    move  $sp,  $fp             # restore stack pointer
    lw    $ra,  24($sp)         # restore return address
    lw    $fp,  20($sp)         # restore frame pointer
    lw    $16,  16($sp)         # restore f = fib(n - 1)
    addu  $sp,  $sp,  32        # release stack space
    jr    $ra                   # return to caller
        
.data                           # data segment
what_is_this:
    .ascii "Calculating Fibonacci number by recursive calls\n"
input_msg:
    .ascii "Input an integer [ 0 - 20 ]: "
data_format:
    .ascii "%d"                 # in dec format
result_msg:
    .ascii "The Fibonacci number of %d is %d\n"
.end
