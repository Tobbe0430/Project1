module Adder
(
	data1_in,
	data2_in,
	data1_o,
	data2_o
);

input	 [31:0] 	data1_in, data2_in;
output 	 [31:0] 	data1_o, data2_o;

assign data1_o = data1_in + data2_in;
assign data2_o = data1_in + data2_in;

endmodule