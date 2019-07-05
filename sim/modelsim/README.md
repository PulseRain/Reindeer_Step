### To Run the Compliance Test
    do build_lib.do
    do build_soc.do
    do run_compliance.do
    
### To Simulate an elf file (Assume the elf file name is abcd.elf)
    Under the Reindeer_Step/sim/modelsim
    
    1. Generate the DRAM data file for sim
        Python dram_dat_gen.py abcd.elf > sdram_ISSI_SDRAM_test_component.dat
    
    2. Build the code
        do build_lib.do
        do build_soc.do
       
    3. Run the Simulation
        do run_sim.do
        
       