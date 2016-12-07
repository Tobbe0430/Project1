module ALU
(
	data1_i,
	data2_i,
	aluctrl_i,
	data_o,
);

input 	[31:0] 	data1_i, data2_i;
input	[2:0] 	aluctrl_i;
output 	[31:0] 	data_o;


reg  	[31:0]	temp_data_o;
assign 			data_o = temp_data_o;


always @ (*)
begin
		case (aluctrl_i)
			3'b001: temp_data_o = data1_i+data2_i;
			3'b010: temp_data_o = data1_i-data2_i;
			3'b011: temp_data_o = data1_i&data2_i;
			3'b100: temp_data_o = data1_i|data2_i;
			3'b101: temp_data_o = data1_i*data2_i;
			default: temp_data_o = 32'b0;
		endcase
end
					
				
endmodule