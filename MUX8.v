module MUX8
(
	.data1_i,				//9  bits, control stuff
	.data2_i,				//9  bits, all zero
	.hd_i,					//1  bit, hazard or no hazard
	.wb_o,					//2  bits, control input
	.mem_o,					//3  bits, control input
	.ex_o					//4  bits, control input
);

input	[8:0]	data1_i;
input	[8:0]	data2_i;
input			hd_i;

output	[1:0]	wb_o;
output	[2:0]	mem_o;
output	[3:0]	ex_o;
