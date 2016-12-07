module MUX2
(
	data1_i,
	data2_i,
	control_i,
	data_o
);

input	[31:0]	data1_i, data2_i;
input			control_i;
output	[31:0]	data_o;

assign data_o = (control_i == 0)? (data1_i):
				data2_i;
				
endmodule