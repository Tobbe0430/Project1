module HD
(
	.if_idrs_i,
	.if_idrt_i,
	.id_ex_i,
	.id_ex_memread_i, 
	.mux8_o,		 
	.pc_o,		
	.if_id_o 	
);

input [4:0] if_idrt_i, if_idrs_i, id_ex_i; 
input		id_ex_memread_i;
output 		mux8_o;
output 		pc_o;
output		if_id_o;



endmodule