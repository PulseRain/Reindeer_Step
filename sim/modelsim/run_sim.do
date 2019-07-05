vsim -t ps -novopt tb_RV -gTV="" -L work -L work_lib -L rst_controller -L ISSI_SDRAM -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver

set StdArithNoWarnings 1;list
set NumericStdNoWarnings 1;list

add log -r sim:/*
do wave.do
