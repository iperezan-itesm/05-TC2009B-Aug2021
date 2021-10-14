/************************************************
  The MIPS ASM code shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
.text     0                      # 0: starting address of instruction memory
main:
    ori   $sp, $0, 0x0100        # stack pointer, 256-byte data memory
    lui   $8,  0xc000            # vram space: c0000000 - dfffffff
    lui   $9,  0xa001            # i/o  space: a0000000 - bfffffff
    la    $1,  msg               # address of data
    ori   $4,  $0, 0x0a55        # eeprom address
    ori   $7,  $0, 1 #45            # number of chars = 1 for simulation
write_data:                      # write chars to i2c eeprom
    lw    $6,  0($1)             # 4 bytes (chars)
    srl   $5,  $6, 24            # 1st byte
    jal   write_eeprom           # write the byte to eeprom
    addi  $7,  $7, -1            # counter--
    beq   $7,  $0, w_finished    # if counter is 0, go to w_finished
    addi  $4,  $4,  1            # eeprom addr + 1
    sll   $5,  $6,  8            # 2nd byte
    srl   $5,  $5, 24            # 2nd byte
    jal   write_eeprom           # write the byte to eeprom
    addi  $7,  $7, -1            # counter--
    beq   $7,  $0, w_finished    # if counter is 0, go to w_finished
    addi  $4,  $4,  1            # eeprom addr + 1
    sll   $5,  $6, 16            # 3rd byte
    srl   $5,  $5, 24            # 3rd byte
    jal   write_eeprom           # write the byte to eeprom
    addi  $7,  $7, -1            # counter--
    beq   $7,  $0, w_finished    # if counter is 0, go to w_finished
    addi  $4,  $4,  1            # eeprom addr + 1
    sll   $5,  $6, 24            # 4th byte
    srl   $5,  $5, 24            # 4th byte
    jal   write_eeprom           # write the byte to eeprom
    addi  $7,  $7, -1            # counter--
    beq   $7,  $0, w_finished    # if counter is 0, go to w_finished
    addi  $4,  $4,  1            # eeprom addr + 1
    addi  $1,  $1,  4            # next word
    j     write_data
w_finished:       
    ori   $4,  $0, 0x0a55        # eeprom address
    ori   $7,  $0, 1 #45            # number of chars = 1 for simulation
read_data:       
    jal   read_eeprom            # read a byte from i2c eeprom
    sw    $2,  0($8)             # to display on vga
    addi  $8,  $8,  4            # vram addr + 4
    addi  $4,  $4,  1            # eeprom addr + 1
    addi  $7,  $7, -1            # counter--
    beq   $7,  $0, r_finished    # if counter is 0, go to r_finished
    j     read_data              # continue to read
r_finished:
    j     r_finished             # should return to os
write_eeprom:                    # $4: addr, $5: data
    addi  $sp, $sp, -16          # reserve stack space
    sw    $ra, 12($sp)           # save return address
    sw    $fp, 08($sp)           # save frame pointer
    move  $fp, $sp               # new frame pointer
    jal   write_eeprom_addr      # write eeprom addr
    jal   wait_ready             # wait for ready
    sw    $5,  4($9)             # send byte to store
    jal   wait_ready             # wait for ready
    sw    $0,  12($9)            # send stop bit
    move  $sp, $fp               # restore stack pointer
    lw    $fp, 08($sp)           # restore frame pointer
    lw    $ra, 12($sp)           # restore return address
    addi  $sp, $sp, 16           # release stack space
    jr    $ra                    # return
read_eeprom:                     # $4, addr, $2: data (return value)
    addi  $sp, $sp, -16          # reserve stack space
    sw    $ra, 12($sp)           # save return address
    sw    $fp, 08($sp)           # save frame pointer
    move  $fp, $sp               # new frame pointer
    jal   write_eeprom_addr      # write eeprom addr
    jal   wait_ready             # wait for ready
    sw    $0,  0($9)             # send repeat start bit
    ori   $2,  $0, 0xa1          # i2c eeprom slave addr, read
    jal   wait_ready             # wait for ready
    sw    $2,  4($9)             # send slave address, read
    ori   $2,  $0,  1            # not-ack
    jal   wait_ready             # wait for ready
    sw    $2,  8($9)             # go to RX state, not-ack
    jal   wait_ready             # wait for ready
    lw    $2,  0($9)             # get data of eeprom
    sw    $0,  12($9)            # send stop bit
    move  $sp, $fp               # restore stack pointer
    lw    $fp, 08($sp)           # restore frame pointer
    lw    $ra, 12($sp)           # restore return address
    addi  $sp, $sp, 16           # release stack space
    jr    $ra                    # return
write_eeprom_addr:               # $4: addr, $9: i/o addr
    addi  $sp, $sp, -20          # reserve stack space
    sw    $ra, 16($sp)           # save return address
    sw    $fp, 12($sp)           # save frame pointer
    sw    $6,  08($sp)           # save $6
    sw    $2,  04($sp)           # save $2
    move  $fp, $sp               # new frame pointer
    jal   wait_ready             # wait for ready
send_start:
    sw    $0,  0($9)             # send start bit
    ori   $2,  $0, 0xa0          # i2c eeprom slave addr, w
    jal   wait_ready             # wait for ready
    sw    $2,  4($9)             # send slave address, w
    jal   wait_ready             # wait for ready
    lw    $6,  4($9)             # get i2c status, check ack
    andi  $6,  $6, 0x08          # check rx_ack {0,0,x,0,rx_ack,xxx}
    bne   $6,  $0, send_start    # if received not-ack
    srl   $2,  $4, 8             # high 8-bit eeprom addr
    andi  $2,  $2, 0x0f          # high 4-bit eeprom addr = 0
    sw    $2,  4($9)             # send eeprom high 8-bit addr
    andi  $2,  $4, 0xff          # low 8-bit eeprom addr
    jal   wait_ready             # wait for ready
    sw    $2,  4($9)             # send eeprom low 8-bit addr
    move  $sp, $fp               # restore stack pointer
    lw    $2,  04($sp)           # restore $2
    lw    $6,  08($sp)           # restore $6
    lw    $fp, 12($sp)           # restore frame pointer
    lw    $ra, 16($sp)           # restore return address
    addi  $sp, $sp, 20           # release stack space
    jr    $ra                    # return
wait_ready:                      # wait for ready
    addi  $sp, $sp, -20          # reserve stack space
    sw    $ra, 16($sp)           # save return address
    sw    $fp, 12($sp)           # save frame pointer
    sw    $6,  08($sp)           # save $6
    move  $fp, $sp               # new frame pointer
check_status:
    lw    $6,  4($9)             # get i2c status
    andi  $6,  $6, 0x20          # check ready {0,0,ready,0,x,xxx}
    beq   $6,  $0, check_status  # if not ready, continue to check
    move  $sp, $fp               # restore stack pointer
    lw    $6,  08($sp)           # restore $6
    lw    $fp, 12($sp)           # restore frame pointer
    lw    $ra, 16($sp)           # restore return address
    addi  $sp, $sp, 20           # release stack space
    jr    $ra                    # return
.data     0                      # 0: starting address of data memory
msg:                             # address of ascii characters
    .ascii "Computer Principles and Design in Verilog HDL"
.end
