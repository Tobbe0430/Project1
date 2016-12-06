module FU(
	rsaddr_i,
	rtaddr_i,
	rdaddr1_i,
	rdaddr2_i,
	wb1_i,
	wb2_i,
	mux6_o,
	mux7_o
);

input	[4:0]	rsaddr_i, rtaddr_i, rdaddr1_i, rdaddr2_i;
input	[1:0]	wb1_i;
input			wb2_i;
output	[1:0]	mux6_o, mux7_o;

endmodule