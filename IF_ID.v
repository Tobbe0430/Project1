module IF_ID 	
(
	inst_addr_i,
	inst_i,
	hd_i,
	flush_i,
	mux2_o,
	hd_o,
	op_o,
	inst_addr1_o,
	inst_addr2_o,
	rs1_o,
	rt1_o,
	rs2_o,
	rt2_o,
	sign16_o,
	rd_o
);

input	[31:0]	inst_addr_i,inst_i;
input			hd_i,flush_i;
output	[25:0]	mux2_o;
output	??		hd_o;
output	[5:0]	op_o;
output	[31:0]	inst_addr1_o,inst_addr2_o;
output	[4:0]	rs1_o,rt1_o, rs2_o, rt2_o, rd_o;
output	[15:0]	sign16_o;

