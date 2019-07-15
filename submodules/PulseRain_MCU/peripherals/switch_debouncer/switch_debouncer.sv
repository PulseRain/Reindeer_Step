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


//=============================================================================
// Remarks:
//   switch debouncer (it needs clock input)
//=============================================================================

`include "switch_debouncer.svh"

module switch_debouncer   #(parameter TIMER_VALUE = 100000) (
        
        input wire clk,
        input wire reset_n,                         // reset, active low
        input wire data_in,
        output wire data_out
);
                        
    logic unsigned [$clog2 (TIMER_VALUE) - 1 : 0]   counter;                                    
    
    logic unsigned [3 : 0]                          data_in_sr;
    
    logic                                           data_out_i = 0;
    
    assign data_out = data_out_i;
    
    always_ff   @(posedge clk or negedge reset_n) begin
        if  (!reset_n)  begin
            data_out_i  <=  0;
            counter     <=  0;
            data_in_sr  <=  0;          
        end else begin
            if (data_in_sr [$high (data_in_sr)] != data_in_sr [$high (data_in_sr) - 1]) begin
                counter  <= 0;
                data_out_i <= 0;
            end else if (counter == (TIMER_VALUE - 1)) begin
                data_out_i <=   data_in_sr [$high (data_in_sr)];
            end else begin 
                counter  <= counter + ($size(counter))'(1);
            end
            
            data_in_sr <= {data_in_sr [$high (data_in_sr) - 1 : 0], data_in};
        end
    end

endmodule : switch_debouncer