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

assign  memdata_o = temp_memdata_o; //Unsure about this one
//assign memdata_o = memory[memaddr_i];

always@(*) 
if(memwrite_i)
begin	
	memory[memaddr_i] <=  writedata_i;
end
always@(*)
if(memread_i)
begin
	temp_memdata_o <= memory[memaddr_i];
end

endmodule 