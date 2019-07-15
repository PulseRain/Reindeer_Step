/*
###############################################################################
# Copyright (c) 2017, PulseRain Technology LLC 
#
# This program is distributed under a dual license: an open source license, 
# and a commercial license. 
# 
# The open source license under which this program is distributed is the 
# GNU Public License version 3 (GPLv3).
#
# And for those who want to use this program in ways that are incompatible
# with the GPLv3, PulseRain Technology LLC offers commercial license instead.
# Please contact PulseRain Technology LLC (www.pulserain.com) for more detail.
#
###############################################################################
*/


`ifndef I2C_SVH
`define I2C_SVH

`include "config.vh"

    parameter int I2C_CSR_ADDR_SYNC_RESET_INDEX         = 0;
    parameter int I2C_CSR_ADDR_START1_STOP0_BIT_INDEX   = 1;
    parameter int I2C_CSR_ADDR_R1W0_BIT_INDEX           = 2;
    parameter int I2C_CSR_ADDR_MASTER1_SLAVE0_BIT_INDEX = 3;
    parameter int I2C_CSR_ADDR_RESTART_BIT_INDEX        = 4;
   
    parameter int I2C_CSR_ADDR_IRQ_ENABLE_BIT_INDEX     = 7;
    
    
    
    parameter int I2C_DATA_LEN = 8;
    parameter unsigned [4 : 0] I2C_10BIT_LEADING_PATTERN = 5'b11110;
    
    parameter int I2C_STANDARD_DIV_FACTOR = `MCU_MAIN_CLK_RATE / 100000;

    parameter int I2C_SLAVE_ADDR_LENGTH = 7;

 
`endif
