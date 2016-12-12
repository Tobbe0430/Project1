module Data_Memory
(
	memread_i,				//1  bit, control input
	memwrite_i,				//1  bit, control input
	memaddr_i,				//32 bits, the address.
	writedata_i,			//32 bits, rt data to be written into memory
	memdata_o				//32 bits, rt data read from memory
);

input 			memread_i, memwrite_i;
input	[31:0]	memaddr_i, writedata_i;
output	[31:0]	memdata_o;

reg		[7:0]	memory		[0:31];
reg		[31:0]  temp_memdata_o;

assign  memdata_o = temp_memdata_o; 

always@(*) 
if(memwrite_i)
begin	
	memory[memaddr_i] <=  writedata_i[7:0];
	memory[memaddr_i+1] <=  writedata_i[15:8];
	memory[memaddr_i+2] <=  writedata_i[23:16];
	memory[memaddr_i+3] <=  writedata_i[31:24];
end

always@(*)
if(memread_i)
begin
	temp_memdata_o[7:0] <= memory[memaddr_i];
	temp_memdata_o[15:8] <= memory[memaddr_i+1];
	temp_memdata_o[23:16] <= memory[memaddr_i+2];
	temp_memdata_o[31:24] <= memory[memaddr_i+3];
end

endmodule 