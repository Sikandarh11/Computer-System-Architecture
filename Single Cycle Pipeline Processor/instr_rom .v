module instr_rom #(parameter N=32, Depth = 32)
(input [N-1 : 0] address, output reg [N-1 : 0] instr);
reg [N-1: 0] memory [Depth-1: 0];

initial begin
	memory[0] = 32'b000000_00001_00010_00011_00000_100000;
	// opcode = 0; rs = 1; rt = 2; rd = 3; shamt = 0; function = 32 addition
	memory[1] = 32'b000000_00011_01000_00110_00000_100010;	
	// opcode = 0; rs = 5; rt = 8; rd = 6; shamt = 0; function = 34 subtraction
	//memory[1] = 32'b100011_00011_00001_0000000000000100;
	// opcode = 35; rs = 3; rt = 1; imm = 1; lw
	memory[2] = 32'b000000_00001_11111_00010_00000_100100;
	// opcode = 0; rs = 1; rt = 31; rd = 2; shamt = 0; function = 36 and
  	memory[3] = 32'b000000_01000_01100_10100_00000_100101;
	// opcode = 0; rs = 8; rt = 12; rd = 20; shamt = 0; function = 37 or
	// memory[4] = 32'b000100_10000_10001_00000_00000_000001;
	// opcode = 0; rs = 16; rt = 17; imm = 1; beq
	memory[4] = 32'b000000_01000_10001_00000_00000_100110;
	// opcode = 0; rs = 8; rt = 17; rd = 0; xor
	memory[5] = 32'b000010_00000_00000_00000_00000_000100;
	// opcode = 2; addr = 4 then by shifting left by 2 it becomes (16) jump
	
	memory[6] = 32'b000001_00000_00000_00000_00000_000100;
	// GARBAGE
	memory[7] = 32'b000100_10000_10001_00000_00000_000100;
	// G

	memory[16] = 32'b100011_00011_00001_0000000000000100;
	// opcode = 35; rs = 3; rt = 1; imm = 4 lw
	memory[17] = 32'b101011_10000_11111_00000_00000_000011;
	// opcode = 43; rs = 16; rt = 31; imm = 3 sw
	memory[18] = 32'b000100_11000_11001_00000_00000_000001;
	//opcode = 0; rs = 24; rt = 25; imm = 1; beq
	
	// memory[18] = 32'b000111_00000_00001_00000_00000_000001;
	// opcode = 7; rs = 0; rt = 1; imm = 1 addi rt = rs+imm = 2 at loc =1
	memory[19] = 32'b000000_00000_00001_00000_00000_101010;
	// opcode = 0; rs = 0, rt=1; shamt =0; function =  42  for slt
	
	memory[20] = 32'b001010_00000_00101_00000_00000_001010;
	// opcode = 10; rs = 0; rt = 5; imm = 10 slti 
	
	
	memory[21] = 32'b000111_00000_00001_00000_00000_000010;
	// opcode = 7; rs = 0; rt = 1; imm = 1 ori rt = rs+imm = 2 at loc =1
	
	memory[22] = 32'b001111_00000_00000_00000_00000_000010;
	// opcode = 15; rs = 0; rt = 0; imm = 1 ori rt = rs+imm = 2 at loc =1

end

always @(address) begin
instr <= memory[address];
end
endmodule
