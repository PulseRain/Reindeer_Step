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
//      peripherals for Reindeer_Step
//=============================================================================


`include "common.vh"
`include "config.vh"


`default_nettype none
module peripherals (
    //=======================================================================
    // clock / reset
    //=======================================================================
        
        input wire                                          clk,                             // clock input
        input wire                                          reset_n,                         // reset, active low
        input wire                                          sync_reset,
    //=======================================================================
    // Interrupt
    //=======================================================================
                
        input wire  unsigned [`NUM_OF_INTx - 1 : 0]          INTx, // external interrupt 
        
    
    //=======================================================================
    // Wishbone Interface (FASM synchronous RAM dual port model)
    //=======================================================================
        input  wire                                         WB_RD_STB_I,
        input  wire  unsigned [`MM_REG_ADDR_BITS - 1 : 0]   WB_RD_ADR_I,
        output logic unsigned [`XLEN - 1 : 0]               WB_RD_DAT_O,
        output logic                                        WB_RD_ACK_O,
                
        input  wire                                         WB_WR_STB_I,
        input  wire                                         WB_WR_WE_I,
        input  wire unsigned [`XLEN_BYTES - 1 : 0]          WB_WR_SEL_I,
        input  wire unsigned [`MM_REG_ADDR_BITS - 1 : 0]    WB_WR_ADR_I,
        input  wire unsigned [`XLEN - 1 : 0]                WB_WR_DAT_I,
        output logic                                        WB_WR_ACK_O,
        
        
    
    //=======================================================================
    // UART
    //=======================================================================
        input wire                                          RXD,
        output wire                                         TXD,
        
            
    //=======================================================================
    // Debug LED
    //=======================================================================
        output logic unsigned [`NUM_OF_GPIOS - 1 : 0]       gpio_out
  
        
);

    //=======================================================================
    // signals
    //=======================================================================
        wire                                        start_TX;
        wire [7 : 0]                                tx_data;
        wire                                        tx_active;
        
    //=======================================================================
    // write ack
    //=======================================================================
        
        always_ff @(posedge clk, negedge reset_n) begin
            if (!reset_n) begin
                WB_WR_ACK_O <= 0;
                WB_RD_ACK_O <= 0;
            end else begin
                WB_WR_ACK_O <= WB_WR_WE_I;
                WB_RD_ACK_O <= WB_RD_STB_I;
            end
        end


    //=======================================================================
    // output mux
    //=======================================================================
        always_ff @(posedge clk, negedge reset_n) begin : output_data_proc
            if (!reset_n) begin
                WB_RD_DAT_O <= 0;
            end else begin
                case (WB_RD_ADR_I) 
                    `UART_TX_ADDR : begin
                        WB_RD_DAT_O <= {tx_active, 31'd0};
                    end
                
                    default : begin
                        WB_RD_DAT_O <= 0;
                    end
                endcase
            end
        end : output_data_proc

    //=======================================================================
    // UART TX
    //=======================================================================

        /* verilator lint_off WIDTH */
        
        UART_TX #(.STABLE_TIME(`UART_STABLE_COUNT), .BAUD_PERIOD_BITS(`UART_TX_BAUD_PERIOD_BITS)) UART_TX_i (
            .clk (clk),
            .reset_n (reset_n),
            .sync_reset (sync_reset),
            
            .start_TX (start_TX),
            .baud_rate_period_m1 ((`UART_TX_BAUD_PERIOD_BITS)'(`UART_TX_BAUD_PERIOD - 1)),
            .SBUF_in (tx_data),
            .tx_active (tx_active),
            .TXD (TXD));

        assign start_TX = ((WB_WR_ADR_I == `UART_TX_ADDR) && WB_WR_WE_I) ? 1'b1 : 1'b0;
        assign tx_data = WB_WR_DAT_I [7 : 0];

    //=======================================================================
    // GPIO
    //=======================================================================
        genvar i;
        
        generate
        
            for (i = 0; i < (`NUM_OF_GPIOS / 8) ; i = i + 1) begin : gen_for
                always_ff @(posedge clk, negedge reset_n) begin : gpio_proc
                    if (!reset_n) begin
                        gpio_out [i * 8 + 7 : i * 8] <= 0;
                    end else if ((WB_WR_ADR_I == `GPIO_ADDR) && WB_WR_WE_I) begin
                        if (WB_WR_SEL_I[i]) begin
                            gpio_out [i * 8 + 7 : i * 8] <= WB_WR_DAT_I [ i * 8 + 7 : i * 8];
                        end
                    end
                end
            end
            
        endgenerate

/*        
        wire [255 : 0 ] acq_data_in;
        assign acq_data_in [31 : 0] = WB_WR_DAT_I;
        assign acq_data_in [34 : 32] = WB_WR_ADR_I;
        assign acq_data_in [35] = WB_WR_WE_I;
        assign acq_data_in [39 : 36] = WB_WR_SEL_I;
        
        assign acq_data_in [255 : 40] = 0;
        
        ocd gpio_stp (
            .acq_clk (clk), 
            .acq_data_in (acq_data_in), 
            .acq_trigger_in ({3'd0, WB_WR_WE_I})
        );
        
*/
        
endmodule : peripherals




`default_nettype wire
