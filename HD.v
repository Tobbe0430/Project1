module HD
(
	.if_id_i,
	.id_ex_i,
	.id_ex_mem_i, 
	.mux8_o,		 
	.pc_o,		
	.if_id_o 	
);

input [?:?] if_id_i;
input [4:0] id_ex_i;
input [2:0] id_ex_mem_i;

output 		mux8_o;
output 		pc_o;
output		if_id_o;
