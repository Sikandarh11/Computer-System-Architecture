module instr_rom #(parameter N=32, Depth = 32)
(input [N-1 : 0] address, output reg [N-1 : 0] instr);
reg [N-1: 0] memory [Depth-1: 0];

initial begin
	memory[0] = 32'b0000_0000_0001_0001_0000_1100_0010_0000;
	// opcode = 0; rs= 1; rt = 2; rd = 3; shamt = 0; function = 32
	memory[1] = 32'b0000_0000_1010_0110_0011_1000_0010_0010;	
//opcode=0,rs=5,rt=6,rd=7,funct=34
	memory[2] = 32'b100011_00000_00001_00000_00000_000001;
  	memory[3] = 32'b101011_00000_00001_00000_00000_000010;
	memory[4] = 32'b0001_0000_0000_0001_1000_0000_0001_0000;
	//opcode = 4; rs=0; rt=1;
	memory[5] = 32'b0000_0000_0001_0001_0000_1100_0010_0000;
end

always @(address) begin
instr <= memory[address];
end
endmodule

