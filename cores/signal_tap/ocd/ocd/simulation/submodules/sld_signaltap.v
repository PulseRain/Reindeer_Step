// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module sld_signaltap
(
	input acq_clk,				
    input acq_data_in,
    input acq_trigger_in,			
    input acq_storage_qualifier_in,
    input trigger_in,				
    input crc,						
    input storage_enable,			
    input raw_tck,					
    input tdi,						
    input usr1,					
    input jtag_state_cdr,			
    input jtag_state_sdr,			
    input jtag_state_e1dr,			
    input jtag_state_udr,			
    input jtag_state_uir,		
    input clr,					
    input ena,				
    input ir_in,

    input jtag_state_tlr,	
    input jtag_state_rti,		
    input jtag_state_sdrs,	
    input jtag_state_pdr,
    input jtag_state_e2dr,
    input jtag_state_sirs,
    input jtag_state_cir,
    input jtag_state_sir,
    input jtag_state_e1ir,
    input jtag_state_pir,
    input jtag_state_e2ir,
    input tms,						
    input clrn,			
    output irq,
    
    output vcc,					
    output gnd,					

    output ir_out,
    output tdo,				

    output acq_data_out,
    output acq_trigger_out,
    output trigger_out
);

	parameter lpm_type = "sld_signaltap";

	parameter SLD_NODE_INFO = 0;

	parameter SLD_SECTION_ID = "hdl_signaltap_0";

	parameter SLD_DATA_BITS	= 1;
	parameter SLD_TRIGGER_BITS = 1;

    parameter SLD_NODE_CRC_BITS = 32;
    parameter SLD_NODE_CRC_HIWORD = 41394;
    parameter SLD_NODE_CRC_LOWORD = 50132;
    parameter SLD_INCREMENTAL_ROUTING = 0;	

    parameter SLD_SAMPLE_DEPTH = 16;
    parameter SLD_SEGMENT_SIZE = 0;
    parameter SLD_RAM_BLOCK_TYPE = "AUTO";
    parameter SLD_STATE_BITS = 11;

    parameter SLD_BUFFER_FULL_STOP = 1;

    parameter SLD_MEM_ADDRESS_BITS = 7;
    parameter SLD_DATA_BIT_CNTR_BITS = 4;

    parameter SLD_TRIGGER_LEVEL	= 10;	
    parameter SLD_TRIGGER_IN_ENABLED = 0;	
    parameter SLD_HPS_TRIGGER_IN_ENABLED = 0;	
    parameter SLD_HPS_TRIGGER_OUT_ENABLED = 0;	
    parameter SLD_HPS_EVENT_ENABLED	= 0;
    parameter SLD_HPS_EVENT_ID = 0;
    parameter SLD_ADVANCED_TRIGGER_ENTITY = "basic";
    parameter SLD_TRIGGER_LEVEL_PIPELINE = 1;	
    parameter SLD_ENABLE_ADVANCED_TRIGGER = 0;	
    parameter SLD_ADVANCED_TRIGGER_1 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_2 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_3 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_4 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_5 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_6 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_7 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_8 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_9 = "NONE";
    parameter SLD_ADVANCED_TRIGGER_10 = "NONE";
    parameter SLD_INVERSION_MASK_LENGTH = 1;
    parameter SLD_INVERSION_MASK = "0";
    parameter SLD_POWER_UP_TRIGGER = 0;
    parameter SLD_STATE_FLOW_MGR_ENTITY	= "state_flow_mgr_entity.vhd";
    parameter SLD_STATE_FLOW_USE_GENERATED = 0;
    parameter SLD_CURRENT_RESOURCE_WIDTH = 0;
    parameter SLD_ATTRIBUTE_MEM_MODE = "OFF";

    parameter SLD_STORAGE_QUALIFIER_BITS = 1;
    parameter SLD_STORAGE_QUALIFIER_GAP_RECORD = 0;
    parameter SLD_STORAGE_QUALIFIER_MODE = "OFF";
    parameter SLD_STORAGE_QUALIFIER_ENABLE_ADVANCED_CONDITION = 0;		
    parameter SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH = 0;
	parameter SLD_STORAGE_QUALIFIER_ADVANCED_CONDITION_ENTITY = "basic";
    parameter SLD_STORAGE_QUALIFIER_PIPELINE = 0;
	
	assign vcc = 1'b1;		
    assign gnd = 1'b0;	

    assign ir_out = 1'b0;
    assign tdo = 1'b0;	

    assign acq_data_out = 1'b0;
    assign acq_trigger_out = 1'b0;
    assign trigger_out = 1'b0;

endmodule
