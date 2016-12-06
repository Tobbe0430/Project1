module MUX7
(
	data1_i,
	data2_i,
	data3_i,
	fu_i,
	data1_o;
	data2_o;
);

input	[31:0]	data1_i, data2_i, data3_i;
input	[1:0]	fu_i;
output	[31:0]	data1_o, data2_o;

endmodule