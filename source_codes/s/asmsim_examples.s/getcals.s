/*
 * getcals.s
 * getcals(): gets calendar in string format
 * Input: $4: the address of buffer to store string
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  g_cals           # for getting cal string
    jal   getcals               # get calendar string
    la    $4,  g_cals           # for getting cal string
    jal   printf                # print out message
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
g_cals:
    .ascii   "Dec 03 2011 Sat 23:46:53\n"
.end
