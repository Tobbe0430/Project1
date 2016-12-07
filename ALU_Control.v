module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input 	[5:0] 	funct_i;
input 	[1:0] 	ALUOp_i;
output 	[2:0] 	ALUCtrl_o;

reg 	[2:0] 	temp_ALUCtrl_o;
assign ALUCtrl_o = temp_ALUCtrl_o;

always @ (funct_i or ALUOp_i)
begin
	if (ALUOp_i == 2'b00)
		temp_ALUCtrl_o = 3'b001;
	else
		case (funct_i)
			6'b100000: temp_ALUCtrl_o = 3'b001;
			6'b100010: temp_ALUCtrl_o = 3'b010;
			6'b100100: temp_ALUCtrl_o = 3'b011;
			6'b100101: temp_ALUCtrl_o = 3'b100;
			6'b011000: temp_ALUCtrl_o = 3'b101;
			default: temp_ALUCtrl_o = 3'b000;
		endcase
end
					

endmodule