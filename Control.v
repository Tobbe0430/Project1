module Control
(
	Op_i,
	// RegDst_o,
	// ALUOp_o,
	// ALUSrc_o,
	// RegWrite_o
	mux1_o,
	mux2_o,
	mux8_o
);

input 	[5:0] 	Op_i;
// output 		 	RegDst_o;
// output 	[1:0] 	ALUOp_o;
// output 			ALUSrc_o;
// output 		 	RegWrite_o;
output			mux1_o;
output			mux2_o;
output	[8:0]	mux8_o;

always @ (*)
begin
		case (op_i)
			3'b000010:	 mux1_o = 1'b1;
			default:	 mux1_0 = 1'b0;
		endcase
		
		case (op_i)
			3'b000001:	mux2_o = 1'b1;
			default:	mux2_o = 1'b0;
		endcase
		
		//TODO Add more here!
		//mux8_0[0] = 
		//mux8_0[1] =
		//mux8_0[2] =
		//mux8_0[3] =
		//mux8_0[4] =
		//mux8_0[5] = Memread ()
		//mux8_0[6] = Memwrite (If are going to write into memory or not)
		//mux8_0[7] = Regwrite (If we are going to write into the register or not)
		//mux8_0[8] = Memreg (If we should save the value from Alu or the memory in the register)
		
		
end
// assign RegDst_o = (Op_i == 6'b000000)? (1'b1):
				  // 1'b0;
// assign ALUOp_o =  (Op_i == 6'b000000)? (2'b11):
				  // 2'b00;
// assign ALUSrc_o = (Op_i == 6'b000000)? (1'b0):
				  // 1'b1;
// assign RegWrite_o = 1'b1;

endmodule