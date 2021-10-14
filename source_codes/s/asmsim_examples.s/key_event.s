/*
 * key_event.s
 * Adds and removes key listener:
 *     key_event_ena(): adds key listener
 *     key_event_dis(): removes key listener
 * If the key listener was added, pressing a key will cause
 * a transfer of control to __Key_Event (exception handler).
 * 
 * When you write codes for __Key_Event, please save all
 * the registers which you will use to the stack and restore
 * them before the return from the exception (eret).
 * 
 * Try to develop your codes for Othello and Tetris games!
 */
.text                           # code segment
main:                           # program entry
    subi  $sp, $sp, 64          # reserve stack space
    sw    $ra, 60($sp)          # save return address
    sw    $fp, 56($sp)          # save frame pointer
    move  $fp, $sp              # new frame pointer
user_main:
    la    $4,  g_sky            # back ground color
    jal   fillrect              # fill rectangle
sun:
    la    $4,  g_sun            # fill a oval parameters
    jal   filloval              # fill a oval
paint1:
    jal   paint                 # paint off-screen buffer
play_msg:
    la    $4,  move_msg         # address of message
    jal   printf                # print out message
your_score_msg:
    la    $4,  score_msg        # address of message
    jal   printf                # print out message
end_msg:
    la    $4,  end_anim_msg     # address of message
    jal   printf                # print out message
init_position:
    la    $8,  x                # address of x_axis
    li    $4,  295              # x = 295 (center)
    sw    $4,  0($8)            # store x
    li    $4,  215              # y = 215 (center)
    sw    $4,  4($8)            # store y
    la    $4,  outside_tag      # address of a tag
    sw    $0,  0($4)            # not outside
are_you_ready?:
    la    $4,  to_start_msg     # address of message
    jal   printf                # print out message
    jal   getarrow              # get an arrow key code
get_timer:
    jal   gettimer              # gettimer
    la    $4,  start_time       # adrress of start_time
    sw    $2,  0($4)            # store start_time
add_key_listener:
    jal   key_event_ena         # enable key event
animate:
    la    $4,  g_sky            # back ground color
    jal   fillrect              # fill rectangle
draw_circles:
    la    $4,  g_ring           # draw a circle
    li    $5,  0xff00           # color =
    sll   $5,  $5,  8           # 0xff0000 (red)
    sw    $5,  0($4)
    li    $5,  295              # x = 295
    sw    $5,  4($4)
    li    $5,  215              # y = 215
    sw    $5,  8($4)
    li    $5,  50               # rx = 50
    sw    $5,  12($4)
    li    $5,  50               # ry = 50
    sw    $5,  16($4)
    li    $6,  0x0303           # color
    sll   $6,  $6,  8           # diff
    jal   drawoval              # draw a oval
    ori   $5,  $5,  0xff00      # color = yellow
next_circle:
    lw    $5,  0($4)            # color =
    sub   $5,  $5,  $6          # color - 0x030300
    sw    $5,  0($4)
    lw    $5,  4($4)            # x =
    subi  $5,  $5,  5           # x - 5
    sw    $5,  4($4)
    lw    $5,  8($4)            # y =
    subi  $5,  $5,  5           # y - 5
    sw    $5,  8($4)
    lw    $5,  12($4)           # rx =
    addi  $5,  $5, 10           # rx + 10
    sw    $5,  12($4)
    lw    $5,  16($4)           # ry =
    addi  $5,  $5, 10           # ry + 10
    sw    $5,  16($4)
    subi  $5,  $5, 800          # if (ry > 800)
    bgez  $5,  draw_line_h      # done
    jal   drawoval              # draw a oval
    j     next_circle           # else
draw_line_h:
    la    $4,  g_drawline_h     # draw a line parameters
    jal   drawline              # draw a line
draw_line_v:
    la    $4,  g_drawline_v     # draw a line parameters
    jal   drawline              # draw a line
sun_anim:
    la    $4,  g_sun            # fill a oval parameters
    jal   filloval              # fill a oval
get_calendar_string:
    la    $4,  g_cals           # for getting cal string
    addi  $4,  $4,  16          # place of ascii
    jal   getcals               # get calendar string
cals_bg:
    la    $4,  g_cals_bg        # back ground color
    jal   fillrect3d            # fill rectangle
