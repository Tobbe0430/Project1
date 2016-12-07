module MUX8
(
	data1_i,				//9  bits, control stuff
	data2_i,				//9  bits, all zero
	hd_i,					//1  bit, hazard or no hazard
	wb_o,					//2  bits, control input
	mem_o,					//3  bits, control input
	ex_o					//4  bits, control input
);

input	[8:0]	data1_i;
input	[8:0]	data2_i;
input			hd_i;

output	[1:0]	wb_o;
output	[2:0]	mem_o;
output	[3:0]	ex_o;

reg [1:0]	temp_wb_o;
reg [2:0]	temp_mem_o;
reg [3:0]	temp_ex_o;

assign wb_o = temp_wb_o;
assign mem_o = temp_mem_o;
assign ex_o = temp_ex_o;

always @ (*)
begin
		case (hd_i)			
			1'b0:	temp_wb_o	= data1_i[8:7];
					temp_mem_o	= data1_i[6:4];
					temp_ex_o	= data1_i[3:0];
					
			1'b1:	temp_wb_o	= data2_i[8:7];
					temp_mem_o	= data2_i[6:4];
					temp_ex_o	= data2_i[3:0];
			default:
endcase
end

endmodule