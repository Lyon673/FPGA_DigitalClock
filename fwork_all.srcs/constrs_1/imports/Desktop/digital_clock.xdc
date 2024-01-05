# Clock Signal
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_34 Sch=sysclk_125mhz

#BTN
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { rst }];
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { BTN[1] }];
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports { BTN[2] }];
set_property -dict { PACKAGE_PIN Y6    IOSTANDARD LVCMOS33 } [get_ports { BTN[3] }];

# Seven Segment Display
set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { sel[0] }]; #IO_L11P_T1_SRCC_34 Sch=sseg_an[0]
set_property -dict { PACKAGE_PIN H20   IOSTANDARD LVCMOS33 } [get_ports { sel[1] }]; #IO_L19N_T3_VREF_35 Sch=sseg_an[1]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { sel[2] }]; #IO_L7P_T1_34 Sch=sseg_an[2]
set_property -dict { PACKAGE_PIN J20   IOSTANDARD LVCMOS33 } [get_ports { sel[3] }]; #IO_L9P_T1_DQS_34 Sch=sseg_an[3]
set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS33 } [get_ports { seg[0] }]; #IO_L19P_T3_35 Sch=sseg_ca
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { seg[1] }]; #IO_0_35 Sch=sseg_cb
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { seg[2] }]; #IO_L7N_T1_34 Sch=sseg_cc
set_property -dict { PACKAGE_PIN K21   IOSTANDARD LVCMOS33 } [get_ports { seg[3] }]; #IO_L9N_T1_DQS_34 Sch=sseg_cd
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { seg[4] }]; #IO_L13N_T2_MRCC_34 Sch=sseg_ce
set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { seg[5] }]; #IO_25_35 Sch=sseg_cf
set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { seg[6] }]; #IO_L12N_T1_MRCC_34 Sch=sseg_cg
set_property -dict { PACKAGE_PIN K20   IOSTANDARD LVCMOS33 } [get_ports { seg[7] }]; #IO_L11N_T1_SRCC_34 Sch=sseg_dp

#leds
set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN Y8    IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN V7    IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN W7    IOSTANDARD LVCMOS33 } [get_ports { led[3] }];
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { led[4] }];
set_property -dict { PACKAGE_PIN W12   IOSTANDARD LVCMOS33 } [get_ports { led[5] }];
set_property -dict { PACKAGE_PIN W11   IOSTANDARD LVCMOS33 } [get_ports { led[6] }];
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports { led[7] }];


#Switch
set_property -dict { PACKAGE_PIN T6    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN T4    IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN V4    IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];
set_property -dict { PACKAGE_PIN W8    IOSTANDARD LVCMOS33 } [get_ports { sw[4] }];
set_property -dict { PACKAGE_PIN U9    IOSTANDARD LVCMOS33 } [get_ports { sw[5] }];

#Audio
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { AC_BCLK }];#AC_BCLK
set_property -dict { PACKAGE_PIN L22   IOSTANDARD LVCMOS33 } [get_ports { AC_MCLK }];#AC_MCLK
set_property -dict { PACKAGE_PIN J21   IOSTANDARD LVCMOS33 } [get_ports { AC_MUTEN }];#AC_MUTEN
set_property -dict { PACKAGE_PIN L21   IOSTANDARD LVCMOS33 } [get_ports { AC_PBDAT }];#AC_PBDAT
set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { AC_PBLRC }];#AC_PBLRC
set_property -dict { PACKAGE_PIN J22   IOSTANDARD LVCMOS33 } [get_ports { AC_RECDAT }];#AC_RECDAT
set_property -dict { PACKAGE_PIN C19   IOSTANDARD LVCMOS33 } [get_ports { AC_RECLRC }];#AC_RECLRC
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports { AC_SCL }];#AC_SCL
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { AC_SDA }];#AC_SDA

#UART
set_property -dict { PACKAGE_PIN Y10   IOSTANDARD LVCMOS33 } [get_ports { uart_txd }];#UART_RXD_OUT
set_property -dict { PACKAGE_PIN R6    IOSTANDARD LVCMOS33 } [get_ports { uart_rxd }];#UART_TXD_IN
