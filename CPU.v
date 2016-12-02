module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire 	[31:0] 	inst_addr, inst;


Control Control(
    .Op_i        (IF_ID.op_o), 					//6 bits from IF_ID
	.mux1_o		 (MUX1.control_i), 				//1 bit Sends to mux1
	.mux2_o		 (MUX2.control_i),				//1 bit Sends to mux2
	.mux8_o		 (MUX8.control_i)  				//9 bits Sends to mux2
);


Adder Add_PC(
    .data1_i   	 (PC.pc1_o), 					//32 bits from PC
    .data2_i   	 (32'd4), 						//32 bits, +4
    .data1_o     (MUX1.data1_i), 				//32 bits, next PC address
	.data2_o	 (IF_ID.inst_addr_i) 			//32 bits, next PC address
);


PC PC(
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .start_i     (start_i),
	.hd_i		 (HD.pc_o),						//1 bit
    .pc_i        (MUX2.data_o), 				//32 bits, instr. addr. from MUX2
    .pc1_o       (Add_PC.data1_i), 				//32 bits, instruction address
	.pc2_o		 (Instruction_Memory.addr_i) 	//32 bits, instruction address
);

Instruction_Memory Instruction_Memory(
    .addr_i      (PC.pc2_o), 					//32 bits, instruction address
    .inst_o    	 (IF_ID.inst_i)					//32 bits, instruction
);

IF_ID IF_ID(
	.inst_addr_i (Add_PC.data2_o),				//32 bits, instruction address
	.inst_i		 (Instruction_Memory.inst_o),	//32 bits, the whole instruction
	.hd_i		 (HD.if_id_o),					//1  bit, hazard or no hazard? that is the question.
	.flush_i     (Flush.data_o)					//1  bit, flush or not
	.mux2_o 	 (MUX2.if_id_i), 				//26 bits, instruction[25:0] (needs to shift left)
	.hd_o		 (HD.if_id_i),					//?? bits, to hazard detection
	.op_o	 	 (Control.Op_i),				//6  bits, op to control_i
	.inst_addr1_o(Add_Branch.data2_i),			//32 bits, instruction address
	.inst_addr2_o(ID_EX.inst_addr_i),			//32 bits, instruction address
	.rs1_o		 (Registers.rsaddr_i),			//5  bits, rs address
	.rt1_o		 (Registers.rtaddr_i),			//5  bits, rt address
	.rs2_o		 (ID_EX.rsaddr_i),				//5  bits, rs address
	.rt2_o		 (ID_EX.rtaddr_i), 				//5  bits, rt address
	.sign16_o	 (Sign_Extend.data_i),			//16 bits, immediate
	.rd_o		 (ID_EX.rdaddr_i),				//5  bits, rd address
);

Registers Registers(
    .clk_i       (clk_i),
    .rsaddr_i    (IF_ID.rs1_o),					//5  bits, rs address
    .rtaddr_i    (IF_ID.rt1_o),					//5  bits, rt address
    .rdaddr_i    (MEM_WB.rdaddr_o), 			//5  bits, write address
    .rddata_i    (MUX5.data_o),					//32 bits, write data
    .regwrite_i  (MEM_WB.wb_o), 				//1  bit, to write or not? 
    .rsdata1_o   (ID_EX.rsdata_i),				//32 bits, rs data
	.rsdata2_o	 (Equal.rsdata_i),				//32 bits, rs data
	.rtdata1_o	 (ID_EX.rtdata_i),				//32 bits, rt data
	.rtdata2_o   (Equal.rtdata_i),				//32 bits, rt data
);

HD HD(
	.if_id_i 	 (IF_ID.hd_o),					//?? bits, something
	.id_ex_i	 (ID_EX.rdaddr_o),				//5  bits, rd address
	.id_ex_mem_i (ID_EX.mem_o),					//3  bits, mem control signal
	.mux8_o		 (MUX8.hd_i),					//1  bit, hazard or no hazard
	.pc_o		 (PC.hd_i),						//1  bit, hazard or no hazard
	.if_id_o 	 (IF_ID.hd_i)					//1  bit, hazard or no hazard
);

Add_Branch Add_Branch(
	.data1_i	 (Sign_Extend.data_o),			//32 bits, need shift left 2
	.data2_i	 (IF_ID.inst_addr1_o),			//32 bits, inst addr
	.data_o		 (MUX1.data1_i)					//32 bits, branch address
);

MUX8 MUX8(
	.data1_i 	 (Control.mux8_o),				//9  bits, control stuff
	.data2_i	 (9'd0),						//9  bits, all zero
	.hd_i 		 (HD.mux8_o),					//1  bit, hazard or no hazard
	.id_ex_wb_o	 (ID_EX.wb_i),					//2  bits, control input
	.id_ex_mem_o (ID_EX.mem_i),					//3  bits, control input
	.id_ex_ex_o  (ID_EX.ex_i)					//4  bits, control input
);

Equal Equal(
	.rsdata_i 	 (Registers.rsdata2_o),			//32 bits, rs data
	.rtdata_i    (Registers.rtdata2_o),			//32 bits, rt data
	.zero_o		 (MUX1.data2_i)					//1  bit, is it zero or not

);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (MUX_ALUSrc.data2_i)
);

MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (Control.regdst_o),
    .data_o     (Registers.rdaddr_i)
);



MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     (ALU.data2_i)
);





ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (Registers.RDdata_i),
    .Zero_o     (dummy)
);




endmodule

