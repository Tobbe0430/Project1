module ID_EX
(
	clk_i,
	wb_i,
	mem_i,
	ex_i,
	inst_addr_i,
	rsdata_i,
	rtdata_i,
	imm_i,
	rsaddr_i,
	rtaddr_i,
	wb_o,
	mem_o,
	ex1_o,
	ex2_o,
	ex3_o,
	rsdata_o,
	rtdata_o,
	imm_o,
	rsaddr_o,
	rtaddr1_o,
	rtaddr2_o,
	rtaddr3_o,
	raddr_o
	//hi there
);

input 			clk_i;
input	[1:0]	wb_i;
input	[2:0]	mem_i;
input	[3:0]	ex_i;
input	[31:0]	inst_addr_i, rsdata_i, rtdata_i, imm_i;
input	[4:0]	rsaddr_i, rtaddr_i, rdaddr_i;
output	[1:0]	wb_o;
output	[2:0]	mem_i;
output			ex1_o, ex3_o;
output	[1:0]	ex2_o;
output	[31:0]	rsdata_o, rtdata_o, imm_o;
output	[4:0]	rsaddr_o, rtaddr1_o, rtaddr2_o, rtaddr3_o, rdaddr_o;

reg [1:0]
reg []

endmodule