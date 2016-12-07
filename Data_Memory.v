module Data_Memory
(
	memread_i,				//1  bit, control input
	memwrite_i,				//1  bit, control input
	memaddr_i,				//32 bits, the address.
	writedata_i,			//32 bits, rt data to be written into memory
	memdata_o				//32 bits, rt data read from memory
);

input 			memread_i, memwrite_i, 
input	[31:0]	writeaddr_i, writedata_i;

output	[31:0]	memdata_o;

reg		[31:0]	data_memory		[0:255];

assign memdata_o = data_memory[memaddr_i];

always@(posedge clk_i) begin
    if(memwrite_i)
        data_memory[writeaddr_i] <=  memdata_i;
end
   
endmodule 