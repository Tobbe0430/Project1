module EX_MEM
(
	clk_i,
	wb_i,
	mem_i,
	result_i,
	rtdata_i,
	writeaddr_i,
	wb1_o,
	wb2_o,
	mem1_o,
	mem2_o,
	result1_o,
	result2_o,
	result3_o,
	result4_o,
	rtdata_o,
	writeaddr1_o,
	writeaddr2_o
);

input			clk_i;
input	[1:0]	wb_i;
input	[2:0]	mem_i;
input	[31:0]	result_i, rtdata_i;
input	[4:0]	writeaddr_i;
output	[1:0]	wb1_o, wb2_o;
output			mem1_o, mem2_o;
output	[31:0]	result1_o, result2_o, result3_o, result4_o, rtdata_o;
output	[4:0]	writeaddr1_o, writeaddr2_o;

reg 	[1:0]	wb_1;
reg		[2:0]	mem_i;
reg 	[31:0]	result_i, rtdata_i;
reg		[4:0]	writeaddr_i;

//eructar = to burp
//eructo = one burp

assign wb1_o = 
assign wb2_o = 
assign mem1_o = 
assign mem2_o = 
assign result1_o = 
assign result2_o = 
assign result3_o = 
assign result4_o = 
assign rtdata_o = 
assign writeaddr1_o = 
assign writeaddr2_o =  
endmodule