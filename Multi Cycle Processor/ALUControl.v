module ALUControl(input [3:0] opcode, input [1:0] aluOP, output reg op);
//opcode is coming from instruction
//aluOP from control unit

	always@(*)
	begin
		case(aluOP)
			2'b00: op = 4'b0000; //add command for sw,lw
			2'b01: op = 4'b0010; //sub command for beq
			2'b10: op = opcode; //rtype
		endcase		
	end


endmodule
