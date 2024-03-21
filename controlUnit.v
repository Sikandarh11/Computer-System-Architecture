module ControlUnit(clk,rst);
	input clk,rst;
	reg [15:0] instr;
	wire [15:0] INSTR;
	reg [3:0] OP=0;
	wire [3:0] opcode;
	wire [2:0] RD,RS,RT,SHAMT;
	wire [5:0] CONST;
	reg [7:0] ADDR;
	wire [7:0] address;
	wire jump;
	reg [15:0] ROM [0:15];
	reg [15:0] RegFile [0:7];
	wire [7:0] pc;

	initial
	begin
		ROM[0] = 16'b000_010_001_000_0000; //ADD
		ROM[1] = 16'b010_010_000_001_0001; //sll
		ROM[2] = 16'b001_010_001_010_0010; //slr
		ROM[3] = 16'b010_010_000_011_0011; //or
		ROM[4] = 16'b010_010_011_100_0100; //and
		ROM[5] = 16'b000_011_100_101_0101; //addi
		ROM[6] = 16'b000_000_001_011_0110; //li
		ROM[7] = 16'b000_100_011_000_0111; //lw
		ROM[8] = 16'b000_010_000_000_1000; //sw
		ROM[9] = 16'b000_000_000_011_1001; //b
		ROM[10] = 16'b000_011_001_000_1010; //mul	
		ROM[11] = 16'b000_011_001_000_1011; //mflo	
		ROM[12] = 16'b000_000_000_011_1100; //mfhi	
		ROM[13] = 16'b000_010_001_000_1101; //please add conditional instrs as per your code
		ROM[14] = 16'b000_010_001_000_1110; //please add conditional
	end
	
	always@(posedge clk or posedge rst)
	begin
		instr=ROM[pc];
	end

	assign INSTR=instr;
 	assign opcode=OP;
 	assign address=ADDR;

	decode ins(clk, INSTR, opcode, RS, RT, RD, SHAMT, address, CONST);

	datapath work(rst, opcode, RS, RT, RD, SHAMT, CONST, clk,jump);

	always@(posedge jump)
	begin
		OP=9;
		ADDR=2;
	end 
	programCount countPls(clk,rst,opcode,address,pc);

endmodule
