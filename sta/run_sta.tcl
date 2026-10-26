read_liberty /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog synth/mult_array_synth.v
link_design mult_array
read_sdc sta/constraints.sdc

report_checks -path_delay max -format full_clock_expanded
report_worst_slack -max
report_tns

exit
