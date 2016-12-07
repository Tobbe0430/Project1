module MUX7
(
	data1_i,
	data2_i,
	data3_i,
	fu_i,
	data1_o,
	data2_o
);

input	[31:0]	data1_i, data2_i, data3_i;
input	[1:0]	fu_i;
output	[31:0]	data1_o, data2_o;

reg		temp_data1_o;
reg		temp_data2_o_o;
assign	data1_o = temp_data1_o;
assign	data2_o = temp_data2_o;

always @ (*)
begin
		case(fu_i)
			2'b00:	temp_data1_o = data1_i;
					temp_data2_o = data1_i;
			2'b01:	temp_data1_o = data2_i;
					temp_data2_o = data2_i;
			2'b10:	temp_data1_o = data3_i;
					temp_data2_o = data3_i;
			default:
			
endcase
end

endmodule