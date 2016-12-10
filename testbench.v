`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .start_i(Start)
);

initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
	
	//Initialize instruction memory the hard way:
	CPU.Instruction_Memory.memory[0] = 32'b00000000000000000100000000100000; //PC= 0  add $t0,$0,$0   		
	CPU.Instruction_Memory.memory[1] = 32'b00100000000010010000000000001010; //PC= 4  addi $t1,$0,10
	CPU.Instruction_Memory.memory[2] = 32'b10101101000000000000000000000000; //PC= 8  sw $0,0($t0)
	CPU.Instruction_Memory.memory[3] = 32'b10101101000010010000000000000100; //PC=12  sw $t1,4($t0)
	CPU.Instruction_Memory.memory[4] = 32'b10001101000011010000000000000100; //PC=16  lw $t5,4($t0)
	CPU.Instruction_Memory.memory[5] = 32'b00000001101010010111100000100000; //PC=20  add $t7,$t5,$t1       (hazard!)  
	CPU.Instruction_Memory.memory[6] = 32'b00100000000010100000000000001101; //PC=24  addi $t2,$0,13        (stall 1 cycle)
	CPU.Instruction_Memory.memory[7] = 32'b00000001001010010101100000011000; //PC=28  mul $t3,$t1,$t1
	CPU.Instruction_Memory.memory[8] = 32'b00001000000000000000000000001011; //PC=32  j Jump            
	CPU.Instruction_Memory.memory[9] = 32'b00100001001010010000000000000001; //PC=36  addi $t1,$t1,1        (flush)
	CPU.Instruction_Memory.memory[10] = 32'b00100001001010010000000000000001; //PC=40  addi $t1,$t1,1        
	CPU.Instruction_Memory.memory[11] = 32'b00000001010010010101000000100010; //PC=44  Jump: sub $t2,$t2,$t1
	CPU.Instruction_Memory.memory[12] = 32'b00000001001010100101100000100100; //PC=48  and $t3,$t1,$t2
	CPU.Instruction_Memory.memory[13] = 32'b00000001010010110110000000100101; //PC=52  or $t4,$t2,$t3

        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end
    
    // Load instructions into instruction memory
    $readmemb("instruction.txt", CPU.Instruction_Memory.memory);
    
    // Open output file
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    Clk = 1;
    //Reset = 0;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    //Reset = 1;
    Start = 1;
        
end
  
always@(posedge Clk) begin
	//if(counter == 2) Start = 0;
    if(counter == 30)    // stop after 30 cycles
        $stop;

    // put in your own signal to count stall and flush
    if(CPU.HD.mux8_o == 1 && CPU.Control.flush_o == 0 && CPU.Control.mux2_o == 0)stall = stall + 1;
    if(CPU.HD.mux8_o == 1)flush = flush + 1;  

    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %d, Flush = %d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc1_o);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
    
      
end

  
endmodule
