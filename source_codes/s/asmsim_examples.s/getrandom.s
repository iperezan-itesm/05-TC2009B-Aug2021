/*
 * getrandom.s
 * getrandom(): gets a random integer number in [0, <range>)
 * Input: $4: the <range>
 * Output: $2: the number
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    li    $4,  100              # a random number 0 -- 99
    jal   getrandom             # get a number 0 <= r < 100
    la    $4,  a_word           # address of a word
    sw    $2,  0($4)            # restore randow
print_out_the_random_number:
    la    $4,  a_string         # prepare to print out
    la    $6,  a_word           # address of the word
    lw    $5,  0($6)            # load the word
    jal   printf                # print out
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
a_string:                       # the string address
    .ascii "The random number in [0, 100) is %d\n"
a_word:                         # the word address
    .word  0                    # the word
.end