show_calendar_while_playing:
    la    $4,  g_cals           # draw the string parameters
    jal   drawstring            # draw the string
score_bg:
    la    $4,  g_score_bg       # back ground color
    jal   fillrect              # fill rectangle
show_score_message:
    la    $4,  g_center         # draw the string parameters
    jal   drawstring            # draw the string
show_score:
    la    $4,  g_i2s            # draw the string parameters
    jal   drawstring            # draw the string
show_timer:
    la    $4,  g_elapsed_s      # draw the string parameters
    jal   drawstring            # draw the string
paint2:
    jal   paint                 # paint off-screen buffer
check_tag:                      # check if sun went outside
    la    $4,  outside_tag      # address of a tag
    lw    $4,  0($4)            # check outside
    bne   $4,  $0,  remove_key_listener
get_a_random_number_x:
    jal   key_event_dis         # disable key event
    li    $4,  5                # a random number 0 -- 4
    jal   getrandom             # get a number 0 <= r <= 4
    subi  $4,  $2,  2           # make it -2 -- +2
    jal   key_event_ena         # enable key event
update_x:
    la    $8,  x                # address of x_axis
    lw    $9,  0($8)            # load x
    add   $9,  $9,  $4          # + r
    sw    $9,  0($8)            # store x
get_a_random_number_y:
    jal   key_event_dis         # disable key event
    li    $4,  5                # a random number 0 -- 4
    jal   getrandom             # get a number 0 <= i <= 4
    subi  $4,  $2,  2           # make it -2 -- +2
    jal   key_event_ena         # enable key event
update_y:
    la    $8,  x                # address of x
    lw    $9,  4($8)            # load y (next to x)
    add   $9,  $9,  $4          # + r
    sw    $9,  4($8)            # store y
calculate_your_score:
    la    $8,  x                # address of x
    lw    $9,  0($8)            # load x
    subi  $9,  $9,  295         # dx = x - 295
    slti  $10, $9,  0           # +: $10 = 0
    beq   $10, $0,  pos_x_d     # is positive
    sub   $9,  $0,  $9          # dx = -dx
pos_x_d:
    slti  $10, $9,  4           # dx >= 4: $10 = 0
    beq   $10, $0, try_next     # no score plus
check_y_diff:
    la    $8,  x                # address of x
    lw    $9,  4($8)            # load y (next to x)
    subi  $9,  $9,  215         # dy = y - 215
    slti  $10, $9,  0           # +: $10 = 0
    beq   $10, $0,  pos_y_d     # is positive
    sub   $9,  $0,  $9          # dy = -dy
pos_y_d:
    slti  $10, $9,  4           # dy >= 4: $10 = 0
    beq   $10, $0, try_next     # no score plus
congratulation:                 # you got it
    la    $6,  score            # addresss of score
    lw    $7,  0($6)            # load score
    addi  $7,  $7, 100          # + 100
    sw    $7,  0($6)            # store score
try_next:
    la    $4,  i2s_addr         # address score string
    la    $5,  dec_format       # convert score to
    la    $6,  score            # score address
    lw    $6,  0($6)            # load score
    jal   sprintf               # integer to string
get_3_random_numbers_for_bg_color_change:
    jal   key_event_dis         # disable key event
    li    $4,  5                # a random number 0 -- 4
    jal   getrandom             # get a number 0 <= r <= 4
    subi  $2,  $2,  2           # make it -2 -- +2
    sll   $20, $2,  16          # $20: r for red color
    jal   getrandom             # get a number 0 <= r <= 4
    subi  $2,  $2,  2           # make it -2 -- +2
    sll   $21, $2,  8           # $21: r for green color
    jal   getrandom             # get a number 0 <= r <= 4
    subi  $22, $2,  2           # $22: r for blue color
    jal   key_event_ena         # enable key event
update_color:                   # 0x00 <--> 0xff may happen
    la    $16, g_sky            # address of bg color
    lw    $19, 0($16)           # load bg color
    add   $17, $19, $20         # change red color
    add   $18, $19, $21         # change green color
    add   $19, $19, $22         # change blue color
    li    $22, 0x0000ff         # blue color position
    sll   $21, $22,  8          # green color position
    sll   $20, $21,  8          # red color position
    and   $20, $20, $17         # clear other than red
    and   $21, $21, $18         # clear other than green
    and   $22, $22, $19         # clear other than blue
    or    $17, $20, $21         # combine red, green
    or    $17, $17, $22         # and blue together
    sw    $17, 0($16)           # store bg color
