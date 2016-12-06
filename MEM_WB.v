module MEM_WB
(
	clk_i,
	wb_i,
	memdata_i,
	aluresult_i,
	wb1_o,
	wb2_o,
	wb3_o,
	memdata_o,
	aluresult_o,
	writeaddr1_o,
	writeaddr2_o
);

input 			clk_i;
input	[1:0]	wb_i;
input	[31:0]	memdata_i,aluresult_i;
output			wb1_o, wb2_o, wb3_o;
output	[31:0]	memdata_o, aluresult_o;
output	[4:0]	writeaddr1_o, writeaddr2_o;

endmodule 