module control_unit(opcode, regDest, jump, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);
input [5:0] opcode;
output reg regDest, jump, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
output reg [1:0] ALUOp;

always@(opcode) begin
	if(opcode == 00)begin // Load
	 	regDest = 0; ALUSrc = 1; MemtoReg = 1;
	 	RegWrite = 1; MemRead = 1; MemWrite = 0;
	 	branch = 0; jump = 0; ALUOp = 2'b00;
	end
	else if(opcode == 01) begin
	 	regDest = 0; ALUSrc = 1; MemtoReg = 0;
	 	RegWrite = 0; MemRead = 0; MemWrite = 1;
	 	branch = 0; jump = 0; ALUOp = 2'b10;
	end
	else if(opcode == 10) begin
	 	regDest = 1; ALUSrc = 0; MemtoReg = 0;
	 	RegWrite = 1; MemRead = 0; MemWrite = 0;
	 	branch = 0; jump = 0; ALUOp = 2'b10;
	end
	
	
	
end

endmodule