check_x_up_bound:
    la    $8,  x                # address of x
    lw    $9,  0($8)            # load x
    slti  $9,  $9,  640         # x >= 640: $9 = 0
    beq   $9,  $0,  sun_call_back
check_x_low_bound:
    la    $8,  x                # address of x
    lw    $9,  0($8)            # load x
    slti  $9,  $9,  -50         # x >= -50: $9 = 0
    bne   $9,  $0,  sun_call_back
check_y_up_bound:
    la    $8,  x                # address of x
    lw    $9,  4($8)            # load y (next to x)
    slti  $9,  $9,  480         # y >= 480
    beq   $9,  $0,  sun_call_back
check_y_low_bound:
    la    $8,  x                # address of x
    lw    $9,  4($8)            # load y (next to x)
    slti  $9,  $9,  -50         # y >= -50: $9 = 0
    bne   $9,  $0,  sun_call_back
gettimer_again:
    jal   key_event_dis         # disable key event
    jal   gettimer              # gettimer
    la    $4,  start_time       # adrress of start time
    lw    $3,  0($4)            # load start time
    sub   $2,  $2,  $3          # elapsed time (ms)
    li    $3,  10               # 10, ms -> cs
    div   $2,  $3               # cs in lo
    mflo  $2                    # cs
    la    $4,  timer            # address of timer
    sw    $2,  0($4)            # store timer
    la    $4,  g_elapsed_s      # address of elapsed_s
    addi  $4,  $4,  16          # string address
    la    $5,  dec_format       # convert score to
    move  $6,  $2               # for i2s
    jal   sprintf               # integer to string
    jal   key_event_ena         # enable key event
sleep_after_paint:              # sleep: after paint!
    li    $4,  100              # sleep time (ms)
    jal   sleep                 # do sleep
continue:
    j     animate               # to continue
sun_call_back:
    la    $8,  x                # address of x_axis
    li    $4,  295              # x = 295 (center)
    sw    $4,  0($8)            # store x
    li    $4,  215              # y = 215 (center)
    sw    $4,  4($8)            # store y
    la    $4,  outside_tag      # address of a tag
    li    $5,  1                # outside tag
    sw    $4,  0($4)            # = true
    j     animate               # last show
remove_key_listener:            # animation finished
    jal   key_event_dis         # disable key event
your_points:
    la    $4,  points_msg       # address of a message
    la    $5,  score            # address of score
    lw    $5,  0($5)            # load score
    la    $6,  timer            # address of timer
    lw    $6,  0($6)            # lw timer
    sub   $7,  $5,  $6          # your points
    bgez  $7,  not_bad          # not minus points
    la    $4,  minus_msg        # address of a message
    j     print_points          # to print
not_bad:
    la    $4,  points_msg       # address of a message
print_points:
    jal   printf                # print out message
input_string_msg:
    la    $4,  string_msg       # address of a message
    jal   printf                # print out message
input_string:
    la    $4,  string_format    # for input a string: %s
    la    $5,  user_string      # a place to store string
    jal   scanf                 # input string
draw_inputted_string:
    la    $4,  paint_string     # address of a string
    jal   drawstring            # draw the inputted string
draw_1234:
    la    $4,  g_1234           # address of a string
    jal   drawstring            # draw string
    li    $6,  1                # 1
    sll   $6,  $6, 24           # 1 << 24
    lw    $5,  16($4)           # load '1'
    add   $5,  $5,  $6          # '2'
    sw    $5,  16($4)           # store '2'
    jal   drawstring            # draw string
    lw    $5,  16($4)           # load '1'
    add   $5,  $5,  $6          # '3'
    sw    $5,  16($4)           # store '2'
    jal   drawstring            # draw string
    lw    $5,  16($4)           # load '1'
    add   $5,  $5,  $6          # '4'
    sw    $5,  16($4)           # store '2'
    jal   drawstring            # draw string
get_calendar:
    la    $4,  calendar         # address of calendar
    jal   getcal                # get calendar
