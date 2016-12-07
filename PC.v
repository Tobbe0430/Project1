module PC
(
    clk_i,
    rst_i,
    start_i,
	hd_i,
    pc_i,
    pc1_o,
	pc2_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input				hd_i;	//We import the permission to write
input   [31:0]  	pc_i;
output  [31:0]  	pc1_o, pc2_o;

// Wires & Registers NOT WRITTEN BY US
reg     [31:0]      pc1_o;
reg     [31:0]      pc2_o;

always@(posedge clk_i or negedge rst_i) begin
    if((~rst_i)&(hd_i)) begin
        pc1_o <= 32'b0;
		pc2_o <= 32'b0;
    end
    else begin
        if(start_i)
			begin
            pc1_o <= pc_i;
			pc2_o <= pc_i;
			end
        else
			begin
            pc1_o <= pc1_o;
			pc2_o <= pc2_o;
			end
    end
end

endmodule
