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
`include "I2C.svh"


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
    // Interrupt
    //=======================================================================
        output  logic                                       int_gen,
    
    //=======================================================================
    // UART
    //=======================================================================
        input wire                                          RXD,
        output wire                                         TXD,
        
            
    //=======================================================================
    // GPIO
    //=======================================================================
        output logic unsigned [`NUM_OF_GPIOS - 1 : 0]       gpio_out,
        input  wire  unsigned [`NUM_OF_GPIOS - 1 : 0]       gpio_in,
        
    //=======================================================================
    // I2C
    //=======================================================================
        
        input wire                                          sda_in, 
        input wire                                          scl_in,
        
        output wire                                         sda_out,
        output wire                                         scl_out
        
);

    //=======================================================================
    // signals
    //=======================================================================
       
        //-------------------------------------------------------------------
        //  UART TX
        //-------------------------------------------------------------------
            wire                                        start_TX;
            wire [7 : 0]                                tx_data;
            wire                                        tx_active;
        
        //-------------------------------------------------------------------
        //  UART RX
        //-------------------------------------------------------------------
            wire                                        uart_rx_fifo_read_req;
            wire                                        uart_rx_enable_out;
            wire [`UART_DEFAULT_DATA_LEN - 1 : 0]       uart_rx_data_out;
            wire                                        uart_rx_fifo_full;
            wire                                        uart_rx_fifo_not_empty;
            wire                                        uart_rx_sync_reset;
        
        //-------------------------------------------------------------------
        //  External interrupt
        //-------------------------------------------------------------------
            logic unsigned [`NUM_OF_INTx - 1 : 0]       INTx_meta;
            logic unsigned [`NUM_OF_INTx - 1 : 0]       INTx_stable;
            
            wire                                        ext_int_active;
            
            logic unsigned [`XLEN - 1 : 0]              int_enable;
            
            // round robin mask
            logic unsigned [`NUM_OF_INTx : 0]           int_mask = (`NUM_OF_INTx)'(1);
            
        //-------------------------------------------------------------------
        //  GPIO
        //-------------------------------------------------------------------
            logic unsigned [`NUM_OF_GPIOS - 1 : 0]       gpio_in_meta;
            logic unsigned [`NUM_OF_GPIOS - 1 : 0]       gpio_in_stable;
            
        //-------------------------------------------------------------------
        //  I2C
        //-------------------------------------------------------------------
            wire unsigned [I2C_DATA_LEN - 1 : 0]         i2c_dat_o;
            
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
                    
                    `UART_RX_ADDR : begin
                        WB_RD_DAT_O <= {1'b0, uart_rx_fifo_full, uart_rx_fifo_not_empty, 1'b0, ((32 - 4 - (`UART_DEFAULT_DATA_LEN))'(0)), uart_rx_data_out};
                    end
                    
                    `INT_SOURCE_ADDR : begin
                        WB_RD_DAT_O <= {INTx_stable & int_mask, (32 - `NUM_OF_TOTAL_INT )'(0),  uart_rx_fifo_not_empty, 1'b0};
                    end
                    
                    `INT_ENABLE_ADDR : 
                        WB_RD_DAT_O <= int_enable;
                    
                    `GPIO_ADDR : begin
                        WB_RD_DAT_O <= gpio_in_stable;
                    end
                    
                    `I2C_CSR_ADDR : begin
                        WB_RD_DAT_O <= i2c_dat_o;
                    end
                    
                    `I2C_DATA_ADDR : begin
                        WB_RD_DAT_O <= i2c_dat_o;
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
        
        UART_TX #(.STABLE_TIME(`UART_STABLE_COUNT), .BAUD_PERIOD_BITS(`UART_BAUD_PERIOD_BITS)) UART_TX_i (
            .clk        (clk),
            .reset_n    (reset_n),
            .sync_reset (sync_reset),
            
            .start_TX (start_TX),
            .baud_rate_period_m1 ((`UART_BAUD_PERIOD_BITS)'(`UART_BAUD_PERIOD - 1)),
            .SBUF_in (tx_data),
            .tx_active (tx_active),
            .TXD (TXD));

        assign start_TX = ((WB_WR_ADR_I == `UART_TX_ADDR) && WB_WR_WE_I) ? 1'b1 : 1'b0;
        assign tx_data = WB_WR_DAT_I [7 : 0];

    //=======================================================================
    // UART RX
    //=======================================================================

        UART_RX_WITH_FIFO #(.STABLE_TIME(`UART_STABLE_COUNT), .BAUD_PERIOD_BITS(`UART_BAUD_PERIOD_BITS), .FIFO_SIZE(`UART_RX_FIFO_SIZE)) UART_RX_i (
                .clk        (clk),
                .reset_n    (reset_n),
                .sync_reset (sync_reset | uart_rx_sync_reset),

                .fifo_read_req (uart_rx_fifo_read_req),
                .enable_out    (uart_rx_enable_out),
                .data_out      (uart_rx_data_out),
                
                .baud_rate_period_m1 ((`UART_BAUD_PERIOD_BITS)'(`UART_BAUD_PERIOD - 1)),
                
                .fifo_full      (uart_rx_fifo_full),
                .fifo_not_empty (uart_rx_fifo_not_empty),
                .RXD            (RXD)
        );

        assign uart_rx_fifo_read_req = ((WB_WR_ADR_I == `UART_RX_ADDR) && WB_WR_WE_I) ? WB_WR_DAT_I[`UART_RX_READ_REQ_BIT] : 1'b0;
        assign uart_rx_sync_reset    = ((WB_WR_ADR_I == `UART_RX_ADDR) && WB_WR_WE_I) ? WB_WR_DAT_I[`UART_RX_SYNC_RESET_BIT] : 1'b0;
     
    
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

        always_ff @(posedge clk, negedge reset_n) begin : gpio_proc
            if (!reset_n) begin
                gpio_in_meta   <= 0;
                gpio_in_stable <= 0;
            end else begin
                gpio_in_meta   <= gpio_in;
                gpio_in_stable <= gpio_in_meta;
            end
        end 
        
    //=======================================================================
    // I2C
    //=======================================================================
        
        wb_I2C #(.REG_ADDR_CSR(`I2C_CSR_ADDR), .REG_ADDR_DATA(`I2C_DATA_ADDR)) wb_I2C_i (.*,
        
            .stb_i (1'b1),
            .we_i (WB_WR_WE_I),
            .adr_wr_i (WB_WR_ADR_I),
            .adr_rd_i (WB_RD_ADR_I),
            .dat_i (WB_WR_DAT_I[I2C_DATA_LEN - 1 : 0]),
            .dat_o (i2c_dat_o),
            .ack_o (),
        
            .sda_in (sda_in),
            .scl_in (scl_in),
            
            .sda_out (sda_out),
            .scl_out (scl_out)
        );

    //=======================================================================
    // Interrupt
    //=======================================================================
        
        assign ext_int_active = |(INTx_stable & int_mask & int_enable[`INT_EXT_INDEX_LAST : `INT_EXT_INDEX_1ST]);
        
        always_ff @(posedge clk, negedge reset_n) begin : int_gen_proc
            if (!reset_n) begin
                int_gen                 <= 0;
                INTx_meta               <= 0;
                INTx_stable             <= 0;
                
                int_enable              <= 0;
                
                int_mask                <= ($size(int_mask))'(1);
                
            end else begin
                INTx_meta <= INTx;
                INTx_stable <= INTx_meta;
                int_gen <= ext_int_active | (uart_rx_fifo_not_empty & int_enable[`INT_UART_RX_INDEX]);
                
                if ((WB_WR_ADR_I == `INT_ENABLE_ADDR) && WB_WR_WE_I) begin
                    int_enable <= WB_WR_DAT_I;
                end
                
                if (((INTx_stable & int_mask) == 0) || ((int_enable[`INT_EXT_INDEX_LAST : `INT_EXT_INDEX_1ST] & int_mask) == 0))  begin
                    int_mask <= {int_mask[0], int_mask[$high(int_mask) : 1]};
                end
                
            end 
        end
        
endmodule : peripherals




`default_nettype wire
