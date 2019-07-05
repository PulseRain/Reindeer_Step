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
`include "debug_coprocessor.vh"
`include "config.vh"

`default_nettype none

module step_cyc10 (

    //------------------------------------------------------------------------
    //  clock and reset
    //------------------------------------------------------------------------
    
        input   wire                    osc_in,     
        input   wire                    reset_n,          
        
    //------------------------------------------------------------------------
    //  UART
    //------------------------------------------------------------------------
        
        input   wire                    RXD,
        output  logic                   TXD,
        
    //------------------------------------------------------------------------
    //  3-Axis Digital Accelerometer
    //------------------------------------------------------------------------
        
        output  wire                    ADXL345_SCL,    
        inout   wire                    ADXL345_SDA, 

    //------------------------------------------------------------------------
    //  Single Color LED
    //------------------------------------------------------------------------
        
        output  wire  unsigned [7 : 0]  LED,
    
    //------------------------------------------------------------------------
    //  RGB LED
    //------------------------------------------------------------------------

       // output wire                     REG_LED1_R,
       // output wire                     REG_LED1_G,
       // output wire                     REG_LED1_B,

       // output wire                     REG_LED2_R,
       // output wire                     REG_LED2_G,
       // output wire                     REG_LED2_B,

   //------------------------------------------------------------------------
    //  7 Segment Display
    //------------------------------------------------------------------------
        output  wire                    SEG_DIG1,
        output  wire                    SEG_DIG2,
        output  wire                    SEG_DIG3,
        output  wire                    SEG_DIG4,
        
        output  wire                    SEG_A,
        output  wire                    SEG_B,
        output  wire                    SEG_C,
        output  wire                    SEG_D,
        output  wire                    SEG_E,
        output  wire                    SEG_F,
        output  wire                    SEG_G,
        output  wire                    SEG_DP,
        
    //------------------------------------------------------------------------
    //  SDRAM
    //------------------------------------------------------------------------
        
        output  wire  unsigned [11 : 0] SDRAM_ADDR,     
        output  wire  unsigned [1 : 0]  SDRAM_BA,       
        output  wire                    SDRAM_CAS_N,    
        output  wire                    SDRAM_CKE,       
        output  wire                    SDRAM_CS_N,     
        inout   wire  unsigned [15 : 0] SDRAM_DQ,       
        output  wire  unsigned [1 : 0]  SDRAM_DQM,      
        output  wire                    SDRAM_RAS_N,    
        output  wire                    SDRAM_WE_N,     
        output  wire                    SDRAM_CLK
);

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Signal
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
        wire                                    clk_100MHz;
        wire                                    clk_100MHz_shift;
        wire                                    clk_12MHz;

        wire                                    pll_locked;
                
        wire unsigned [21 : 0]                  sdram_slave_address;
        wire unsigned [1 : 0]                   sdram_slave_byteenable_n;
        wire                                    sdram_slave_chipselect;
        wire unsigned [15 : 0]                  sdram_slave_writedata;
        wire                                    sdram_slave_read_n;
        wire                                    sdram_slave_write_n;
        wire unsigned [15 : 0]                  sdram_slave_readdata;
        wire                                    sdram_slave_waitrequest;
        wire                                    sdram_slave_readdatavalid;
    
        wire                                    uart_tx_ocd;
        wire                                    uart_tx_cpu;
        
        wire                                    ocd_read_enable;
        wire                                    ocd_write_enable;

        wire  [`MEM_ADDR_BITS - 1 : 0]          ocd_rw_addr;
        wire  [`XLEN - 1 : 0]                   ocd_write_word;

        wire                                    ocd_mem_enable_out;
        wire  [`XLEN - 1 : 0]                   ocd_mem_word_out;      

        wire                                    debug_uart_tx_sel_ocd1_cpu0;
        wire                                    cpu_reset;
        wire  [`DEBUG_PRAM_ADDR_WIDTH - 3 : 0]  pram_read_addr;
        wire  [`DEBUG_PRAM_ADDR_WIDTH - 3 : 0]  pram_write_addr;
        
        wire                                    cpu_start;
        wire  [`XLEN - 1 : 0]                   cpu_start_addr;
       
        wire                                    processor_paused;
        
        logic unsigned [1 : 0]                  init_start = 0;
        logic                                   actual_cpu_start;
        logic unsigned [`XLEN - 1 : 0]          actual_start_addr;
        
        
        wire                                    dram_ack;
        wire  [`XLEN - 1 : 0]                   dram_mem_read_data;
        
        wire  [`MEM_ADDR_BITS - 1 : 0]          dram_mem_addr;
        wire                                    dram_mem_read_en;
        wire                                    dram_mem_write_en;
        wire  [`XLEN_BYTES - 1 : 0]             dram_mem_byte_enable;
        wire  [`XLEN - 1 : 0]                   dram_mem_write_data;
        wire  unsigned [`NUM_OF_GPIOS - 1 : 0]  gpio_out;
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // PLL
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        PLL pll_i (
            .areset(~reset_n),
            .inclk0 (osc_in),  // 50MHz clock in
            .c0 (clk_100MHz),
            .c1 (clk_100MHz_shift),
            .c2 (clk_12MHz),
            .locked (pll_locked));
    
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // DDIO
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        DDIO_OUT ddio_out_i (
            .datain_h (1'b1),
            .datain_l (1'b0),
            .outclock (clk_100MHz_shift),
            .dataout (SDRAM_CLK)
        );
        
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // SDRAM, ISSI - IS42S16400J
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            sdram sdram_i (
                    .clk_clk (clk_100MHz),
                    .reset_reset_n (pll_locked),
                    .sdram_addr (SDRAM_ADDR),
                    .sdram_ba (SDRAM_BA),
                    .sdram_cas_n (SDRAM_CAS_N),
                    .sdram_cke (SDRAM_CKE),
                    .sdram_cs_n (SDRAM_CS_N),
                    .sdram_dq (SDRAM_DQ),
                    .sdram_dqm (SDRAM_DQM),
                    .sdram_ras_n (SDRAM_RAS_N),
                    .sdram_we_n (SDRAM_WE_N),

                    .sdram_slave_address (sdram_slave_address),
                    .sdram_slave_byteenable_n (sdram_slave_byteenable_n),
                    .sdram_slave_chipselect (sdram_slave_chipselect),  
                    .sdram_slave_writedata (sdram_slave_writedata),
                    .sdram_slave_read_n (sdram_slave_read_n),
                    .sdram_slave_write_n (sdram_slave_write_n),
                    .sdram_slave_readdata (sdram_slave_readdata),
                    .sdram_slave_readdatavalid (sdram_slave_readdatavalid),
                    .sdram_slave_waitrequest (sdram_slave_waitrequest)
            );
           
            
            sdram_controller sdram_controller_i (
                //=====================================================================
                // clock and reset
                //=====================================================================
                    .clk (clk_100MHz),
                    .reset_n (pll_locked),
                    .sync_reset (1'b0),

                //=====================================================================
                // memory interface
                //=====================================================================
                    .mem_cs (dram_mem_read_en | dram_mem_write_en),
                    .mem_byteenable (dram_mem_byte_enable),
                    .mem_read0_write1 (dram_mem_write_en),
                    .mem_addr ({dram_mem_addr, 1'b0}),
                    .mem_write_data (dram_mem_write_data),

                    .mem_ack (dram_ack),
                    .mem_read_data (dram_mem_read_data),

                //=====================================================================
                // SDRAM Avalon Bus
                //=====================================================================
                    .sdram_av_readdata (sdram_slave_readdata),
                    .sdram_av_readdatavalid (sdram_slave_readdatavalid),
                    .sdram_av_waitrequest (sdram_slave_waitrequest), 

                    .sdram_av_address (sdram_slave_address),
                    .sdram_av_byteenable_n (sdram_slave_byteenable_n),
                    .sdram_av_chipselect (sdram_slave_chipselect),
                    .sdram_av_writedata (sdram_slave_writedata),
                    .sdram_av_read_n (sdram_slave_read_n),
                    .sdram_av_write_n (sdram_slave_write_n)
            );


    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MCU
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        always_ff @(posedge clk_100MHz, negedge pll_locked) begin
            if (!pll_locked) begin
                init_start <= 0;
                actual_cpu_start <= 0;
                actual_start_addr <= 0;
            end else begin
                init_start <= {init_start [$high(init_start) - 1 : 0], 1'b1};
                actual_cpu_start <= cpu_start | ((~init_start [$high(init_start)]) & init_start [$high(init_start) - 1]);
                if (cpu_start) begin
                    actual_start_addr <= cpu_start_addr;
                end else if (!init_start [$high(init_start)]) begin
                    actual_start_addr <= `DEFAULT_START_ADDR;
                end
            end
        end
     
        PulseRain_Reindeer_MCU PulseRain_Reindeer_MCU_i (
            .clk (clk_100MHz),
            .reset_n ((~cpu_reset) & pll_locked),
            .sync_reset (1'b0),

            .ocd_read_enable (ocd_read_enable),
            .ocd_write_enable (ocd_write_enable),
            
            .ocd_rw_addr (ocd_rw_addr),
            .ocd_write_word (ocd_write_word),
            
            .ocd_mem_enable_out (ocd_mem_enable_out),
            .ocd_mem_word_out (ocd_mem_word_out),        
        
            .ocd_reg_read_addr (5'd2),
            .ocd_reg_we (cpu_start),
            .ocd_reg_write_addr (5'd2),
            .ocd_reg_write_data (`DEFAULT_STACK_ADDR),
        
            .RXD (RXD),
            .TXD (uart_tx_cpu),
            
            .GPIO_OUT(gpio_out),
    
            .start (actual_cpu_start),
            .start_address (actual_start_addr),
        
            .processor_paused (processor_paused),
    
            .dram_ack             (dram_ack),
            .dram_mem_read_data   (dram_mem_read_data),
            
            .dram_mem_addr        (dram_mem_addr),
            .dram_mem_read_en     (dram_mem_read_en),
            .dram_mem_write_en    (dram_mem_write_en),
            .dram_mem_byte_enable (dram_mem_byte_enable),
            .dram_mem_write_data  (dram_mem_write_data),
    
            .peek_pc (),
            .peek_ir (),
            .peek_mem_write_en   (),
            .peek_mem_write_data (),
            .peek_mem_addr       ());

        assign LED = gpio_out [31 : 24];
        
        assign SEG_A  = ~gpio_out [0];
        assign SEG_B  = ~gpio_out [1];
        assign SEG_C  = ~gpio_out [2];
        assign SEG_D  = ~gpio_out [3];
        assign SEG_E  = ~gpio_out [4];
        assign SEG_F  = ~gpio_out [5];
        assign SEG_G  = ~gpio_out [6];
        assign SEG_DP = ~gpio_out [7];
        
        assign SEG_DIG4 = gpio_out[8];
        assign SEG_DIG3 = gpio_out[9];
        assign SEG_DIG2 = gpio_out[10];
        assign SEG_DIG1 = gpio_out[11];
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Hardware Loader
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        debug_coprocessor_wrapper #(.BAUD_PERIOD (108)) hw_loader_i (
                    .clk (clk_100MHz),
                    .reset_n (pll_locked),
                    
                    .RXD (RXD),
                    .TXD (uart_tx_ocd),
                        
                    .pram_read_enable_in (ocd_mem_enable_out),
                    .pram_read_data_in (ocd_mem_word_out),
                    
                    .pram_read_enable_out (ocd_read_enable),
                    .pram_read_addr_out (pram_read_addr),
                    
                    .pram_write_enable_out (ocd_write_enable),
                    .pram_write_addr_out (pram_write_addr),
                    .pram_write_data_out (ocd_write_word),
                    
                    .cpu_reset (cpu_reset),
                    
                    .cpu_start (cpu_start),
                    .cpu_start_addr (cpu_start_addr),        
                    
                    .debug_uart_tx_sel_ocd1_cpu0 (debug_uart_tx_sel_ocd1_cpu0));
                
    assign ocd_rw_addr = ocd_read_enable ? pram_read_addr [$high(ocd_rw_addr) : 0] : pram_write_addr [$high(ocd_rw_addr) : 0];        
    
    always_ff @(posedge clk_100MHz, negedge pll_locked) begin : uart_proc
        if (!pll_locked) begin
            TXD <= 0;
        end else if (!debug_uart_tx_sel_ocd1_cpu0) begin
            TXD <= uart_tx_cpu;
        end else begin
            TXD <= uart_tx_ocd;
        end
    end 
       
/*
        ocd ocd_stp (
            .acq_clk (clk_100MHz), 
            .acq_data_in (acq_data_in), 
            .acq_trigger_in ({sdram_slave_readdatavalid,  mem_ack, ocd_read_enable, ocd_write_enable})
        );
        
        assign acq_data_in[0] = ocd_read_enable;
        assign acq_data_in[1] = ocd_write_enable;
        assign acq_data_in[2] = ocd_mem_enable_out;
        assign acq_data_in[3] = cpu_reset;
        assign acq_data_in [35 : 4] = ocd_mem_word_out;
        assign acq_data_in [59 : 36] = pram_read_addr;
        assign acq_data_in [83 : 60] = pram_write_addr;
        assign acq_data_in [115 : 84] = ocd_write_word;
        assign acq_data_in [147 : 116] = cpu_start_addr;
        assign acq_data_in [148] = debug_uart_tx_sel_ocd1_cpu0;
        
        assign acq_data_in [171 : 150] = sdram_slave_address;
        assign acq_data_in [173 : 172] = sdram_slave_byteenable_n;
        assign acq_data_in [174] = sdram_slave_chipselect;
        assign acq_data_in [175] = sdram_slave_read_n;
        assign acq_data_in [176] = sdram_slave_write_n;
        assign acq_data_in [208 : 177] = sdram_slave_writedata;
        assign acq_data_in [240 : 209] = sdram_slave_readdata;
        assign acq_data_in [241] = sdram_slave_readdatavalid;
        assign acq_data_in [242] = sdram_slave_waitrequest;
        assign acq_data_in [255 : 243] = 0;
        
*/

endmodule : step_cyc10

`default_nettype wire
