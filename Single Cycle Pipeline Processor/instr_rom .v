module instr_rom #(parameter N=32, Depth = 32)
(input [N-1 : 0] address, output reg [N-1 : 0] instr);
reg [N-1: 0] memory [Depth-1: 0];

initial begin
	memory[0] = 32'b000000_00001_00010_00011_00000_100000;
	// opcode = 0; rs = 1; rt = 2; rd = 3; shamt = 0; function = 32 addition
	memory[1] = 32'b000000_00101_01000_00110_00000_100010;	
	// opcode = 0; rs = 5; rt = 8; rd = 6; shamt = 0; function = 34 subtraction
	memory[2] = 32'b000000_00001_11111_00010_00000_100100;
	// opcode = 0; rs = 1; rt = 31; rd = 2; shamt = 0; function = 36 and
  	memory[3] = 32'b000000_01000_01100_10100_00000_100101;
	// opcode = 0; rs = 8; rt = 12; rd = 20; shamt = 0; function = 37 or
	memory[4] = 32'b000000_01000_10001_00000_00000_100110;
	// opcode = 0; rs = 8; rt = 17; rd = 0; xor
	memory[5] = 32'b000100_11000_11001_00000_00000_000010;
	//opcode = 4; rs = 24; rt = 25; imm = 1; beq
	//
	
	memory[6] = 32'b000001_00000_00000_00000_00000_000100;
	// GARBAGE

	memory[16] = 32'b000000_00001_00010_00011_00000_100000;
	// opcode = 0; rs = 1; rt = 2; rd = 3; shamt = 0; function = 32 addition
	memory[17] = 32'b000000_00011_01000_00110_00000_100010;	
	// opcode = 0; rs = 5; rt = 8; rd = 6; shamt = 0; function = 34 subtraction
	// rtype data forwarding instruction
	memory[22] = 32'b100011_00011_00001_0000000000000100;
	// opcode = 35; rs = 3; rt = 1; imm = 4 lw
	memory[23] = 32'b101011_10000_11111_00000_00000_000011;
	// opcode = 43; rs = 16; rt = 31; imm = 3 sw
	memory[24] = 32'b000010_00000_00000_00000_00000_001000;
	// opcode = 2; addr = 4 then by shifting left by 2 it becomes (16) jump

end

always @(address) begin
instr <= memory[address];
end
endmodule
