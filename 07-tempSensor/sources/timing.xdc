set_false_path -from [get_ports {rst_n}] -to [get_pins {rst_n_sync_rec[2]/D}]
set_false_path -from [get_ports {rst_n}] -to [get_pins {rst_n_sync_rec[2]/D}] -hold

set_output_delay -clok sys_clk_pin -max 20 [get_ports {an*}]
set_output_delay -clok sys_clk_pin -max 20 [get_ports {segment*}]
set_output_delay -clok sys_clk_pin -min 0 [get_ports {an*}]
set_output_delay -clok sys_clk_pin -min 0 [get_ports {segment*}]