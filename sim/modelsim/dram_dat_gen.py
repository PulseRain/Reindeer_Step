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


###############################################################################
# Python script to generate .dat file for SDRAM simulation model
###############################################################################

import os, sys, getopt
import math, time
from time import sleep
from pathlib import Path

import ctypes

import subprocess
import re

addr_size = 128 * 1024
addr_mask = addr_size - 1

compiler_prefix = 'riscv-none-embed'
objdump = compiler_prefix + '-objdump'


elf_file = sys.argv[1]


sections_lines = subprocess.run([objdump, '-h', elf_file], stdout=subprocess.PIPE).stdout.decode('utf-8').splitlines()

section_regexp = re.compile ("^\s*\d*\s([\.|\-|\w]*)\s*(\w*)\s*(\w*)\s*(\w*)")
section_list = []
section_property_list = []

capture_next = 0

for line in sections_lines:
    line_strip = line.strip()
    match = re.search (section_regexp, line_strip)
    #print (line_strip)

    if (capture_next):
        section_property_list.append(line_strip.split(", "))

    capture_next = 0
    if (match):
        capture_next = 1
        #print (line_strip)
        section_name = match.group(1)
        section_size = int(match.group(2), 16)
        section_vma =  int(match.group(3), 16)
        section_lma = int(match.group(4), 16)

        #print (section_name, section_size, section_vma, section_lma)
        section_list.append ([section_name, section_size, section_vma, section_lma])




#############################################################################
# load sections that have CODE or DATA property
#############################################################################

data_list = bytearray()
addr_list = []
size_list = []
name_list = []

total_sections = 0
for section_name, section_size, section_vma, section_lma in section_list:
    bin_file = os.path.splitext(elf_file)[0] + section_name + '.bin'
    #print (bin_file)
                        
    if (Path(bin_file).exists()):
        os.remove(bin_file)
           
    with open(os.devnull, 'w')  as FNULL:       
        subprocess.run(['riscv-none-embed-objcopy', '--dump-section', section_name + '=' + bin_file, elf_file], stdout=FNULL, stderr=FNULL )
                        
    if (('CODE' in section_property_list[total_sections]) or ('DATA' in section_property_list[total_sections])):
        try:
            name_list.append(section_name)
            
            f = open(bin_file, 'rb')
            byte = f.read(1)
            addr = section_lma
            addr_list.append (section_lma)
            size_list.append(section_size)
            
            while byte:
                data_list += byte
                addr = addr + 1
                byte = f.read(1)
                
            assert ((addr -  section_lma) ==  section_size)
                        
        except IOError:
            print ("Fail to open: ", self.file_name)
            exit(1)

        f.close()
        total_sections = total_sections + 1

###############################################################################
# Generate .dat file for DRAM sim
###############################################################################


byte_index = 0
addr = addr_list[0]
for i in range(total_sections):
    count = 0
    
    #print ("//================================================================")
    #print ("//== Section ", name_list[i])
    #print ("//================================================================")
    
    for j in range (addr, addr_list[i], 4):
        print ("beef")
        print ("dead")
        
        
    
    addr = addr_list[i]
    
    
    for j in range (size_list[i]):
        if (count == 0):
            data = 0
        
        data = data + (data_list[byte_index] << (count * 8))
        count = (count + 1) % 4
        byte_index = byte_index + 1
    
        if (count == 0):
            #data = ((data & 0xFF) << 24) + (((data >> 8 )& 0xFF) << 16) + (((data >> 16 )& 0xFF) << 8) + (((data >> 24 )& 0xFF) << 0)  
            print ("%04x" % (data & 0xFFFF))
            print ("%04x" % ((data >> 16) & 0xFFFF))
            
            addr = addr + 4
