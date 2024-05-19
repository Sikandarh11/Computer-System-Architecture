module datapath();
	reg clk;
	wire [31:0] pc , pc_out;
	wire [31:0] instruction;
	reg rst;
	wire zero;
	wire [31:0]rs,rt,rd, ans;
	//temp var
	reg [4:0] wr;
	reg [4:0] reg_des_address;  
	//control signals
	wire regDest,jump, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire [1:0] ALUOp;
	wire branchCheck;
 	reg [31:0] tempPC, jumpPC;
	wire [31:0] data_out;
	
//==================>Control Signals for Registers<=========================
	// IO for ID_EX_pipeline_reg 
	reg regDest_1,jump_1, branch_1, MemRead_1, MemtoReg_1, MemWrite_1, ALUSrc_1,RegWrite_1;
	reg [1:0] ALUOp_1;
	
	reg [31:0] rs_1, rt_1, alu_data_1, SignExtend_1;
	reg [4:0] rt_address, rd_address;

	// IO for EX_MEM_pipeline_reg 
	reg jump_2, branch_2, MemRead_2, MemtoReg_2, MemWrite_2, RegWrite_2, zero_1;
	reg [31:0] branch_address_1;

	reg [5:0] reg_des_address_1;
	reg [31:0] ans_1, rt_1;
	
	// IO for MEM_WB_pipeline_reg
	reg RegWrite_3, MemtoReg_3;
	
//========================Before IF/ID Register====================================
	//PC Call
	PC uut (
		.pc(pc),
	    .jump_address(jumpPC),
	    .pc_out(pc_out),
        .jump(jump_2),
		.clk(clk),
	    .rst(rst)
	);

	//get instruction Call
	instr_rom getInstruction (.address(pc), .instr(instruction));
	
	
//=====================>IF/ID reg Call<======================
	wire [31:1] pc_alu;
	wire [31:1] instr_mem_reg;
	
	
	IF_ID_pipeline_reg IF_ID_call(
		.alu_data(alu_data), // =====================Ya PC +1 wali setting krlena noor ============================ 
		.inst_mem_data(inst_mem_data),
		
		.alu_data_out(alu_data_out),
		.inst_mem_data_out(inst_mem_data_out)
	);
	
//======================================>Before ID_EX Register<================================
	
	//set control signals
	control_sig cs(
		.regDest(regDest),
		.jump(jump),
		.branch(branch),
		.MemRead(MemRead),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.ALUOp(ALUOp),
		.opcode(instruction[31:26])
	);

	//register file call
	
	reg_file getData(
		.rdata1(rs),
		.rdata2(rt),
		.rs1(instruction[25:21]),
		.rs2(instruction[20:16]),
		.rd(reg_des_address), 
		.write_data(rd),
		.clk(clk),
		.mem_write(RegWrite_3)
	);
	
	// SignExtend Call
	wire [31:0] SignExtend;
	sign_extend(instruction[15:0], SignExtend);
	
	
//=====================================>ID_EX_pipeline_reg call<====================================	

	
	
	ID_EX_pipeline_reg ID_EX_Call(
		.clk(clk),
		.reset(reset),
		
		.alu_data(alu_data), //===========Question pc+1 alu data isa dakh lena======
		.rs(rs),
		.rt(rt),
		.sign_extend_inp(SignExtend),
		.rt_address(instruction[20:16]),
		.rd_address(instruction[15:11]),
		
		.alu_data_out(alu_data_1),//========Question pc+1 alu data isa dakh lena==========
		.rs_out(rs_1),
		.rt_out(rt_1),
		.sign_extend_out(SignExtend_1),
		.rt_address_out(rt_address),
		.rd_address_out(rd_address),
		
		.regDest(regDest),
		.jump(jump),
		.branch(branch),
		.MemRead(MemRead),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.ALUSrc(ALUSrc),
		.ALUOp(ALUOp),
		.RegWrite(RegWrite),
		
		.regDest_out(regDest_1),
		.jump_out(jump_1),
		.branch_out(branch_1),
		.MemRead_out(MemRead_1),
		.MemtoReg_out(MemtoReg_1),
		.MemWrite_out(MemWrite_1),
		.ALUSrc_out(ALUSrc_1),
		.ALUOp_out(ALUOp_1),
		.RegWrite_out(RegWrite_1)
);


	
	always @* begin
		reg_des_address = regDest_1 ? rd_address : rt_address;
	end

	reg [31:0] alu_inp_2 ; 
	reg [31:0] branch_address; 
	
	always @* begin
		if (ALUSrc_1 == 1) begin
			alu_inp_2[14:0] = instruction[14:0];
			alu_inp_2[31] = instruction[15];
		end
		else begin
			alu_inp_2 = rt;
		end
		
		if (branch_1 == 1) begin
			branch_address[14:0]= instruction[15:0];
			branch_address = branch_address << 2;
			branch_address = branch_address+pc;
		end
		jumpPC=0;
		jumpPC = instruction[25:0];
		jumpPC = jumpPC<<2;
		
	end

	
	
	alu calc(
		.ans(ans),
		.zero(zero),
		.a(rs),
		.b(alu_inp_2),
		.aluOP(ALUOp_1),
		.sel(instruction[5:0])
		);
		
	
//=====================================> EX/MEM <==============================	
	
	
	EX_MEM_pipeline_reg  EX_MEM_CALL(
		.clk(clk),
		.reset(reset),
    
		.alu_data1(branch_address), 
		.alu_data2(ans),
		.rt(rt),
		.zero(zero),
		.reg_des_address(reg_des_address),
	
		.alu_data_out1(branch_address_1),
		.alu_data_out2(ans_1),
		.rt_out(rt_1),
		.zero_out(zero_1),
		.reg_des_address_out(reg_des_address_1),
		
		.jump(jump_1),
		.branch(branch_1),
		.MemRead(MemRead_1),
		.MemtoReg(MemtoReg_1),
		.MemWrite(MemWrite_1),
		.RegWrite(RegWrite_1),
		
		.jump_out(jump_2),
		.branch_out(branch_2),
		.MemRead_out(MemRead_2),
		.MemtoReg_out(MemtoReg_2),
		.MemWrite_out(MemWrite_2),
		.RegWrite_out(RegWrite_2),
);


	reg PCSrc;
	always @(posedge clk) begin
		PCSrc = zero & branch_2;
		if (PCSrc)
			tempPC  = branch_address;
	end
	assign pc = rst? 32'b0 : (PCSrc)? tempPC: pc_out;

//Calling Data Memory
	
	data_mem DataMemCall(
		.address(ans_1), 
		.data_in(rt_1),
        .data_out(data_out),  
		.we(MemWrite_2), 
		.clk(clk)
		);
//========================>MEM_WB Call<=================================
	
	
	
	MEM_WB_pipeline_reg  MEM_WB(
		.clk(clk),
		.reset(reset),
		
		.alu_data(ans), 
		.rd(rd),
		.rd_address(rd_address),
		
		.RegWrite(RegWrite_2),
		.MemtoReg(MemtoReg_2),
		
		.rd_out(rd),
		.alu_data_out(ans),
		.rd_address_out(rd_address_out),
		
		.RegWrite_out(RegWrite_3),
		.MemtoReg_out(MemtoReg_3),
		
);
	assign rd = MemtoReg_3? data_out: ans_1;
	
	initial begin
		rst = 1;clk=0;
		tempPC = 0;
		PCSrc=0;
		#100;
		rst = 0; 
	end

	always #50 clk = ~clk;

endmodule
