# Timing constraints
create_clock -period 10.000 -name CK -waveform {0.000 5.000} [get_ports CK]
create_clock -period 999999.938 -name pushbutton -waveform {0.000 499999.969} [get_ports pushbutton]

# layout constraints
set_property PACKAGE_PIN E3 [get_ports CK]
set_property IOSTANDARD LVCMOS33 [get_ports CK]

set_property PACKAGE_PIN T16 [get_ports pushbutton]
set_property IOSTANDARD LVCMOS33 [get_ports pushbutton]

set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sevenseg_out[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes_out[7]}]

set_property PACKAGE_PIN U9 [get_ports {switches[0]}]
set_property PACKAGE_PIN U8 [get_ports {switches[1]}]
set_property PACKAGE_PIN R7 [get_ports {switches[2]}]
set_property PACKAGE_PIN R6 [get_ports {switches[3]}]

set_property PACKAGE_PIN L3 [get_ports {sevenseg_out[0]}]
set_property PACKAGE_PIN N1 [get_ports {sevenseg_out[1]}]
set_property PACKAGE_PIN L5 [get_ports {sevenseg_out[2]}]
set_property PACKAGE_PIN L4 [get_ports {sevenseg_out[3]}]
set_property PACKAGE_PIN K3 [get_ports {sevenseg_out[4]}]
set_property PACKAGE_PIN M2 [get_ports {sevenseg_out[5]}]
set_property PACKAGE_PIN L6 [get_ports {sevenseg_out[6]}]

set_property PACKAGE_PIN N6 [get_ports {anodes_out[0]}]
set_property PACKAGE_PIN M6 [get_ports {anodes_out[1]}]
set_property PACKAGE_PIN M3 [get_ports {anodes_out[2]}]
set_property PACKAGE_PIN N5 [get_ports {anodes_out[3]}]
set_property PACKAGE_PIN N2 [get_ports {anodes_out[4]}]
set_property PACKAGE_PIN N4 [get_ports {anodes_out[5]}]
set_property PACKAGE_PIN L1 [get_ports {anodes_out[6]}]
set_property PACKAGE_PIN M1 [get_ports {anodes_out[7]}]

