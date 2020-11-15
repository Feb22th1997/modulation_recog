############## NET - IOSTANDARD ################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
#############SPI Configurate Setting############
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
############## clock define#####################
create_clock -period 5.000 [get_ports sys_clk_p]
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
############## key define########################
set_property PACKAGE_PIN T6 [get_ports RESETN]
set_property IOSTANDARD LVCMOS15 [get_ports RESETN]
##############LED define##########################
set_property PACKAGE_PIN B13 [get_ports {a7_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a7_led[0]}]

set_property PACKAGE_PIN C13 [get_ports {a7_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a7_led[1]}]

set_property PACKAGE_PIN D14 [get_ports {a7_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a7_led[2]}]

set_property PACKAGE_PIN D15 [get_ports {a7_led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a7_led[3]}]
############## SD card define#####################
set_property IOSTANDARD LVCMOS33 [get_ports SD_SCK]
set_property PACKAGE_PIN AB12 [get_ports SD_SCK]

set_property IOSTANDARD LVCMOS33 [get_ports SD_CMD]
set_property PACKAGE_PIN AB11 [get_ports SD_CMD]

set_property IOSTANDARD LVCMOS33 [get_ports {SD_DAT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SD_DAT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SD_DAT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SD_DAT[0]}]
set_property PACKAGE_PIN AA13 [get_ports {SD_DAT[0]}]
set_property PACKAGE_PIN AB13 [get_ports {SD_DAT[1]}]
set_property PACKAGE_PIN Y13 [get_ports {SD_DAT[2]}]
set_property PACKAGE_PIN AA14 [get_ports {SD_DAT[3]}]

############## uart define#####################
set_property IOSTANDARD LVCMOS33 [get_ports UART_TX]
set_property PACKAGE_PIN N15 [get_ports UART_TX]







connect_debug_port u_ila_0/probe8 [get_nets [list nolabel_line90/tx_data_ready]]

connect_debug_port u_ila_0/probe11 [get_nets [list nolabel_line162/tx_data_ready]]

connect_debug_port u_ila_0/probe11 [get_nets [list nolabel_line164/tx_data_ready]]

connect_debug_port u_ila_0/probe11 [get_nets [list nolabel_line184/tx_data_ready]]

connect_debug_port u_ila_0/probe13 [get_nets [list nolabel_line186/tx_data_ready]]

