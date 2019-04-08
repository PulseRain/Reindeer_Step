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


file delete -force work
vlib work
vmap work work

set common "../../submodules/PulseRain_MCU/common"
set config "../../submodules/PulseRain_MCU/common/step_cyc10"
set hw_loader "../../submodules/HW_Loader/source"

vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/mul_div/absolute_value.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/mul_div/long_slow_div_denom_reg.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/mul_div/mul_div_32.v

vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/memory/Intel/cyclone10_LP/dual_port_ram.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/memory/Intel/cyclone10_LP/single_port_ram.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/memory/Intel/cyclone10_LP/single_port_ram_8bit.v

vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/memory/sim/single_port_ram_sim.v

vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/memory/mem_controller.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/memory/dram_rw_buffer.v

vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/source/PulseRain_Reindeer_MCU.v

vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/PulseRain_Reindeer_core.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_controller.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_CSR.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_data_access.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_execution_unit.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_fetch_instruction.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_instruction_decode.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_memory.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_reg_file.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_machine_timer.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/submodules/PulseRain_processor_core/source/Reindeer_mm_reg.v

vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/PulseRain_MCU/peripherals/UART/UART_TX.v
vlog -work work +incdir+$common +incdir+$config -sv ../../submodules/PulseRain_MCU/peripherals/peripherals.sv


vlog -work work +incdir+$common +incdir+$config ../../submodules/HW_Loader/source/CRC16_CCITT.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/HW_Loader/source/debug_coprocessor.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/HW_Loader/source/debug_reply.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/HW_Loader/source/debug_UART.v
vlog -sv -work work +incdir+$common +incdir+$config ../../submodules/HW_Loader/source/Serial_RS232.v
vlog -work work +incdir+$common +incdir+$config ../../submodules/HW_Loader/source/debug_coprocessor_wrapper.v


vlog -work work  ../../cores/PLL/PLL.v
vlog -work work  ../../cores/DDIO_OUT/DDIO_OUT.v
vlog -work work  ../../cores/sdram/sdram/simulation/sdram.v

vlog -work work +incdir+$common +incdir+$config -sv ../../source/cyc10/sdram_controller.sv
vlog -work work +incdir+$common +incdir+$config +incdir+$hw_loader -sv ../../source/cyc10/step_cyc10.sv



vlog -work work  -sv +incdir+../../testbench ../../testbench/file_compare_pkg.sv
vlog -work work  -sv +incdir+../../testbench ../../testbench/file_compare.sv
vlog -work work  -sv +incdir+../../testbench ../../testbench/single_file_compare.sv

vlog -work work  -sv +incdir+$common +incdir+$config ../../testbench/tb_RV.sv
