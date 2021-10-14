/*
 * hello.s
 * Getting started, prints "Hello, World!" to STDOUT
 * Input: $4: the string address
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 24          # reserve stack space
    sw    $ra, 20($sp)          # save return address
    sw    $fp, 16($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  hello_msg        # hello message address
    jal   printf                # print out message
return_to_caller(os):           # exit()
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 16($sp)          # restore frame pointer
    lw    $ra, 20($sp)          # restore return address
    addi  $sp, $sp, 24          # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
hello_msg:                      # the string address
    .ascii "Hello, World!\n"    # the string
.end