print_calendar:
    la    $3,  calendar         # address of calendar
    la    $4,  calendar_msg     # address of parameter
    lw    $5,  0x00($3)         # load month
    lw    $6,  0x04($3)         # load date
    lw    $7,  0x08($3)         # load year
    lw    $2,  0x10($3)         # load hour
    sw    $2,  16($sp)          # put into stack
    lw    $2,  0x14($3)         # load minute
    sw    $2,  20($sp)          # put into stack
    lw    $2,  0x18($3)         # load second
    sw    $2,  24($sp)          # put into stack
    jal   printf                # printf out calendar
    lw    $8,  16($sp)          # get hour
    subi  $6,  $8,  3           # < 4:00
    blez  $6,  draw_good_night
    subi  $6,  $8,  11          # < 12:00
    blez  $6,  draw_good_morning
    subi  $6,  $8,  18          # < 19:00
    blez  $6,  draw_good_afternoon
draw_good_evening:              # < 24:00
    la    $4,  g_evening        # address of a string
    jal   drawstring            # draw good evening
    j     try_yours             # then input your name
draw_good_night:
    la    $4,  g_night          # address of a string
    jal   drawstring            # draw good night
    j     try_yours             # then input your name
draw_good_morning:
    la    $4,  g_morning        # address of a string
    jal   drawstring            # draw good morning
    j     try_yours             # then input your name
draw_good_afternoon:
    la    $4,  g_afternoon      # address of a string
    jal   drawstring            # draw good_afternoon
try_yours:
    la    $4,  g_sky            # address of a string (sky)
    lw    $5,  0($4)            # load sky color
    li    $6,  -1               # 0xffffffff
    xor   $5,  $5,  $6          # invert color
    la    $4,  try_msg          # address of a string (try)
    sw    $5,  0($4)            # as try msg color
    jal   drawstring            # draw the string
paint3:
    jal   paint                 # paint off-screen buffer
return_to_caller(os):
    move  $sp, $fp              # restore stack pointer
    lw    $fp, 56($sp)          # restore frame pointer
    lw    $ra, 60($sp)          # restore return address
    addi  $sp, $sp,  64         # release stack space
    jr    $ra                   # return to operating system
__Key_Event:                    # pre-defined, key event entry
    subi  $sp, $sp, 40          # reserve stack space
    sw    $ra, 36($sp)          # save return address
    sw    $fp, 32($sp)          # save frame pointer
    sw    $3,  28($sp)          # save $3
    sw    $4,  24($sp)          # save $4
    sw    $5,  20($sp)          # save $5
    move  $fp, $sp              # new frame pointer
key_code:
    move  $5,  $2               # key code: arrow_char
    la    $4,  x                # address of x_axis
test_escape:
    li    $3,  0xff00           # escape?
    bne   $3,  $5,  not_esc     # no, check next
is_esc:
    sw    $3,  0($4)            # 0xff00: outside x
    j     return                # return
not_esc:
    li    $3,  0x8100           # left arrow?
    bne   $3,  $5,  not_left    # no, check next
is_left:
    lw    $3,  0($4)            # x_axis
    subi  $3,  $3,  4           # - 4
    sw    $3,  0($4)            # store x_axis
    j     return                # return
not_left:
    li    $3,  0x8300           # right arrow?
    bne   $3,  $5,  not_right   # no, check next
is_right:
    lw    $3,  0($4)            # x_axis
    addi  $3,  $3,  4           # + 4
    sw    $3,  0($4)            # store x_axis
    j     return                # return
not_right:
    li    $3,  0x8000           # up arrow?
    bne   $3,  $5,  not_up      # no, check next
is_up:
    lw    $3,  4($4)            # y_axis
    subi  $3,  $3,  4           # - 4
    sw    $3,  4($4)            # store y_axis
    j     return                # return
not_up:
    li    $3,  0x8200           # down arrow?
    bne   $3,  $5,  return      # no, return
is_down:
    lw    $3,  4($4)            # y_axis
    addi  $3,  $3,  4           # + 4
    sw    $3,  4($4)            # store y_axis
return:
    move  $sp, $fp              # restore stack pointer
    lw    $5,  20($sp)          # restore $5
    lw    $4,  24($sp)          # restore $4
    lw    $3,  28($sp)          # restore $3
    lw    $fp, 32($sp)          # restore frame pointer
    lw    $ra, 36($sp)          # restore return address
    addi  $sp, $sp, 40          # release stack space
    eret                        # return from exception
