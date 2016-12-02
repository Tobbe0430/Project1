module Add_Branch
(
	.data1_i,			//32 bits, need shift left 2
	.data2_i,	 		//32 bits, inst addr
	.data_o
);

input [31:0]	data1_i;
input [31:0]	data2_i; 
	
output [31:0]	data_o;