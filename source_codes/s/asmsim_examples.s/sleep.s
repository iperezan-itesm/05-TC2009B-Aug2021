/*
 * sleep.s
 * sleep(): suspends execution for an interval of time
 * Input: $4: interval in ms
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    li    $4,  5                # n = 5
    sw    $4,  52($fp)          # store n to stack
tired:
    la    $4,  message          # address of message
    jal   printf                # print out message
sleeping:
    li    $4,  2000             # sleep time (ms)
    jal   sleep                 # do sleep
woke_up:
    lw    $3,  52($fp)          # load n
    subi  $3,  $3,  1           # n--
    sw    $3,  52($fp)          # store i
    bgtz  $3,  tired            # sleep again
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
message:                        # program entry
    .ascii   "Zzzz...(2s)\n"
.end
