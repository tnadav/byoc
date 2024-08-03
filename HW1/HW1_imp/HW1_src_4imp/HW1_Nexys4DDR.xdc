# Timing constraints
create_clock -period 10.000 -name CK -waveform {0.000 5.000} [get_ports CK]
create_clock -period 999999.938 -name pushbutton -waveform {0.000 499999.969} [get_ports pushbutton]

# layout constraints
set_property PACKAGE_PIN E3 [get_ports CK]
set_property IOSTANDARD LVCMOS33 [get_ports CK]

set_property PACKAGE_PIN P17 [get_ports pushbutton]
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

set_property PACKAGE_PIN J15 [get_ports {switches[0]}]
set_property PACKAGE_PIN L16 [get_ports {switches[1]}]
set_property PACKAGE_PIN M13 [get_ports {switches[2]}]
set_property PACKAGE_PIN R15 [get_ports {switches[3]}]

set_property PACKAGE_PIN T10 [get_ports {sevenseg_out[0]}]
set_property PACKAGE_PIN R10 [get_ports {sevenseg_out[1]}]
set_property PACKAGE_PIN K16 [get_ports {sevenseg_out[2]}]
set_property PACKAGE_PIN K13 [get_ports {sevenseg_out[3]}]
set_property PACKAGE_PIN L18 [get_ports {sevenseg_out[4]}]
set_property PACKAGE_PIN T11 [get_ports {sevenseg_out[5]}]
set_property PACKAGE_PIN P15 [get_ports {sevenseg_out[6]}]

set_property PACKAGE_PIN J18 [get_ports {anodes_out[0]}]
set_property PACKAGE_PIN J17 [get_ports {anodes_out[1]}]
set_property PACKAGE_PIN T9  [get_ports {anodes_out[2]}]
set_property PACKAGE_PIN J14 [get_ports {anodes_out[3]}]
set_property PACKAGE_PIN P14 [get_ports {anodes_out[4]}]
set_property PACKAGE_PIN T14 [get_ports {anodes_out[5]}]
set_property PACKAGE_PIN K2  [get_ports {anodes_out[6]}]
set_property PACKAGE_PIN U13 [get_ports {anodes_out[7]}]

