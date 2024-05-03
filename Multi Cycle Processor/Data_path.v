module MC_datapath();
    	reg clk;
	wire reset;
	wire [5:0] opcode;
	wire zero;
	wire  IorD;
	wire  MemWrite;
	wire  MemRead;
	wire  MemtoReg;
	wire  IRWrite;
	wire  PCSource;
	wire  RegDst;
	wire  RegWrite;
	wire  ALUSrcA;
	wire [1:0] ALUSrcB;
	wire PCSel;
	wire  [1:0] ALUOp;
	
	wire [31:0] ALUOutFinal;
	wire [31:0] IR;
//===========================Control Signals============================================
CU_Multicycle uut(
	 .clk(clk),
	 .reset(reset),
	 .opcode(opcode),
	 .zero(zero),
	.IorD(IorD),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.IRWrite(IRWrite),
	.PCSource(PCSource),
	.RegDst(RegDst),
	.RegWrite(RegWrite),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.PCSel(PCSel),
	.ALUOp(ALUOp));
	
	
//===========================program counter============================================
	wire [31:0] pc;
	wire pcWrite;
	wire jump = IR[25:0];
	always @(posedge clk)begin
		if(pcWrite)begin
			if(PCSource == 0) 
				pc = pc+4;
			else if(PCSource == 1) 
				pc = ALUOutFinal;
			else if(PCSource == 2)
				pc = jump;
		end
	end
//======================================= DataMemory Call =================================================	
    
// Mux IorD for DataMemory Call
	wire [31:0]memAdd;
	assign memAdd = IorD ? ALUOutFinal : pc;

//DataMem
	data_mem DataMemCall(
        .address(memAdd), 
        .data_in(data_in),
        .data_out(data_out),  
        .we(MemWrite), 
        .clk(clk)
    );


//========================Instruction Register & MDR=====================
    	
//Instruction Register
	
	InstructionRegister Instr_reg(
     	.clk(clk),
    	.reset(reset),
    	.instruction(data_out),
    	.IR(IR)
	);
//MDR
	wire [31:0] MDROut;
	MemoryDataRegister memDataReg(
    	.clk(clk),
    	.reset(reset),
    	.memory_data(data_out),
    	.MDR(MDROut)
	);

//===============================Register File & SignExtend & Shift Left 2 ========================

//Register File
  //RegDest Mux
	wire [5:0] DestRegAdd;
	assign DestRegAdd = RegDst ? IR[15:11] : IR[20:16];
 //MemtoReg Mux
	wire [31:0] writeData;
	assign writeData = MemtoReg ? MDROut : ALUOutFinal;
// reg_file Call
	wire [31:0] rs;
	wire [31:0] rt;
	reg_file regFile(
		.rdata1(A), 
		.rdata2(B),
		.rs1(IR[25:21]),
		.rs2(IR[20:16]),
		.rd(DestRegAdd),
		.write_data(writeData),
		.clk(clk),
		.mem_write(mem_write)
	);
// Sign Extension Call
	wire [31:0] signExtended;
	sign_extend se(
	.a(IR[15:0]),
	.b(signExtended)
	); 

//Shift Left 2
	wire [31:0] seShift;
	assign seShift = signExtended<<2;



//==============================Register A & B =====================================
	
	RegisterA regA(
    	.clk(clk),
    	.reset(reset),
    	.data(rs),
    	.A(A)
	);

	RegisterB regB(
    	.clk(clk),
    	.reset(reset),
    	.data(rt),
    	.B(B)
	);

//==================================ALU & ALUOut===============================
 
	wire [31:0] AluIn1;
	wire [31:0] AluIn2;
	wire [31:0] ALU_result;
 //ALUSrcA Mux
	assign AluIn1 = ALUSrcA ? A : pc;
 //ALUSrcB Mux 2 bit
	always @ (ALUSrcB) begin
		if(ALUSrcB == 0)
			AluIn2 = B;
		else if(ALUSrcB == 1)
			AluIn2 = 32'b100;
		else if(ALUSrcB == 2)
			AluIn2 = signExtended;
		else if(ALUSrcB == 3)
			AluIn2 = seShift;
	end
//ALU Control
wire [3:0] sel;
ALUControl controlCal(
	.opcode(IR[2:5]),
	.aluOP(ALUOp), 
	.op(sel));


 //ALU Call
	
	alu calculate(
  	.ans(ALU_result),
  	.zero(zero),
  	.a(AluIn1),
  	.b(AluIn2),
	.aluOP(ALUOp),  //2 bit	
	.sel(sel) //4bti
);


 //ALUOut Call
	ALUOutput finalfinal(
    	.clk(clk),
    	.reset(reset),
    	.ALU_result(ALU_result),
    	.ALUout(ALUOutFinal));

endmodule
	

