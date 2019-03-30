###############################################################################
# Copyright (c) 2018, PulseRain Technology LLC 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###############################################################################


file delete -force libraries

vlib                ./libraries/     
vlib                ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/

vlib                        ./libraries/altera_ver/      
vmap       altera_ver       ./libraries/altera_ver/      
vlib                        ./libraries/lpm_ver/         
vmap       lpm_ver          ./libraries/lpm_ver/         
vlib                        ./libraries/sgate_ver/       
vmap       sgate_ver        ./libraries/sgate_ver/       
vlib                        ./libraries/altera_mf_ver/   
vmap       altera_mf_ver    ./libraries/altera_mf_ver/   
vlib                        ./libraries/altera_lnsim_ver/
vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver/
vlib                        ./libraries/cyclone10lp_ver/ 
vmap       cyclone10lp_ver  ./libraries/cyclone10lp_ver/ 

vlib                        ./libraries/rst_controller/
vmap       rst_controller ./libraries/rst_controller/
vlib                        ./libraries/ISSI_SDRAM/    
vmap       ISSI_SDRAM     ./libraries/ISSI_SDRAM/    
  

set QUARTUS_INSTALL_DIR "C:/intelfpga_lite/18.1/quartus/"

vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver      
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclone10lp_atoms.v" -work cyclone10lp_ver 
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
vlog "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclone10lp_atoms.v" -work cyclone10lp_ver 


vlog  ./submodules/altera_reset_controller.v         -work rst_controller
vlog  ./submodules/altera_reset_synchronizer.v       -work rst_controller
vlog  ./submodules/sdram_ISSI_SDRAM.v                -work ISSI_SDRAM    
vlog  ./submodules/sdram_ISSI_SDRAM_test_component.v -work ISSI_SDRAM    
