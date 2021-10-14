onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_lifo/LIFO_DEPTH
add wave -noupdate /tb_lifo/DATA_WIDTH
add wave -noupdate /tb_lifo/clk
add wave -noupdate /tb_lifo/asyn_n_rst
add wave -noupdate /tb_lifo/push
add wave -noupdate /tb_lifo/pop
add wave -noupdate -radix decimal /tb_lifo/data_in
add wave -noupdate -radix decimal /tb_lifo/data_out
add wave -noupdate /tb_lifo/full
add wave -noupdate /tb_lifo/empty
add wave -noupdate -radix decimal -childformat {{{/tb_lifo/dut_lifo/lifo_mem[0]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[1]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[2]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[3]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[4]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[5]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[6]} -radix decimal} {{/tb_lifo/dut_lifo/lifo_mem[7]} -radix decimal}} -expand -subitemconfig {{/tb_lifo/dut_lifo/lifo_mem[0]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[1]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[2]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[3]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[4]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[5]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[6]} {-height 15 -radix decimal} {/tb_lifo/dut_lifo/lifo_mem[7]} {-height 15 -radix decimal}} /tb_lifo/dut_lifo/lifo_mem
add wave -noupdate -radix unsigned /tb_lifo/dut_lifo/stack_pointer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1134000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1766100 ps}
