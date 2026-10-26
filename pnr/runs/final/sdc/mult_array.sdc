###############################################################################
# Created by write_sdc
###############################################################################
current_design mult_array
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 7.0000 [get_ports {clk}]
set_clock_uncertainty 0.1000 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {a[0]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {a[1]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {a[2]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {a[3]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {b[0]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {b[1]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {b[2]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {b[3]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[0]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[1]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[2]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[3]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[4]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[5]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[6]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {p[7]}]
set_false_path\
    -from [get_ports {rst_n}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
