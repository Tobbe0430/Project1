module MUX6
(
	.data1_i,
	.data2_i,		
	.data3_i,
	.fu_i,
	.data_o
);

input	[31:0]	data1_i, data2_i, data3_i;
input	[1:0]	fu_i;
output	[32:0]	data_o;



endmodule