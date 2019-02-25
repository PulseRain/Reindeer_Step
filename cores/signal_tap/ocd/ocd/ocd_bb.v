
module ocd (
	acq_data_in,
	acq_trigger_in,
	acq_clk);	

	input	[255:0]	acq_data_in;
	input	[3:0]	acq_trigger_in;
	input		acq_clk;
endmodule
