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

`ifndef CONFIG_VH
`define CONFIG_VH


//----------------------------------------------------------------------------
//  memory size 
//----------------------------------------------------------------------------

`define SRAM_SIZE_IN_BYTES   (32 * 1024)
`define DRAM_SIZE_IN_BYTES   (8 * 1024 * 1024)

`define SRAM_ADDR_BITS       ($clog2(`SRAM_SIZE_IN_BYTES / 4))
`define DRAM_ADDR_BITS       ($clog2(`DRAM_SIZE_IN_BYTES / 4))

`define MEM_ADDR_BITS        (`DRAM_ADDR_BITS + 1)


`define MM_REG_SIZE_IN_BYTES   (32)
`define MM_REG_ADDR_BITS       ($clog2(`MM_REG_SIZE_IN_BYTES / 4))

`define DEFAULT_STACK_ADDR    (((`SRAM_SIZE_IN_BYTES) - 8)| 32'h80000000)
//----------------------------------------------------------------------------
//  clock 
//----------------------------------------------------------------------------
`define MCU_MAIN_CLK_RATE                  100000000


//----------------------------------------------------------------------------
//  peripheral addresses
//----------------------------------------------------------------------------

`define UART_TX_ADDR                       (3'b100)
`define UART_BAUD_RATE                      115200
`define UART_TX_BAUD_PERIOD                (`MCU_MAIN_CLK_RATE / `UART_BAUD_RATE)
`define UART_TX_BAUD_PERIOD_BITS           ($clog2(`UART_TX_BAUD_PERIOD))
`define UART_STABLE_COUNT                  (`MCU_MAIN_CLK_RATE  / `UART_BAUD_RATE / 2)

`define MTIME_LOW_ADDR                     (3'b000)
`define MTIME_HIGH_ADDR                    (3'b001)

`define MTIMECMP_LOW_ADDR                  (3'b010)
`define MTIMECMP_HIGH_ADDR                 (3'b011)

//----------------------------------------------------------------------------
//  hardware mul/div
//----------------------------------------------------------------------------
`define STORE_WAIT_FOR_ACK                  (1'b1)

`define DISABLE_OCD                         0

`define ENABLE_HW_MUL_DIV                   1

`define SMALL_MACHINE_TIMER                 0
`define SMALL_CSR_SET                       0

`endif
