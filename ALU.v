module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o,
	Zero_o
);

input 	[31:0] 	data1_i, data2_i;
input	[2:0] 	ALUCtrl_i;
output 	[31:0] 	data_o;
output 		  	Zero_o;

reg 			temp_Zero_o;
assign 			Zero_o = temp_Zero_o;
reg  	[31:0]	temp_data_o;
assign 			data_o = temp_data_o;


always @ (*)
begin
		case (ALUCtrl_i)
			3'b001: temp_data_o = data1_i+data2_i;
			3'b010: temp_data_o = data1_i-data2_i;
			3'b011: temp_data_o = data1_i&data2_i;
			3'b100: temp_data_o = data1_i|data2_i;
			3'b101: temp_data_o = data1_i*data2_i;
			default: temp_data_o = 32'b0;
		endcase
		temp_Zero_o = (temp_data_o == 0)? (1):
				0;
end
					
				
endmodule