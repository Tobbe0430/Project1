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

// Wires & Registers NOT WRITTEN BY US
reg     [31:0]      pc;

assign pc1_o = pc;
assign pc2_o = pc;

always@(posedge clk_i) begin
    if (hd_i) begin
        pc <= 32'b0;		//Tvek om det ska vara nollor här, tror	//Det borde betyda att man börjar om från början, det vill vi inte.
    end					
    else begin
        if(start_i)
			begin
            pc <= 32'b0; //här ska det nog vara nollor så vi börjar //från första instructionen
			end
        else
			begin
            pc <= pc_i;
			end
    end
end

endmodule
