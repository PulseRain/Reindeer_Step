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

`include "I2C.svh"

`default_nettype none



module I2C_Master #(parameter CLK_DIV_FACTOR = 1000) ( // For 100MHz clock, 100Mhz / 1000 = 100KHz
        input  wire                             clk,
        input  wire                             reset_n,
        input  wire                             sync_reset,
        
        input  wire                             start,
        input  wire                             stop,
        input  wire                             restart,
        input  wire                             read1_write0,
        
        input  wire [7 : 0]                     addr_or_data_to_write,
        
        input  wire                             addr_or_data_load,
        output logic                            data_request,
        
        
        output logic                                    data_ready,
        
        output logic unsigned [I2C_DATA_LEN - 1 : 0]    data_read_reg,
        
        output logic                            no_ack_flag,
        output logic                            idle_flag,
        
        input  wire                             sda_in,
        input  wire                             scl_in,
        output logic                            sda_out,
        output logic                            scl_out
        
);
    
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Signals
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        logic unsigned [$clog2(I2C_DATA_LEN) - 1 : 0]   sda_counter;
        logic unsigned [I2C_DATA_LEN - 1 : 0]           addr_data_reg;
        
        logic unsigned [3 : 0]                          sda_in_sr;
        logic unsigned [3 : 0]                          scl_in_sr;
        
        
        logic unsigned [$clog2(CLK_DIV_FACTOR) - 1 : 0]     clk_div_counter;
        logic                                               ctl_reset_clk_div_counter;
            
        logic                                               i2c_clk_enable;
        logic                                               scl_rising_pulse;
        logic                                               scl_falling_pulse;
        
        logic                                               scl_out_i;
        logic                                               scl_out_i_d1;
        
        logic                                               r1w0_reg;
        logic                                               addr_10_bit_flag;
        
        logic                                               ctl_i2c_clk_enable;
        logic                                               ctl_i2c_clk_disable;
        logic                                               ctl_set_sda;
        logic                                               ctl_clear_sda;
        logic                                               ctl_load_sda_addr_data;
        
        logic                                               ctl_set_rw_reg;
        logic                                               ctl_clear_rw_reg;
        
        logic                                               ctl_load_sda_counter;
        logic                                               ctl_dec_sda_counter;
        
        logic                                               ctl_shift_addr_data_reg;
        
        logic                                               ctl_raise_data_request;
        logic                                               ctl_clear_data_request;
        logic                                               ctl_clear_addr_10_bit_flag; 
        logic                                               ctl_set_no_ack_flag;
        logic                                               ctl_set_idle_flag;
        logic                                               ctl_data_read_enable;
        
        logic                                               ctl_set_data_ready;
        logic                                               ctl_clear_data_ready;
        logic                                               ctl_scl_suppress;
        
        logic                                               scl_low;
        
        logic                                               data_switch_pulse;
        logic                                               data_read_pulse;
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // SCL generator
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        always_ff @(posedge clk, negedge reset_n) begin : clk_div_proc
            if (!reset_n) begin
                clk_div_counter <= 0;
            end else if (ctl_reset_clk_div_counter || (clk_div_counter == (CLK_DIV_FACTOR / 2 - 1))) begin
                clk_div_counter <= 0;
            end else begin
                clk_div_counter <= clk_div_counter + ($size(clk_div_counter))'(1);
            end
        end : clk_div_proc
          
        always_ff @(posedge clk, negedge reset_n) begin : scl_proc
            if (!reset_n) begin
                scl_out_i    <= 0;
            end else if (sync_reset | start) begin
                scl_out_i    <= 0;
            end else if (clk_div_counter == (CLK_DIV_FACTOR / 2 - 1)) begin
                scl_out_i <= ~scl_out_i;
            end
        end : scl_proc

        always_ff @(posedge clk, negedge reset_n) begin : delay_proc
            if (!reset_n) begin
                scl_out_i_d1 <= 0;
                scl_rising_pulse <= 0;
                scl_falling_pulse <= 0;
                
                scl_out <= 0;
            end else begin
                scl_out_i_d1 <= scl_out_i;
                scl_rising_pulse  <= (~scl_out_i_d1) & scl_out_i;
                scl_falling_pulse <= scl_out_i_d1 & (~scl_out_i);
                
                if (!i2c_clk_enable) begin
                    scl_out <= 1'b1;
                end else begin
                    scl_out <= scl_out_i | ctl_scl_suppress;
                end
            end
        end : delay_proc
        
        always_ff @(posedge clk, negedge reset_n) begin : scl_low_proc
            if (!reset_n) begin
                scl_low <= 0;
            end else if (scl_falling_pulse) begin
                scl_low <= 1'b1;
            end else if (scl_rising_pulse) begin
                scl_low <= 0;
            end
        end : scl_low_proc
        
        always_ff @(posedge clk, negedge reset_n) begin : data_switch_pulse_proc
            if (!reset_n) begin
                data_switch_pulse <= 0;
            end else if (scl_low && (clk_div_counter == (CLK_DIV_FACTOR * 1 / 16 - 1))) begin
                data_switch_pulse <= 1'b1;
            end else begin
                data_switch_pulse <= 0;
            end
        end : data_switch_pulse_proc
        
        always_ff @(posedge clk, negedge reset_n) begin : data_read_pulse_proc
            if (!reset_n) begin
                data_read_pulse <= 0;
            end else if ((!scl_low) && (clk_div_counter == (CLK_DIV_FACTOR * 3/8  - 1))) begin
                data_read_pulse <= 1'b1;
            end else begin
                data_read_pulse <= 0;
            end
            
        end : data_read_pulse_proc
        
            
            
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // i2c_clk_enable
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        always_ff @(posedge clk, negedge reset_n) begin : i2c_clk_enable_proc
            if (!reset_n) begin
                i2c_clk_enable <= 0;
            end else if (ctl_i2c_clk_enable) begin
                i2c_clk_enable <= 1'b1;
            end else if (ctl_i2c_clk_disable) begin
                i2c_clk_enable <= 0;
            end
        end : i2c_clk_enable_proc
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // r1w0_reg
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        always_ff @(posedge clk, negedge reset_n) begin : r1w0_reg_proc
            if (!reset_n) begin
                r1w0_reg <= 0;
            end else if (ctl_set_rw_reg) begin
                r1w0_reg <= 1'b1;
            end else if (ctl_clear_rw_reg) begin
                r1w0_reg <= 0;
            end    
        end : r1w0_reg_proc
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // address / data register
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        always_ff @(posedge clk, negedge reset_n) begin : addr_data_reg_proc
            if (!reset_n) begin
                addr_data_reg <= 0;
            end else if (start) begin 
                addr_data_reg <= {addr_or_data_to_write [$high (addr_data_reg) : 1], read1_write0};
            end else if (addr_or_data_load) begin
                addr_data_reg <= addr_or_data_to_write;
            end else if (ctl_shift_addr_data_reg) begin
                addr_data_reg <= {addr_data_reg [$high (addr_data_reg) - 1 : 0], 1'b1};
            end
        end : addr_data_reg_proc

            
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // 10 bit address
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        always_ff @(posedge clk, negedge reset_n) begin : addr_10_bit_flag_proc
            if (!reset_n) begin
                addr_10_bit_flag <= 0;
            end else if (start | sync_reset) begin
                addr_10_bit_flag <= 0;
                
                if (addr_or_data_to_write [7 : 3] == I2C_10BIT_LEADING_PATTERN) begin
                    addr_10_bit_flag <= 1'b1;
                end 
            end else if (ctl_clear_addr_10_bit_flag) begin
                addr_10_bit_flag <= 0;
            end
            
        end : addr_10_bit_flag_proc
        
            
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // status
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        always_ff @(posedge clk, negedge reset_n) begin : status_flag_proc
            if (!reset_n) begin
                no_ack_flag <= 0;
                idle_flag <= 0;
            end else if (start | sync_reset) begin
                no_ack_flag <= 0;
                idle_flag <= 0;
            end else begin
                if (ctl_set_no_ack_flag) begin
                    no_ack_flag <= 1'b1;
                end
                
                if (ctl_set_idle_flag) begin
                    idle_flag <= 1'b1;
                end
                
            end
        end : status_flag_proc
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // SDA
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        always_ff @(posedge clk, negedge reset_n) begin : sda_proc 
            if (!reset_n) begin
                sda_out <= 0;
            end else begin
                
                case (1'b1) // synthesis parallel_case
                    
                    ctl_set_sda : begin
                        sda_out <= 1'b1;    
                    end
                    
                    ctl_clear_sda : begin
                        sda_out <= 0;
                    end
                    
                    ctl_load_sda_addr_data : begin
                        sda_out <= addr_data_reg [$high (addr_data_reg)];
                    end
                    
                    default : begin
                        
                    end
                    
                endcase
                
            end
        end : sda_proc
        
        
        always_ff @(posedge clk, negedge reset_n) begin : sda_counter_proc
            if (!reset_n) begin
                sda_counter <= 0;
            end else if (sync_reset | start) begin 
                sda_counter <= 0;
            end else if (ctl_load_sda_counter) begin
                sda_counter <= I2C_DATA_LEN - ($size(sda_counter))'(1);
            end else if (ctl_dec_sda_counter) begin
                sda_counter <= sda_counter - ($size(sda_counter))'(1);
            end
        end : sda_counter_proc
        
        always_ff @(posedge clk, negedge reset_n) begin : data_request_proc
            if (!reset_n) begin
                data_request <= 0;
            end else if (addr_or_data_load | ctl_clear_data_request) begin
                data_request <= 0;
            end else if (ctl_raise_data_request) begin
                data_request <= 1'b1;
            end
            
        end : data_request_proc
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // data_read_reg
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        always_ff @(posedge clk, negedge reset_n) begin : sda_in_sr_proc
            if (!reset_n) begin
                sda_in_sr <= 0;
                scl_in_sr <= 0;
            end else begin
                sda_in_sr <= {sda_in_sr[$high(sda_in_sr) - 1 : 0], sda_in};
                scl_in_sr <= {scl_in_sr[$high(scl_in_sr) - 1 : 0], scl_in};
            end
        end : sda_in_sr_proc
            
        
        always_ff @(posedge clk, negedge reset_n) begin : data_read_reg_proc
            if (!reset_n) begin
                data_read_reg <= 0;
            end else if (ctl_data_read_enable | addr_or_data_load) begin
                data_read_reg <= {data_read_reg [$high(data_read_reg) - 1 : 0], sda_in_sr[$high(sda_in_sr)]};
            end
        end : data_read_reg_proc
        
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // data_ready
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        always_ff @(posedge clk, negedge reset_n) begin : data_ready_proc
            if (!reset_n) begin
                data_ready <= 0;
            end else if (ctl_clear_data_ready | addr_or_data_load) begin
                data_ready <= 0;
            end else if (ctl_set_data_ready) begin
                data_ready <= 1'b1;
            end
        end : data_ready_proc
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // FSM
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                
        enum {S_IDLE, S_PRE_START, S_START, S_PRE_SLAVE_ADDR_DATA, S_SLAVE_ADDR_DATA, S_WAIT_ACK, 
              S_CLK_STRETCH, S_READ_SCL_SUPPRESS, S_NEXT, S_PRE_READ, S_READ, S_SEND_ACK, 
              S_PRE_STOP, S_PRE_STOP2, S_STOP} states;
                    
        localparam FSM_NUM_OF_STATES = states.num();
        logic [FSM_NUM_OF_STATES - 1:0] current_state = 0, next_state;
        logic ctl_state_save;
                    
        // Declare states
        always_ff @(posedge clk, negedge reset_n) begin : state_machine_reg
            if (!reset_n) begin
                current_state <= 0;
            end else if (sync_reset) begin
                current_state <= 0;
            end else begin
                current_state <= next_state;
            end
        end : state_machine_reg
                
        // state cast for debug, one-hot translation, enum value can be shown in the simulation in this way
        // Hopefully, synthesizer will optimize out the "states" variable
                
        // synthesis translate_off
        ///////////////////////////////////////////////////////////////////////
        always_comb begin : state_cast_for_debug
            for (int i = 0; i < FSM_NUM_OF_STATES; ++i) begin
                if (current_state[i]) begin
                    $cast(states, i);
                end
            end
        end : state_cast_for_debug
        ///////////////////////////////////////////////////////////////////////
        // synthesis translate_on   
                
        // FSM main body
        always_comb begin : state_machine_comb
    
            next_state = 0;
            
            ctl_reset_clk_div_counter = 0;
                
            ctl_i2c_clk_enable  = 0;
            ctl_i2c_clk_disable = 0;
            
            ctl_set_sda = 0;
            ctl_clear_sda = 0;
            
            ctl_load_sda_addr_data = 0;
            ctl_clear_data_request = 0;
            
            ctl_set_rw_reg = 0;
            ctl_clear_rw_reg = 0;
            
            ctl_load_sda_counter = 0;
            ctl_dec_sda_counter = 0;
            
            ctl_shift_addr_data_reg = 0;
            
            ctl_clear_addr_10_bit_flag = 0;
            
            ctl_set_no_ack_flag = 0;
            ctl_set_idle_flag = 0;
        
            ctl_data_read_enable = 0;
            
            ctl_set_data_ready = 0;
            ctl_clear_data_ready = 0;
            
            ctl_raise_data_request = 0;
            
            ctl_scl_suppress = 0;
            
            case (1'b1) // synthesis parallel_case 
                    
                current_state[S_IDLE]: begin
                    ctl_i2c_clk_disable = 1'b1;
                    ctl_reset_clk_div_counter = 1'b1;
                    
                    ctl_clear_data_request = 1'b1;
                    ctl_set_sda = 1'b1;
                    
                    ctl_clear_data_ready = 1'b1;
                    
                    ctl_set_idle_flag = 1'b1;
                    
                    if (start) begin
                        if (read1_write0) begin
                            ctl_set_rw_reg = 1'b1;
                            next_state [S_PRE_START] = 1'b1;
                        end else begin
                            ctl_clear_rw_reg = 1'b1;
                            next_state [S_PRE_START] = 1'b1;
                        end
                    end else begin
                        next_state [S_IDLE] = 1'b1;
                    end
                end
                
                current_state [S_PRE_START] : begin
                    ctl_set_sda = 1'b1;
                    
                    if (scl_rising_pulse) begin
                        next_state [S_START] = 1'b1;
                    end else begin
                        next_state [S_PRE_START] = 1'b1;
                    end
                    
                end
                
                
                current_state [S_START] : begin
                    
                    ctl_load_sda_counter = 1'b1;
                        
                    if (scl_rising_pulse) begin
                        ctl_clear_sda = 1'b1;
                        ctl_i2c_clk_enable = 1'b1;
                        next_state [S_PRE_SLAVE_ADDR_DATA] = 1'b1;
                    end else begin
                        next_state [S_START] = 1'b1;
                    end
                        
                end
                
                current_state [S_PRE_SLAVE_ADDR_DATA] : begin
                    ctl_load_sda_counter = 1'b1;
                    if (scl_falling_pulse) begin
                        next_state [S_SLAVE_ADDR_DATA] = 1'b1;  
                    end else begin
                        next_state [S_PRE_SLAVE_ADDR_DATA] = 1'b1;
                    end
                end
                
                current_state [S_SLAVE_ADDR_DATA] : begin
                    
                    if (data_switch_pulse) begin
                        ctl_load_sda_addr_data = 1'b1;
                    end
                    
                    if (scl_falling_pulse) begin
                        ctl_dec_sda_counter = 1'b1;
                        
                        if (!sda_counter) begin
                            next_state [S_WAIT_ACK] = 1'b1;
                        end else begin
                            ctl_shift_addr_data_reg = 1'b1;
                            next_state [S_SLAVE_ADDR_DATA] = 1'b1;
                        end
                        
                    end else begin
                        next_state [S_SLAVE_ADDR_DATA] = 1'b1;
                    end
                end
                
                current_state [S_WAIT_ACK] : begin
                    ctl_set_sda = data_switch_pulse;
                    
                    if (data_read_pulse) begin
                        if (sda_in_sr[$high(sda_in_sr)]) begin // no acknowledge
                            ctl_set_no_ack_flag = 1'b1;
                            next_state [S_PRE_STOP] = 1'b1;
                        end else begin
                            ctl_i2c_clk_disable = 1'b1;
                            ctl_raise_data_request = 1'b1;
                            next_state [S_CLK_STRETCH] = 1'b1;    
                        end
                    end else begin
                        next_state [S_WAIT_ACK] = 1'b1;
                    end
                    
                end
                
                    
                current_state [S_CLK_STRETCH] : begin
                    
                    if (data_read_pulse) begin
                        if (scl_in_sr[$high(scl_in_sr)] == 1'b0) begin
                           next_state [S_CLK_STRETCH] = 1'b1;
                        end else begin
                           next_state [S_NEXT] = 1'b1;
                        end
                    end else begin
                        next_state [S_CLK_STRETCH] = 1'b1;
                    end
                    
                end
            
                
                current_state [S_NEXT] : begin
                    
                    ctl_load_sda_counter = 1'b1;
                    ctl_clear_data_ready = 1'b1;
                    ctl_i2c_clk_enable = 1'b1;
                    
                    if (addr_10_bit_flag) begin
                        ctl_clear_addr_10_bit_flag = 1'b1;
                        next_state[S_SLAVE_ADDR_DATA] = 1'b1;
                    end else if (stop) begin
                        next_state [S_PRE_STOP] = 1'b1;    
                    end else if (r1w0_reg) begin
                        next_state [S_PRE_READ] = 1'b1;
                    end else begin
                        next_state [S_PRE_SLAVE_ADDR_DATA] = 1'b1;
                    end
                    
                end
                
                
                current_state [S_PRE_READ] : begin
                    ctl_load_sda_counter = 1'b1;
                    if (scl_falling_pulse) begin
                        next_state [S_READ] = 1'b1;  
                    end else begin
                        next_state [S_PRE_READ] = 1'b1;
                    end
                end
                
                current_state [S_READ] : begin
                    
                    ctl_dec_sda_counter = scl_falling_pulse;
                    ctl_set_sda = 1'b1;
                    
                    if (data_read_pulse) begin
                        
                        if (scl_in_sr[$high(scl_in_sr)]) begin
                            ctl_data_read_enable = 1'b1;
                            
                            if (!sda_counter) begin
                                ctl_set_data_ready = 1'b1;
                                next_state [S_SEND_ACK] = 1'b1;
                            end else begin
                                next_state [S_READ] = 1'b1;
                            end
                        end else begin
                            next_state [S_READ_SCL_SUPPRESS] = 1'b1;
                        end
                    end else begin    
                        next_state [S_READ] = 1'b1;
                    end
                end
                
                current_state [S_READ_SCL_SUPPRESS] : begin
                    ctl_scl_suppress = 1'b1;
                    
                    if (scl_rising_pulse) begin
                        next_state [S_READ] = 1'b1;
                    end else begin
                        next_state [S_READ_SCL_SUPPRESS] = 1'b1;
                    end
                end
      
                current_state [S_SEND_ACK] : begin
                    ctl_clear_sda = ~stop;
                    ctl_set_sda = stop;
                    
                    if (scl_falling_pulse) begin
                        next_state [S_NEXT] = 1'b1;
                    end else begin
                        next_state [S_SEND_ACK] = 1'b1;   
                    end
                    
                end
                
                current_state [S_PRE_STOP] : begin
                    ctl_i2c_clk_enable = 1'b1;
                    
                    ctl_clear_sda = data_switch_pulse & (~restart) & (~r1w0_reg);
                    
                    if (scl_rising_pulse) begin
                        if (!restart) begin
                            next_state [S_PRE_STOP2] = 1'b1;
                        end else begin
                            next_state [S_IDLE] = 1'b1;    
                        end
                    end else begin
                        next_state [S_PRE_STOP] = 1'b1;
                    end
                    
                end
                
                current_state [S_PRE_STOP2] : begin
                    
                    ctl_clear_sda = data_switch_pulse & r1w0_reg;
                    
                    if (!r1w0_reg) begin
                        next_state [S_STOP] = 1'b1;
                    end else if (scl_rising_pulse) begin
                        next_state [S_STOP] = 1'b1;
                    end else begin
                        next_state [S_PRE_STOP2] = 1'b1;
                    end
                    
                end
                
                current_state [S_STOP] : begin
                    ctl_i2c_clk_disable = 1'b1;
                    
                    if (scl_rising_pulse & scl_in_sr[$high(scl_in_sr)]) begin     
                        next_state [S_IDLE] = 1'b1;
                    end else begin
                        next_state [S_STOP] = 1'b1;
                    end
                end
                
                default: begin
                    next_state[S_IDLE] = 1'b1;
                end
                    
            endcase
                  
        end : state_machine_comb
 
endmodule : I2C_Master
       
    
`default_nettype wire
