module control_sig(
	output reg regDest,
	output reg jump,
	output reg branch,
	output reg MemRead,
	output reg [1:0]MemtoReg,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite,
	output reg [1:0] ALUOp,
	input [5:0]opcode
);



always@(opcode)
begin
	case(opcode)
	//rtype
	6'b0:begin
		regDest = 1; RegWrite = 1; ALUOp = 2'b10; jump=0; branch=0;
		MemRead = 0; MemtoReg = 0; MemWrite = 0;ALUSrc = 0;
	end

	//lw 35
	6'b100011:begin
		regDest = 0; RegWrite = 1; ALUOp = 2'b00; jump=0; branch=0;
		MemRead = 1; MemtoReg =1 ; MemWrite = 0;ALUSrc = 1;
	end
	//sw 43
	6'b101011:begin
		regDest = 0; RegWrite = 0; ALUOp = 2'b00; jump=0; branch=0;
		MemRead = 0; MemtoReg = 0; MemWrite = 1;ALUSrc = 1;
	end
	 //branch
	6'b000100:begin 
		regDest = 0; RegWrite = 0; ALUOp = 2'b01; jump=0; branch=1;
		MemRead = 0; MemtoReg = 0; MemWrite = 1;ALUSrc = 0;
	end
	//Jump
	6'b000010:begin 
		regDest = 0; RegWrite = 0; ALUOp = 2'b00; jump=1; branch=0;
		MemRead = 0; MemtoReg = 0; MemWrite = 0;ALUSrc = 0;
	end
	//Addi & Ori
	6'b000111:begin
		regDest = 0; RegWrite = 1; ALUOp = 2'b11; jump=0; branch=0;
		MemRead = 0; MemtoReg = 0; MemWrite = 0;ALUSrc = 1;
	end
	//slti
	6'b001010:begin
		regDest = 0; RegWrite = 1; ALUOp = 2'b11; jump=0; branch=0;
		MemRead = 0; MemtoReg = 0; MemWrite = 0;ALUSrc = 1;
	end
	//Lui
	6'b001111:begin
		regDest = 0; RegWrite = 1; ALUOp = 2'b00; jump=0; branch=0;
		MemRead = 0; MemtoReg = 2'b010; MemWrite = 0; ALUSrc = 1;
	end

default: begin
		regDest = 0; RegWrite = 0; ALUOp = 2'b01; jump=0; branch=1;
		MemRead = 0; MemtoReg = 0; MemWrite = 0;ALUSrc = 0;
	end

	endcase
end

endmodule 
