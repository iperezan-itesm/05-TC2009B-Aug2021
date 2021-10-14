/*
 * linked_list.s
 * Shows a linked list:
 * <Value, Pointer>
 * if Pointer == NULL, the list terminates
 */
`define NULL 0x0
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $6,  node1            # address of node0's value
next_node:
    lw    $5,  0($6)            # load the value of the node
    la    $4,  print_format     # address format
    jal   printf                # return to operating system
    lw    $6,  4($6)            # load the linker of the node
    bne   $6,  $0,  next_node   # if != 0, next node
return_to_caller(os):           # exit();
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
node1:                          # a node
    .word  100, node5           # value and link pointer
node2:                          # a node
    .word  200, NULL            # value and terminator
node3:                          # a node
    .word  300, node4           # value and link pointer
node4:                          # a node
    .word  400, node2           # value and link pointer
node5:                          # a node
    .word  500, node3           # value and link pointer
print_format:                   # string address
    .ascii "%d\n"               # string ([enter])
.end
