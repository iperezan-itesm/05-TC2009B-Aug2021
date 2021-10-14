onerror {resume}
vlib work
vmap work
vlog -sv ram.sv tb_ram.sv
vsim work.tb_ram
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Parameters
add wave -noupdate /tb_ram/DATA_WIDTH
add wave -noupdate /tb_ram/N_WORDS
add wave -noupdate -divider {IO ports}
add wave -noupdate /tb_ram/clk
add wave -noupdate /tb_ram/we
add wave -noupdate -radix unsigned /tb_ram/address
add wave -noupdate -radix unsigned /tb_ram/data_in
add wave -noupdate -radix unsigned /tb_ram/data_out
add wave -noupdate -divider Memory
add wave -noupdate -radix unsigned -childformat {{{/tb_ram/dut_ram/ram_mem[0]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[1]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[2]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[3]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[4]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[5]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[6]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[7]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[8]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[9]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[10]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[11]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[12]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[13]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[14]} -radix unsigned} {{/tb_ram/dut_ram/ram_mem[15]} -radix unsigned}} -expand -subitemconfig {{/tb_ram/dut_ram/ram_mem[0]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[1]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[2]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[3]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[4]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[5]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[6]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[7]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[8]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[9]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[10]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[11]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[12]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[13]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[14]} {-radix unsigned} {/tb_ram/dut_ram/ram_mem[15]} {-radix unsigned}} /tb_ram/dut_ram/ram_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53000 ps} 0}
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
WaveRestoreZoom {0 ps} {210 ns}
run 100ns
