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

`include "common.vh"
`include "config.vh"

`default_nettype none


module dram_rw_buffer #(parameter BUFFER_SIZE = 4) (

    //=======================================================================
    // clock / reset
    //=======================================================================

        input   wire                                                    clk,
        input   wire                                                    reset_n,
     
    //=======================================================================
    // memory interface in
    //=======================================================================
        
        input wire   [`MEM_ADDR_BITS - 1 : 0]                           dram_mem_addr,
        input wire                                                      dram_mem_read_en,
        input wire                                                      dram_mem_write_en,
        input wire   [`XLEN_BYTES - 1 : 0]                              dram_mem_byte_enable,
        input wire   [`XLEN - 1 : 0]                                    dram_mem_write_data,
        
        
        input  wire                                                     ext_dram_ack,
        input  wire  [`XLEN - 1 : 0]                                    ext_dram_mem_read_data,
                
        output reg   [`MEM_ADDR_BITS - 1 : 0]                           ext_dram_mem_addr,
        output reg                                                      ext_dram_mem_read_en,
        output reg                                                      ext_dram_mem_write_en,
        output wire  [`XLEN_BYTES - 1 : 0]                              ext_dram_mem_byte_enable,
        output wire  [`XLEN - 1 : 0]                                    ext_dram_mem_write_data,
        
        output wire                                                     dram_ack,
        output wire  [`XLEN - 1 : 0]                                    dram_mem_read_data,
        
        output wire                                                     dram_rw_pending
);
    //=======================================================================
    // signal
    //=======================================================================
        reg [`MEM_ADDR_BITS : 0]                            buf_mem [0 : BUFFER_SIZE - 1];
        reg [`MEM_ADDR_BITS : 0]                            mem_dout;
        
        reg [`XLEN - 1 : 0]                                 dram_mem_write_data_reg;
        reg [`XLEN_BYTES - 1 : 0]                           dram_mem_byte_enable_reg;
        
        reg [$clog2(BUFFER_SIZE) - 1 : 0]                   read_addr = 0;
        reg [$clog2(BUFFER_SIZE) - 1 : 0]                   write_addr = 0;
        wire [$clog2(BUFFER_SIZE) - 1 : 0]                  write_addr_next;
        wire                                                buffer_overflow;
        wire [$clog2(BUFFER_SIZE) - 1 : 0]                  buf_cnt;
        reg                                                 dram_active = 0;
        
        reg                                                 ctl_inc_read_addr;
        reg                                                 ctl_inc_read_addr_d1;
        
    //=======================================================================
    // write register
    //=======================================================================
        always @(posedge clk, negedge reset_n) begin
            if (!reset_n) begin
                dram_mem_write_data_reg  <= 0;
                dram_mem_byte_enable_reg <= 0;
            end else if (dram_mem_write_en) begin
                dram_mem_write_data_reg  <= dram_mem_write_data;
                dram_mem_byte_enable_reg <= dram_mem_byte_enable;
            end
        end

        assign ext_dram_mem_byte_enable = dram_mem_byte_enable_reg;
        assign ext_dram_mem_write_data  = dram_mem_write_data_reg;
        
        
    //=======================================================================
    // address buffer
    //=======================================================================
        
        always @(posedge clk) begin
            if (dram_mem_write_en | dram_mem_read_en) begin
                buf_mem [write_addr] <= {dram_mem_write_en, dram_mem_addr};
            end
            
            mem_dout <= buf_mem [read_addr];
        end 
        
        assign dram_ack             = ext_dram_ack;
        assign dram_mem_read_data   = ext_dram_mem_read_data;
        
    //=======================================================================
    // r/w address
    //=======================================================================
        
        assign write_addr_next = write_addr + 1;
        assign buffer_overflow = (write_addr_next == read_addr) ? 1'b1 : 1'b0;
        assign buf_cnt = write_addr - read_addr;
        
        always @(posedge clk, negedge reset_n) begin : write_addr_proc
            if (!reset_n) begin
                write_addr <= 0;
            end else if (dram_mem_write_en | dram_mem_read_en) begin
                write_addr <= write_addr + 1;
            end
        end :  write_addr_proc

        
        always @(posedge clk, negedge reset_n) begin : read_addr_proc 
            if (!reset_n) begin
                read_addr <= 0;
                ctl_inc_read_addr_d1 <= 0;
            end else begin
                
                ctl_inc_read_addr_d1 <= ctl_inc_read_addr;
                    
                if (ctl_inc_read_addr) begin
                    read_addr <= read_addr + 1;
                end
            end 
        end : read_addr_proc
         
        assign dram_rw_pending = (read_addr == write_addr) ? dram_active : 1'b1;
        
    //=======================================================================
    // dram_active
    //=======================================================================
        
        always @(posedge clk, negedge reset_n) begin
            if (!reset_n) begin
                dram_active <= 0;
            end else if (ctl_inc_read_addr) begin
                dram_active <= 1'b1;
            end else if (ext_dram_ack) begin
                dram_active <= 0;
            end
        end
        
    //=======================================================================
    // dram external interface
    //=======================================================================
        always @(posedge clk, negedge reset_n) begin
            if (!reset_n) begin
                ext_dram_mem_addr <= 0;
                ext_dram_mem_write_en <= 0;
                ext_dram_mem_read_en  <= 0;
            end else begin
                ext_dram_mem_addr <= mem_dout [`MEM_ADDR_BITS - 1 : 0];
                if (ctl_inc_read_addr_d1) begin
                    ext_dram_mem_write_en <=  mem_dout [`MEM_ADDR_BITS];
                    ext_dram_mem_read_en  <=  ~mem_dout [`MEM_ADDR_BITS];
                end else begin
                    ext_dram_mem_write_en <= 0;
                    ext_dram_mem_read_en  <= 0;
                end
                                
            end
        end
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // FSM
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        localparam S_IDLE = 0, S_WAIT = 1;
        reg [1 : 0] current_state, next_state;
                
        // Declare states
        always @(posedge clk, negedge reset_n) begin : state_machine_reg
            if (!reset_n) begin
                current_state <= 0;
            end else begin
                current_state <= next_state;
            end
        end
            
        // FSM main body
        always @(*) begin : state_machine_comb

            next_state = 0;
            
            ctl_inc_read_addr = 0;
            
            case (1'b1) // synthesis parallel_case 
                
                current_state[S_IDLE]: begin
                    if (read_addr != write_addr) begin
                        ctl_inc_read_addr = 1'b1;
                        next_state [S_WAIT] = 1'b1;
                    end else begin
                        next_state [S_IDLE] = 1'b1;
                    end
                end
                
                current_state [S_WAIT] : begin
                    
                    if (ext_dram_ack) begin
                        next_state [S_IDLE] = 1'b1;
                    end else begin
                        next_state [S_WAIT] = 1'b1;
                    end
                end
                
                default: begin
                    next_state[S_IDLE] = 1'b1;
                end
                
            endcase
              
        end  

endmodule

`default_nettype wire
