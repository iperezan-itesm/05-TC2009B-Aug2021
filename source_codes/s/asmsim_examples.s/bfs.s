/*
 * bfs.s
 * Breadth First Search (BFS):
 * The graph is given in an adjacent (linked) list.
 * The starting node is v1. From v1, we print out all the
 * nodes in the visited order based on the BFS algorithm
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
    la    $4,  g_bgcolor        # draw bfs algorithm
    jal   fillrect              # draw bfs algorithm
    la    $4,  t                # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l0               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l1               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l2               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l3               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l4               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l5               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l6               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l7               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l8               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    la    $4,  l9               # draw bfs algorithm
    jal   drawstring            # draw bfs algorithm
    jal   paint                 # draw bfs algorithm
    ori   $26, $0,   0          # queue read  pointer
    ori   $27, $0,   0          # queue write pointer
    move  $28, $gp              # queue base  pointer
    subi  $28, $28,  256        # queue size = 256 bytes
    la    $4,  v1               # $4 = v1
enqueue_the_first_node(s):
    addi  $27, $27,  4          # queue write pointer
    andi  $27, $27,  0xff       # circulated queue
    add   $25, $27,  $28        # queue write pointer
    sw    $4,  0($25)           # enqueue the node
q_empty?:                       # check the queue status
    beq   $26, $27, return_to_caller(os)   # queue is empty
dequeue:                        # queue is not empty
    addi  $26, $26,  4          # queue read pointer
    andi  $26, $26,  0xff       # circulated queue
    add   $25, $26,  $28        # queue read pointer
    lw    $2,  0($25)           # dequeue the node
    sw    $2,  48($fp)          # store the dequeued node
    lw    $5,  8($2)            # was it visited ?
    bne   $5,  $0,  q_empty?    # yes, go checking queue
the_dequeued_node_was_not_yet_visited:    
    ori   $5,  $0,  1           # mark the node visited
    sw    $5,  8($2)            # store the mark
    lw    $4,  48($fp)          # load the dequeued node
    lw    $5,  0($4)            # for getting node value
    la    $4,  dec              # %d for printing out
    jal   printf                # print the node value
    lw    $4,  48($fp)          # load the dequeued node
check_its_all_adjacents_in_list:
    lw    $4,  4($4)            # load the pointer
    beq   $4,  $0,  q_empty?    # pointer == NULL?
get_a_neighbor:                 # no
    lw    $5,  0($4)            # get the value (a node)
    lw    $6,  8($5)            # was the node visited ?
    bne   $6,  $0,  visited     # yes, check next
enqueue_the_neighbor:           # no
    addi  $27, $27,  4          # queue write pointer
    andi  $27, $27,  0xff       # circulated queue
    add   $25, $27,  $28        # queue write pointer
    sw    $5,  0($25)           # enqueue the node
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
p2:  .word  v4, p3              # value, pointer
p3:  .word  v2, NULL            # value, pointer
v2:  .word  2, p4               # value, pointer
     .word  0                   # visited or not
p4:  .word  v3, p5              # value, pointer
p5:  .word  v5, NULL            # value, pointer
v3:  .word  3, p6               # value, pointer
     .word  0                   # visited or not
p6:  .word  v1, p7              # value, pointer
p7:  .word  v2, p8              # value, pointer
p8:  .word  v5, NULL            # value, pointer
v4:  .word  4, p9               # value, pointer
     .word  0                   # visited or not
p9:  .word  v3, p10             # value, pointer
p10: .word  v5, NULL            # value, pointer
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
    .ascii "Breadth First Search (BFS):"
l0: .word    0xffd000           # color
    .word    25                 # x
    .word    100                # y
    .word    0x020118           # font name_type_size
    .ascii "forall (x in V) visited[x] = false;"
l1: .word    0xffd000           # color
    .word    25                 # x
    .word    140                # y
    .word    0x020118           # font name_type_size
    .ascii "enqueue(s);"
l2: .word    0xffd000           # color
    .word    25                 # x
    .word    180                # y
    .word    0x020118           # font name_type_size
    .ascii "while (!queue_empty()) {"
l3: .word    0xffd000           # color
    .word    25                 # x
    .word    220                # y
    .word    0x020118           # font name_type_size
    .ascii "    x = dequeue();"
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
    .ascii "            if (!visited[w]) enqueue(w);"
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
