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
		
end
// assign RegDst_o = (Op_i == 6'b000000)? (1'b1):
				  // 1'b0;
// assign ALUOp_o =  (Op_i == 6'b000000)? (2'b11):
				  // 2'b00;
// assign ALUSrc_o = (Op_i == 6'b000000)? (1'b0):
				  // 1'b1;
// assign RegWrite_o = 1'b1;

endmodule