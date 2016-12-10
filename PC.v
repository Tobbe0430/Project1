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
reg 				startdisable;//TOBBE

initial begin
	startdisable = 0;
end
assign pc1_o = pc;
assign pc2_o = pc;

always@(posedge clk_i) begin
    // if (hd_i) begin
        // pc <= 32'b0;		//Tvek om det ska vara nollor här, tror	//Det borde betyda att man börjar om från början, det vill vi inte.
    // end					
    //else begin
        if((start_i) & (startdisable != 1'b1))//TOBBE
			begin
				pc <= 32'b0; 			//här ska det nog vara nollor så vi börjar //från första instructionen
				startdisable <= 1'b1;	//TOBBE
			end
        else if (hd_i == 0)				//Everything as normal
			begin
			$display("Allt som normalt en el hd_o == 0");
				pc <= pc_i;				//PC = next pc
			end
		else 							//hd_i == 1 
			begin
			$display("Estamos en el hd_o == 1");
			//pc <= pc;					//Pc = previous pc
			end
			
end

endmodule
