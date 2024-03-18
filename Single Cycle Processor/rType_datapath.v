module rType_datapath();
	reg clk;
	reg [31:0] pc;
	wire [31:0] instruction;
	reg [31:0] jump_address;
	reg rst;
	wire overflow;
	wire [31:0] rs, rt, rd;
	//temp var
	reg [4:0] wr;
	//control signals
	wire regDest, jump, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire [1:0] ALUOp;
	//for program counter
	PC uut (
	        .jump_address(jump_address),
	        .pc_out(pc),
	        .jump(jump),
	        .clk(clk),
	        .rst(rst)
	);

	//get instruction
	instr_rom getInstruction (.address(pc), .instr(instruction));
	
	//set control signals
	control_unit cs(
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

	//Checking for rtype or i type mux 1
	reg [4:0] temp;  
	always @* begin
		temp = regDest ? instruction[15:11] : instruction[20:16];
	end
	
	reg [31:0] temp2; 
	always @* begin
		if (ALUSrc == 1) begin
			temp2[14:0] = instruction[14:0];
			temp2[31] = instruction[15];
		end
		else begin
			temp2 = rt;
		end
		
		if (branch == 1) begin
			temp2 = temp2 << 2;
		end
	end
	
	alu calc(
		.ans(rd),
		.carry(overflow),
		.a(rs),
		.b(temp2),
		.sel(instruction[5:0])
	);

	// PCSrc Mux
	reg PCSrc;
	always @* begin
		PCSrc = rd & branch;
		if (PCSrc == 1) begin
			pc = temp2;
		end
	end
	
	initial begin
		rst = 1;
		#100;
		rst = 0; 
		clk = 0;
	end

	always #50 clk = ~clk;

endmodule
