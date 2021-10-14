      .text
      .data 
list: .word 0,1,2,3,4,5,6,7,8,9,10
      .text
main: ori $t9, $t9,0x10010000 # Immediate
      lw $t0,0($t9)
      lw $t1,4($t9)
      lw $t2,8($t9)
      lw $t3,12($t9)
      lw $t4,16($t9)
      lw $t5,20($t9)
      lw $t6,24($t9)
      lw $t7,28($t9)
      lw $t8,32($t9)    # Displacement t8 = Mem[32+t9]
      sw $t8,($t9)      # Register indirect
      sw $t7,0x10010004 # Absolute (Direct)
      add $t9,$t0,1     # Immediate
      add $t9,$t1,$t1   # Register
      sw $t6,list+8     # ???
#sw = store, transfers data from register to mem
end: j end

