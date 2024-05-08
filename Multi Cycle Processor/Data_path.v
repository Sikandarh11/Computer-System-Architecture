module Datapath_MC_final();
	reg clk;
	reg reset;
	//Control Signals
	wire zero, IorD, MemWrite, MemToReg, IRWrite, RegDst;
	wire RegWrite, ALUSrcA, PCWrite;
	wire [1:0] ALUSrcB, PCSource, ALUOp;

	//Instruction Register
	wire[31:0] IR;

	//INITIAL
	initial 
	begin
		clk=1; reset=1;#10 reset=0;
	end

	//FOR CLOCK
	always #50 clk=~clk;

 
	reg[31:0] pc;
	wire [31:0]jump = IR[25:0]<<2;
	wire[31:0] A,B, ALUOutFinal;
//===========================Control Signals============================================
	CU_Multicycle uut(
		.clk(clk),
		.reset(reset),
		.opcode(IR[31:26]),
		.zero(zero),
		.IorD(IorD),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.MemtoReg(MemToReg),
		.IRWrite(IRWrite),
		.PCSource(PCSource),
		.RegDst(RegDst),
		.RegWrite(RegWrite),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.PCWrite_F(PCWrite),
		.ALUOp(ALUOp));
	
	wire [31:0] memAdd;
	assign memAdd = IorD ? ALUOutFinal : pc;
	wire [31:0] data_out;//temporary to get data from data_mem

//===========================Data Memory for IF + DATAR & DATAW============================================
	data_memF DataMemCall(
		.address(memAdd),
		.data_in(),
		.data_out(data_out),
		.re(MemRead),
		.we(MemWrite),
		.clk(clk));

	//PCWrite mux, but need to change it to the whole alusrc thing
	always@(posedge clk) begin
		if(reset)begin
			pc=0;
		end
		if(PCWrite)begin
			if(PCSource == 2'b00)
				pc=pc+1;
			else if(PCSource== 2'b01)
				pc=6;//pc = branch
			else if(PCSource==2'b10)
				pc=jump;
		end
	end


	InstructionRegister Instr_reg(
		.clk(clk),
		.reset(reset),
		.IRWrite(IRWrite),
		.instruction(data_out),
		.IR(IR));

	wire [31:0] MDROut;

	MemoryDataRegister memDataReg(
		.clk(clk),
		.reset(reset),
		.memory_data(data_out),
		.MDR(MDROut));

	wire [4:0] DestRegAdd;
	assign DestRegAdd = RegDst ? IR[15:11]: IR[20:16];

	wire [31:0] writeData;
	assign writeData = MemToReg ? MDROut :ALUOutFinal;

	wire [31:0] rs;
	wire [31:0] rt;
	reg_file regFile(
		.rdata1(rs), 
		.rdata2(rt),
		.rs1(IR[25:21]),
		.rs2(IR[20:16]),
		.rd(DestRegAdd),
		.write_data(writeData),
		.clk(clk),
		.mem_write(RegWrite)
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
	reg [31:0] AluIn2;
	wire [31:0] ALU_result;
 //ALUSrcA Mux
	assign AluIn1 = ALUSrcA ? A : pc;
 //ALUSrcB Mux 2 bit
	always @ (ALUSrcB) begin
		if(ALUSrcB == 0)
			AluIn2 = B;
		else if(ALUSrcB == 1)
			AluIn2 = 32'b001;
		else if(ALUSrcB == 2)
			AluIn2 = signExtended;
		else if(ALUSrcB == 3)
			AluIn2 = seShift;
	end
	wire [3:0] sel;
	ALUControlMC controlCal(
		.opcode(IR[5:2]),
		.aluOP(ALUOp), 
		.op(sel));


	 //ALU Call
	aluMC calculate(
	  	.ans(ALU_result),
	  	.zero(zero),
	  	.a(AluIn1),
	  	.b(AluIn2),
		.op(sel) //4bit 
		);


	 //ALUOut Call
	ALUOutputMC finalfinal(
	    	.clk(clk),
	    	.reset(reset),
	    	.ALU_result(ALU_result),
	    	.ALUout(ALUOutFinal));

endmodule
