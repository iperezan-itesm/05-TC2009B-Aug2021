/*
 * dfs.s
 * Depth First Search (DFS):
 * The graph is given in an adjacent (linked) list.
 * The starting node is v1. From v1, we print out all the
 * nodes in the visited order based on the DFS algorithm
 * shown in the VGA. You may try to show the queue status and
 * draw the graph dynamically in the VGA. And you may also try
 * to use scanf() and malloc() to build a dynamic adjacent list.
 */
`define NULL 0x0
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    sw    $sp, 52($fp)          # for checking stack empty
    la    $4,  g_bgcolor        # draw dfs algorithm
    jal   fillrect              # draw dfs algorithm
    la    $4,  t                # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l0               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l1               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l2               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l3               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l4               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l5               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l6               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l7               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l8               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    la    $4,  l9               # draw dfs algorithm
    jal   drawstring            # draw dfs algorithm
    jal   paint                 # draw dfs algorithm
    la    $4,  v1               # $4 = v1
push_the_first_node(s):
    sw    $4,  0($sp)           # push the node onto stack
    subi  $sp, $sp,  4          # update $sp
s_empty?:                       # check the stack status
    lw    $4,  52($fp)          # $4: original $sp
    beq   $sp, $4, return_to_caller(os)   # stack is empty
pop:                            # stack is not empty
    addi  $sp, $sp,  4          # update $sp
    lw    $2,  0($sp)           # pop a node from stack
    sw    $2,  48($fp)          # store the popped node
    lw    $5,  8($2)            # was it visited ?
    bne   $5,  $0,  s_empty?    # yes, go checking stack
the_popped_node_was_not_yet_visited:    
    ori   $5,  $0,  1           # mark the node visited
    sw    $5,  8($2)            # store the mark
    lw    $4,  48($fp)          # load the popped node
    lw    $5,  0($4)            # for getting node value
    la    $4,  dec              # %d for printing out
    jal   printf                # print the node value
    lw    $4,  48($fp)          # load the popped node
check_its_all_adjacents_in_list:
    lw    $4,  4($4)            # load the pointer
    beq   $4,  $0,  s_empty?    # pointer == NULL?
get_a_neighbor:                 # no
    lw    $5,  0($4)            # get the value (a node)
    lw    $6,  8($5)            # was the node visited ?
    bne   $6,  $0,  visited     # yes, check next
push_the_neighbor:              # no
    sw    $5,  0($sp)           # push the node onto stack
    subi  $sp, $sp,  4          # update $sp
visited:
    j     check_its_all_adjacents_in_list
return_to_caller(os):           # exit()
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
.data                           # data segment
v1:  .word  1, p1               # value, pointer
     .word  0                   # visited or not
p1:  .word  v1, p2              # value, pointer
p2:  .word  v2, p3              # value, pointer
p3:  .word  v4, NULL            # value, pointer
v2:  .word  2, p4               # value, pointer
     .word  0                   # visited or not
p4:  .word  v5, p5              # value, pointer
p5:  .word  v3, NULL            # value, pointer
v3:  .word  3, p6               # value, pointer
     .word  0                   # visited or not
p6:  .word  v1, p7              # value, pointer
p7:  .word  v2, p8              # value, pointer
p8:  .word  v5, NULL            # value, pointer
v4:  .word  4, p9               # value, pointer
     .word  0                   # visited or not
p9:  .word  v5, p10             # value, pointer
p10: .word  v3, NULL            # value, pointer
v5:  .word  5, p11              # value, pointer
     .word  0                   # visited or not
p11: .word  v4, NULL            # value, pointer
dec: .ascii "v%d\n"
g_bgcolor:
    .word    0x000000           # color
    .word    0                  # x
    .word    0                  # y
    .word    640                # w
    .word    480                # h
t:  .word    0x00d000           # color
    .word    25                 # x
    .word    40                 # y
    .word    0x020118           # font name_type_size
    .ascii "Depth First Search (DFS):"
l0: .word    0xffd000           # color
    .word    25                 # x
    .word    100                # y
    .word    0x020118           # font name_type_size
    .ascii "forall (x in V) visited[x] = false;"
l1: .word    0xffd000           # color
    .word    25                 # x
    .word    140                # y
    .word    0x020118           # font name_type_size
    .ascii "push(s);"
l2: .word    0xffd000           # color
    .word    25                 # x
    .word    180                # y
    .word    0x020118           # font name_type_size
    .ascii "while (!stack_empty()) {"
l3: .word    0xffd000           # color
    .word    25                 # x
    .word    220                # y
    .word    0x020118           # font name_type_size
    .ascii "    x = pop();"
l4: .word    0xffd000           # color
    .word    25                 # x
    .word    260                # y
    .word    0x020118           # font name_type_size
    .ascii "    if (!visited[x]) {"
l5: .word    0xffd000           # color
    .word    25                 # x
    .word    300                # y
    .word    0x020118           # font name_type_size
    .ascii "        visited[x] = true;"
l6: .word    0xffd000           # color
    .word    25                 # x
    .word    340                # y
    .word    0x020118           # font name_type_size
    .ascii "        forall (w in adj[x])"
l7: .word    0xffd000           # color
    .word    25                 # x
    .word    380                # y
    .word    0x020118           # font name_type_size
    .ascii "            if (!visited[w]) push(w);"
l8: .word    0xffd000           # color
    .word    25                 # x
    .word    420                # y
    .word    0x020118           # font name_type_size
    .ascii "    }"
l9: .word    0xffd000           # color
    .word    25                 # x
    .word    460                # y
    .word    0x020118           # font name_type_size
    .ascii "}"
.end
