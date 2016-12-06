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
    .op_i        (IF_ID.op_o), 					//6 bits from IF_ID
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
	.op_o	 	 (Control.op_i),				//6  bits, op to control_i
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
	.id_ex_i	 (ID_EX.rtaddr3_o),				//5  bits, rd address
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
	.wb_o	     (ID_EX.wb_i),					//2  bits, control input
	.mem_o       (ID_EX.mem_i),					//3  bits, control input
	.ex_o  		 (ID_EX.ex_i)					//4  bits, control input
);

Equal Equal(
	.rsdata_i 	 (Registers.rsdata2_o),			//32 bits, rs data
	.rtdata_i    (Registers.rtdata2_o),			//32 bits, rt data
	.zero_o		 (MUX1.data2_i)					//1  bit, is it zero or not

);

Sign_Extend Sign_Extend(
    .if_id_i     (IF_ID.sign16_o),			    //16 bits, imm. input
    .id_ex_o     (ID_EX.sign_extd_i),			//32 bits, imm. output
	.b_add_o     (Add_Branch.data1_i)			//32 bits, imm. output
);

ID_EX ID_EX(
	.wb_i	 	 (MUX8.wb_o),					//2  bits, control input
	.mem_i	     (MUX8.mem_o),					//3  bits, control input
	.ex_i		 (MUX8.ex_o),					//4  bits, control input
	.inst_addr_i (IF_ID.inst_addr2_o),			//32 bits, instruction address
	.rsdata_i 	 (Registers.rsdata1_o),			//32 bits, rs data
	.rtdata_i	 (Registers.rtdata1_o),			//32 bits, rt data
	.imm_i 		 (Sign_Extend.id_ex_o),			//32 bits, imm. input
	.rsaddr_i	 (IF_ID.rs2_o),					//5  bits, rs address
	.rtaddr_i 	 (IF_ID.rt2_o),					//5  bits, rt address
	.rdaddr_i 	 (IF_ID.rd_o),					//5  bits, rd address
	.wb_o		 (EX_MEM.wb_i),					//2  bits, control input
	.mem_o		 (EX_MEM.mem_i),				//3  bits, control input
	.ex1_o		 (MUX4.alusrc_i),				//1  bit, control input
	.ex2_o		 (ALU_Control.aluop_i),			//2  bit, control input	
	.ex3_o		 (MUX3.regdst_i),				//1  bit, control input
	.rsdata_o 	 (MUX6.data1_i),				//32 bits, rs data
	.rtdata_o	 (MUX7.data1_i),				//32 bits, rt data
	.imm1_o		 (MUX4.data2_i),				//32 bits, imm. output
	.funct_o	 (ALU_Control.funct_i)			//6  bits, 6 LSB of imm. output
	.rsaddr_o	 (FU.rsaddr_i),					//5  bits, rs address
	.rtaddr1_o	 (FU.rtaddr_i),					//5  bits, rt address
	.rtaddr2_o	 (MUX3.data1_i),				//5  bits, rt address
	.rtaddr3_o   (HD.id_ex_i),					//5  bits, rt address
	.rdaddr_o	 (MUX3.data2_i)					//5  bits, rd address
);

MUX6 MUX6(
	.data1_i	 (ID_EX.rsdata_o),				//32 bits, rs data
	.data2_i	 (MUX5.data1_o),				//32 bits, forwarded data
	.data3_i     (EX_MEM.result4_o),			//32 bits, ALU result
	.fu_i		 (FU.mux6_o),					//1  bit, FU input
	.data_o		 (ALU.data1_i)					//32 bits, ALU data 1
);

MUX7 MUX7(
	.data1_i	 (ID_EX.rtdata_o),				//32 bits, rt data
	.data2_i	 (MUX5.data2_o),				//32 bits, forwarded data
	.data3_i	 (EX_MEM.result3_o),			//32 bits, forwarded data
	.fu_i		 (FU.mux7_o),					//1  bit, FU input
	.data1_o	 (MUX4.data1_i),				//32 bits, for mux4 data1
	.data2_o	 (EX_MEM.rtdata_i)				//32 bits, for mem.write
);

MUX4 MUX4(
	.data1_i	 (MUX7.data1_o),				//32 bits, register input
	.data2_i 	 (ID_EX.imm_o),					//32 bits, imm. input
	.alusrc_i    (ID_EX.ex1_o),					//1  bit, control input
	.data_o		 (ALU.data2_i)					//32 bits, ALU data 2
);

ALU ALU(
	.data1_i	 (MUX6.data_o),					//32 bits, register input
	.data2_i	 (MUX4.data_o),					//32 bits, register input
	.aluctrl_i 	 (ALU_Control.aluctrl_o),		//3  bits, control input
	.result_o	 (EX_MEM.result_i)				//32 bits, result output
);

ALU_Control ALU_Control(
	.funct_i	 (ID_EX.funct_o),				//6  bits, control (function) input
	.aluop_i	 (ID_EX.ex2_o),					//2  bits, control input
	.aluctrl_o	 (ALU.aluctrl_i)				//3  bits, control input
);

MUX3 MUX3(
	.regdst_i	 (ID_EX.ex3_o),					//1  bits, control input
	.data1_i	 (ID_EX.rtaddr2_o),				//5  bits, rt address
	.data2_i	 (ID_EX.rdaddr_o),				//5  bits, rd address
	.data_o 	 (EX_MEM.rdaddr_i)				//5  bits, rd address

);

FU FU(
	.rsaddr_i	 (ID_EX.rsaddr_o),				//5  bits, rs address
	.rtaddr_i	 (ID_EX.rtaddr1_o),				//5  bits, rt address
	.rdaddr1_i	 (EX_MEM.rdaddr1_o),			//5  bits, rd address from EX/MEM
	.rdaddr2_i   (MEM_WB.rdaddr_o),				//5  bits, rd address from MEM/WB
	.wb1_i		 (EX_MEM.wb1_o),				//2  bits, control input from EX/MEM
	.wb2_i		 (MEM_WB.wb2_o),				//1  bits, control input from MEM/WB
	.mux6_o		 (MUX6.fu_i),					//2  bits, control input
	.mux7_o		 (MUX7.fu_i)					//2  bits, control input
);

EX_MEM EX_MEM(
	.wb_i		 (ID_EX.wb_o),					//2  bits, control input
	.mem_i		 (ID_EX.mem_o),					//3  bits, control input
	.result_i	 (ALU.result_o),				//32 bits, ALU result
	.rtdata_i    (MUX7.data2_o),				//32 bits, rt data for mem.write
	.rdaddr_i	 (MUX3.data_o),					//5  bits, rd address
	.wb1_o		 (FU.wb1_i),					//2  bits, control input
	.wb2_o		 (MEM_WB.wb_i),					//2  bits, control input
	.mem1_o		 (Data_Memory.memread_i),		//1  bit, control input
	.mem2_o		 (Data_Memory.memwrite_i),		//1  bit, control input
	.result1_o	 (Data_Memory.writeaddr_i),     //32 bits, write address
	.result2_o	 (MEM_WB.aluresult_i),			//32 bits, 
	.result3_o	 (MUX7.data3_i),
	.result4_o   (MUX6.data3_i),
	.rtdata_o
	.rdaddr1_o
	.rdaddr2_o
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
    .result_o     (Registers.RDdata_i),
    .Zero_o     (dummy)
);




endmodule

