module PC
(
    clk_i,
  //  rst_i,
    start_i,
	hd_i,
    pc_i,
    pc1_o,
	pc2_o
);

// Ports
input               clk_i;
//input               rst_i;
input               start_i;
input				hd_i;	//We import the permission to write
input   [31:0]  	pc_i;
output  [31:0]  	pc1_o, pc2_o;

// Wires & Registers
reg     [31:0]      pc;
reg 				startdisable;
	
initial begin
	startdisable = 0;
end
assign pc1_o = pc;
assign pc2_o = pc;

always@(negedge clk_i) begin
    if((start_i) & (startdisable != 1'b1))
		begin
			pc <= 32'b0; 			
			startdisable <= 1'b1;	
		end
    else if (hd_i == 0)				//Everything as normal
		begin
			pc <= pc_i;				//PC = next pc
		end
	else 							//hd_i == 1 
		begin						//We don't wan't to update PC.	
		end
			
end

endmodule
