/*
###############################################################################
# Copyright (c) 2019, PulseRain Technology LLC 
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
//    PulseRain RV2T is a MCU core of Von Neumann architecture. 
//    Instruction Fetch
//=============================================================================

`include "common.vh"

`default_nettype none

module Reindeer_fetch_instruction (

    //=====================================================================
    // clock and reset
    //=====================================================================
            
        input wire                                          clk,                          
        input wire                                          reset_n,                      
        input wire                                          sync_reset,
    
    
    //=====================================================================
    // interface for the scheduler
    //=====================================================================
        input wire                                          fetch_init,
        input wire [`PC_BITWIDTH - 1 : 0]                   start_addr,

        input wire                                          fetch_next,

        output reg                                          fetch_enable_out,
        output reg [`XLEN - 1 : 0]                          IR_out,
        output reg [`PC_BITWIDTH - 1 : 0]                   PC_out,
    
    //=====================================================================
    // interface to memory controller 
    //=====================================================================

        input wire                                          mem_read_done,
        input wire [`XLEN - 1 : 0]                          mem_data,

        output reg                                          read_mem_enable,
        output reg [`PC_BITWIDTH - 1 : 0]                   read_mem_addr 
);

        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // Signal
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            reg                                             ctl_load_start_addr;
            reg                                             ctl_inc_read_addr;
            reg                                             ctl_read_mem_enable;
            reg                                             read_mem_enable_d1;
            
            reg [`PC_BITWIDTH - 1 : 0]                      PC_out_i;
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // data path
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            //---------------------------------------------------------------------
            // read memory
            //---------------------------------------------------------------------
                always @(posedge clk, negedge reset_n) begin : read_mem_proc
                    if (!reset_n) begin
                        read_mem_enable    <= 0;
                        read_mem_addr      <= 0;
                        read_mem_enable_d1 <= 0;
                    end else begin
                        read_mem_enable    <= ctl_read_mem_enable;
                        read_mem_enable_d1 <= read_mem_enable;
                        
                        if (ctl_load_start_addr) begin
                            read_mem_addr <= start_addr;
                        end else if (ctl_inc_read_addr) begin
                            read_mem_addr <= read_mem_addr + 4;
                        end
                        
                    end
                end
    
            //---------------------------------------------------------------------
            // output 
            //---------------------------------------------------------------------
                always @(posedge clk, negedge reset_n) begin : PC_proc
                    if (!reset_n) begin
                        PC_out <= 0;
                        IR_out <= 0;
                        fetch_enable_out <= 0;
                        PC_out_i <= 0;
                    end else begin
                        fetch_enable_out <= mem_read_done;
                        
                        PC_out <= PC_out_i;
                        
                        if (read_mem_enable) begin
                            PC_out_i <= read_mem_addr;
                        end
                        
                        if (mem_read_done & read_mem_enable_d1) begin
                            IR_out <= mem_data;
                        end
                    end
                end
            
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // FSM
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            localparam S_IDLE = 0, S_FETCH = 1;
            reg [1 : 0] current_state, next_state;
                    
            // Declare states
            always @(posedge clk, negedge reset_n) begin : state_machine_reg
                if (!reset_n) begin
                    current_state <= 0;
                end else if (sync_reset) begin 
                    current_state <= 0;
                end else begin
                    current_state <= next_state;
                end
            end
                
            // FSM main body
            always @(*) begin : state_machine_comb
    
                next_state = 0;
                
                ctl_load_start_addr = 0;
                ctl_read_mem_enable = 0;
                ctl_inc_read_addr   = 0;
                
                case (1'b1) // synthesis parallel_case 
                    
                    current_state[S_IDLE]: begin
                       
                        if (fetch_init) begin
                            ctl_load_start_addr = 1'b1;
                            ctl_read_mem_enable = 1'b1;
                            next_state [S_FETCH] = 1'b1;
                        end else begin
                            next_state [S_IDLE] = 1'b1;
                        end
                        
                    end
                    
                    current_state [S_FETCH] : begin
                        next_state [S_FETCH] = 1'b1;
                        
                        ctl_read_mem_enable = fetch_init | fetch_next;
                        
                        if (fetch_init) begin
                            ctl_load_start_addr = 1'b1;
                        end else if (fetch_next) begin
                            ctl_inc_read_addr = 1'b1;
                        end
                        
                    end
                    
                    default: begin
                        next_state[S_IDLE] = 1'b1;
                    end
                    
                endcase
                  
            end  

endmodule

`default_nettype wire
