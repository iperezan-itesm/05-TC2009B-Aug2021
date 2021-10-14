/*
 * malloc.s
 * Allocates a block of <size> bytes of memory, 
 * returning a pointer to the beginning of the block.
 * Input:  $4: <size> in byte
 * Output: $2: the address of the block
 */
.text                           # code segment
.end
main:                           # program entry
    subu  $sp,  $sp,  40        # reserve stack space
    sw    $ra,  36($sp)         # save return address
    sw    $fp,  32($sp)         # save frame pointer
    move  $fp,  $sp             # new frame pointer
user_main:
    sw    $0,   20($fp)         # head = NULL
    li    $2,   0x00000001      # i = 1
    sw    $2,   24($fp)
next_i:
    lw    $2,   24($fp)         # if
    slt   $3,   $2,  11         # i <= 10
    bne   $3,   $0,  go_on      # go on
    j     loop_ended            # else loop end
go_on:
    li    $4,  0x00000008       # value, next: 2 words
    jal   malloc                # malloc
    sw    $2,   16($fp)         # address in $2
    lw    $2,   16($fp)         # curr = address
    lw    $3,   24($fp)
    sw    $3,   0($2)           # curr->val = i
    lw    $2,   16($fp)
    lw    $3,   20($fp)
    sw    $3,   4($2)           # curr->next = head
    lw    $2,   16($fp)
    sw    $2,   20($fp)         # head = curr
    lw    $3,   24($fp)
    addu  $2,   $3,  1
    move  $3,   $2
    sw    $3,   24($fp)         # i++
    j     next_i                # next i
loop_ended:
    lw    $2,   20($fp)
    sw    $2,   16($fp)         # curr = head
while:
    lw    $2,   16($fp)         # if curr
    bne   $2,   $0,  continue   # != NULL, continue
    j     return_to_caller      # else finish
continue:
    lw    $2,   16($fp)         # printf
    la    $4,   dec_format      # %d
    lw    $5,   0($2)           # curr->value
    jal   printf                # print out value
    lw    $2,   16($fp)
    lw    $3,   4($2)
    sw    $3,   16($fp)         # curr = curr->next
    j     while                 # go to while
return_to_caller:               # return()
    move  $sp,  $fp             # restore stack pointer
    lw    $ra,  36($sp)         # restore return address
    lw    $fp,  32($sp)         # restore frame pointer
    addu  $sp,  $sp,  40        # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
dec_format:
    .ascii    "%d\n"            # %d
