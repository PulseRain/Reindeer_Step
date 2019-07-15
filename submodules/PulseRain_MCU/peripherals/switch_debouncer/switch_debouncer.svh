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



`ifndef DEBOUNCER_SVH
`define DEBOUNCER_SVH

extern module switch_debouncer   #(parameter TIMER_VALUE = 100000) (
        
        input wire clk,
        input wire reset_n,                         // reset, active low
        input wire data_in,
        output wire data_out
);

`endif
