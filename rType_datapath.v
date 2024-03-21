module rType_datapath();
	reg clk;
	wire [31:0] pc , pc_out;
	wire [31:0] instruction;
	reg rst;
	wire zero;
	wire [31:0]rs,rt,rd;
	//temp var
	reg [4:0] wr;
	reg [4:0] tempD;  
	//control signals
	wire regDest,jump, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire [1:0] ALUOp;
	wire branchCheck;
 	reg [31:0] tempPC, jumpPC;
	//for program counter
	PC uut (
		.pc(pc),
	        .jump_address(jumpPC),
	        .pc_out(pc_out),
	        .jump(jump),
	        .clk(clk),
	        .rst(rst)
	);

	//get instruction
	instr_rom getInstruction (.address(pc), .instr(instruction));
	
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

	//register memory, get data and also update register memory if needed 
	reg_file getData(
		.rdata1(rs),
		.rdata2(rt),
		.rs1(instruction[25:21]),
		.rs2(instruction[20:16]),
		.rd(tempD), 
		.write_data(rd),
		.clk(clk),
		.mem_write(RegWrite)
	);

//Checking for rtype or i type mux 1
	
	always @* begin
		tempD = regDest ? instruction[15:11] : instruction[20:16];
	end

	reg [31:0] temp2 , temp3; 
	always @* begin
		if (ALUSrc == 1) begin
			temp2[14:0] = instruction[14:0];
			temp2[31] = instruction[15];
		end
		else begin
			temp2 = rt;
		end
		
		if (branch == 1) begin
			//if (instruction[15]) temp3 = 32'b1111_1111_1111_1111_0000_0000_0000_0000;
			//else temp3 = 32'b0;
			temp3= instruction[15:0];
			temp3 = temp3 << 2;
			temp3 = temp3+pc;
		end
		jumpPC=0;
		jumpPC = instruction[25:0];
		jumpPC = jumpPC<<2;
	end

	reg PCSrc;
	always @(posedge clk) begin
		PCSrc = zero & branch;
		if (PCSrc)
			tempPC  = temp3;
	end
	assign pc = rst? 32'b0 : (PCSrc)? tempPC: pc_out;

	alu calc(
		.ans(rd),
		.zero(zero),
		.a(rs),
		.b(temp2),
		.aluOP(ALUOp),
		.sel(instruction[5:0]));
//Calling Data Memory
	wire [31:0] data_out;
	data_mem DataMemCall(
		.address(rd), 
		.data_in(temp2),
                .data_out(data_out),  
		.we(MemWrite), 
		.clk(clk));
	
	initial begin
		rst = 1;clk=0;
		tempPC = 0;
		PCSrc=0;
		#100;
		rst = 0; 
	end

	always #50 clk = ~clk;

endmodule