.data                           # data segment
g_sky:
    .word    0x1f7fdf           # color
    .word    0                  # x
    .word    0                  # y
    .word    640                # w
    .word    480                # h
g_sun:                          # moving
c:  .word    0xff0000           # color
x:  .word    295                # x
y:  .word    215                # y
w:  .word    50                 # w
h:  .word    50                 # h
move_msg:
    .ascii   "Press left, right, up, or down arrow key to move sun\n"
score_msg:
    .ascii   "Try to get score larger than the timer\n"
end_anim_msg:
    .ascii   "Pressing Escape key will terminate the animation\n"
to_start_msg:
    .ascii   "Press an arrow key to start: "
outside_tag:
    .word    0
start_time:
    .word    0
g_ring:                         # ring
    .word    0xffff00           # color
    .word    295                # x
    .word    215                # y
    .word    50                 # w
    .word    50                 # h
g_drawline_h:
    .word    0xff0000           # color
    .word    0                  # x1
    .word    240                # y1
    .word    639                # x2
    .word    240                # y2
g_drawline_v:
    .word    0xff0000           # color
    .word    320                # x1
    .word    0                  # y1
    .word    320                # x2
    .word    479                # y2
g_cals:
    .word    0xe0ffe0           # color
    .word    10                 # x
    .word    20                 # y
    .word    0x020112           # font name_type_size
    .ascii   "Nov 21 2011 Mon 23:46:53"
g_cals_bg:
    .word    0x000000           # color
    .word    5                  # x
    .word    3                  # y
    .word    272                # w
    .word    22                 # h
g_score_bg:
    .word    0x000000           # color
    .word    5                  # x
    .word    453                # y
    .word    630                # w
    .word    22                 # h
g_i2s:
    .word    0xd0ffd0           # color
    .word    280                # x
    .word    470                # y
    .word    0x030112           # font name_type_size
i2s_addr:    .ascii   "2147483647" 
g_1234:
    .word    0xdf0000           # color
    .word    20                 # x
    .word    100                # y
    .word    0x030150           # font name_type_size
    .ascii   "1" 
g_morning:
    .word    0xdf0000           # color
    .word    68                 # x
    .word    100                # y
    .word    0x030136           # font name_type_size
    .ascii   "Good Morning" 
g_afternoon:
    .word    0xdf0000           # color
    .word    68                 # x
    .word    100                # y
    .word    0x030136           # font name_type_size
    .ascii   "Good Afternoon" 
g_evening:
    .word    0xdf0000           # color
    .word    68                 # x
    .word    100                # y
    .word    0x030136           # font name_type_size
    .ascii   "Good Evening" 
g_night:
    .word    0xdf0000           # color
    .word    68                 # x
    .word    100                # y
    .word    0x030136           # font name_type_size
    .ascii   "Good Night" 
g_center:
    .word    0xd0ffd0           # color
    .word    10                 # x
    .word    470                # y
    .word    0x030110           # font name_type_size
    .ascii   "Keep the sun in the center.   Score: "
g_elapsed_s:
    .word    0xd0ffd0           # color
    .word    350                # x
    .word    470                # y
    .word    0x030110           # font name_type_size
    .ascii   "-2147483648" 
score:                          # pointed by score_pointer
    .word    100                # see below
timer:
    .word    0
points_msg:
    .ascii   "You got %d - %d = %d points, congratulations!\n"
minus_msg:
    .ascii   "You got %d - %d = %d points, try again.\n"
string_msg:
    .ascii   "Input your name: "
string_format:
    .ascii   "%s"               # "%s" for string
calendar_msg:
    .asciiz  "%d %d %d %02d:%02d:%02d\n"
dec_format:
    .asciiz  "%d"
calendar:
    .word    0                  # month
    .word    0                  # date
    .word    0                  # year
    .word    0                  # day
    .word    0                  # hour
    .word    0                  # minute
    .word    0                  # second
try_msg:
    .word    0xffff00           # color
    .word    10                 # x
    .word    358                # y
    .word    0x010120           # font name_type_size
    .ascii   "This program finished. Please try yours."
paint_string:
    .word    0xdf0000           # color
    .word    68                 # x
    .word    160                # y
    .word    0x010136           # font name_type_size
user_string:
    .ascii   "                                  "
.end
