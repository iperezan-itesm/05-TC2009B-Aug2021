# Create library named work
vlib work
# Map work library to current project
vmap work
# Compile source files using SV
vlog -sv traffic_light_pkg.sv tb_traffic_light.sv traffic_light.sv
