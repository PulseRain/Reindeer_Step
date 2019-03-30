onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_read_en
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/fetch_enable_out
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/PC_out
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/IR_out
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/fetch_init
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/fetch_start_addr
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/read_mem_addr_wait
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/fetch_next
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/mem_read_done
add wave -noupdate -color Yellow -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/mem_addr_ack
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/mem_data
add wave -noupdate -radix hexadecimal -childformat {{{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[31]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[30]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[29]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[28]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[27]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[26]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[25]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[24]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[23]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[22]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[21]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[20]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[19]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[18]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[17]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[16]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[15]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[14]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[13]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[12]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[11]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[10]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[9]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[8]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[7]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[6]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[5]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[4]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[3]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[2]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[1]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[0]} -radix hexadecimal}} -subitemconfig {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[31]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[30]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[29]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[28]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[27]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[26]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[25]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[24]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[23]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[22]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[21]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[20]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[19]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[18]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[17]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[16]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[15]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[14]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[13]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[12]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[11]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[10]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[9]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[8]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[7]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[6]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[5]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[4]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[3]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[2]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[1]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr[0]} {-height 15 -radix hexadecimal}} /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/start_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/read_mem_enable
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/read_mem_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/mem_ack_suppress
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_rw_pending
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/activate_exception
add wave -noupdate -divider exe
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_execution_unit_i/exe_enable
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/data_access_enable
add wave -noupdate -color Yellow -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_execution_unit_i/PC_in
add wave -noupdate -color Yellow -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_execution_unit_i/IR_in
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/jalr_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_execution_unit_i/X
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_execution_unit_i/exe_offset_JALR
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/current_state
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_execution_unit_i/store_active
add wave -noupdate -divider controller
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/decode_enable_out
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/ctl_exe_enable
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/ctl_data_access_enable
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_read_en
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_addr
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_addr
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_write_en
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_read_ack
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/current_state
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/mem_addr_ack
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/PC_in
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/ctl_fetch_init_jalr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/branch_active
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/jal_active
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/ctl_fetch_init_jal
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_fetch_instruction_i/dram_rw_pending
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/ctl_store_active
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/store_done
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/decode_ctl_STORE
add wave -noupdate -divider {data access}
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_data_access_i/store_active
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_data_access_i/current_state
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_data_access_i/data_access_enable
add wave -noupdate -divider dram
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ctl_inc_read_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/ext_dram_mem_read_en
add wave -noupdate /tb_RV/uut/sdram_controller_i/mem_cs
add wave -noupdate /tb_RV/uut/dram_mem_read_en
add wave -noupdate /tb_RV/uut/dram_mem_write_en
add wave -noupdate /tb_RV/uut/sdram_controller_i/sdram_av_chipselect
add wave -noupdate /tb_RV/uut/sdram_controller_i/sdram_av_read_n
add wave -noupdate /tb_RV/uut/sdram_controller_i/sdram_av_write_n
add wave -noupdate -radix hexadecimal /tb_RV/uut/sdram_controller_i/sdram_av_address
add wave -noupdate /tb_RV/uut/sdram_controller_i/sdram_av_readdatavalid
add wave -noupdate /tb_RV/uut/sdram_controller_i/sdram_av_waitrequest
add wave -noupdate -radix hexadecimal /tb_RV/uut/sdram_controller_i/sdram_av_readdata
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_read_en
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/mem_read_ack
add wave -noupdate /tb_RV/uut/sdram_controller_i/mem_cs
add wave -noupdate /tb_RV/uut/sdram_controller_i/mem_ack
add wave -noupdate -radix hexadecimal /tb_RV/uut/sdram_controller_i/mem_read_data
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/dram_rw_pending
add wave -noupdate -divider rw_buffer
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/mtvec_in
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/read_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/PulseRain_Reindeer_core_i/Reindeer_controller_i/exception_active
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/write_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/current_state
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_pending
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_mem_read_en
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_ack
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_ack
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_mem_read_en
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_mem_addr
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_mem_addr
add wave -noupdate -radix hexadecimal -childformat {{{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[0]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[1]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[2]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[3]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[4]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[5]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[6]} -radix hexadecimal} {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[7]} -radix hexadecimal}} -expand -subitemconfig {{/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[0]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[1]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[2]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[3]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[4]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[5]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[6]} {-height 15 -radix hexadecimal} {/tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem[7]} {-height 15 -radix hexadecimal}} /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/buf_mem
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/mem_dout
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/read_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/write_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ctl_inc_read_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_active
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/current_state
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_mem_write_en
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_mem_addr
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_mem_byte_enable
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_mem_read_en
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/ext_dram_ack
add wave -noupdate /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_ack
add wave -noupdate -radix hexadecimal /tb_RV/uut/PulseRain_Reindeer_MCU_i/mem_controller_i/dram_rw_buffer_i/dram_mem_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {52058181 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 214
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {69946718 ps} {72033470 ps}
