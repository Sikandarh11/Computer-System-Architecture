module CU_Multicycle (
	input clk,
	input reset,
	input [5:0] opcode,
	input zero,
	output reg IorD,
	output reg MemWrite,
	output reg MemRead,
	output reg MemtoReg,
	output reg IRWrite,
	output reg PCSource,
	output reg RegDst,
	output reg RegWrite,
	output reg ALUSrcA,
	output reg [1:0] ALUSrcB,
	output PCWrite_F,
	output reg [1:0] ALUOp);

	reg PCWrite;
	reg PCWriteCond;

	assign
		PCWrite_F = (PCWrite | (PCWriteCond & zero));

	//states
	//5 states according to fsm
	//1. Fetch
	//2. Decode
	//3.1. Execute //for rtype
	//3.2. Memory Address Computation
	//3.3. Branch Completion
	//3.4. Jump Completion
	//4.1. Memory Access or Memory Write
	//4.2. Rtype Completion or ALU Writeback
	//4.3. Memory Read
	//5. Memory Writeback // for read
	parameter FETCH = 4'b0000;
	parameter DECODE = 4'b0001;
	parameter EXECUTION = 4'b0010;
	parameter MEM_ADR = 4'b0011;
	parameter BRANCH = 4'b0100;
	parameter JUMP = 4'b0101;
	parameter MEM_WRITE = 4'b0110;
	parameter RTYPE = 4'b0111;
	parameter MEM_READ = 4'b1000;
	parameter MEM_WB = 4'b1001;

	reg [3:0] cs;//current state
	reg [3:0] ns;//next state

  always@(posedge clk)
    if (reset)
		cs <= FETCH;
    else
		cs <= ns;


	always@(cs or opcode) begin
      		case (cs)
	        	FETCH:  ns = DECODE;
		        DECODE:  case(opcode)
	                	6'd0:	ns = MEM_ADR;//lw
	                	6'd1:	ns = MEM_ADR;//sw
	                	6'd2:	ns = EXECUTION;//r
	                	6'd3:	ns = BRANCH;//beq
				6'd4:	ns = JUMP;//beq
				default: ns = FETCH;
                 	endcase
		        MEM_ADR:  case(opcode)
                   		6'd0:      ns = MEM_READ;//lw
                   		6'd1:      ns = MEM_WRITE;//sw
                   		default: ns = FETCH;
                 	endcase
			EXECUTION:   ns = RTYPE;	
        		BRANCH:   ns = FETCH;	
			JUMP: ns = FETCH;
			MEM_WRITE: ns = FETCH;
			RTYPE: ns = FETCH;
        		MEM_READ:    ns = MEM_WB;
        		MEM_WB:    ns = FETCH;
        		default: ns = FETCH;
      		endcase
    	end


	always@(cs) begin
	//making default everything zero to avoid repition(spelling??)
		IorD=1'b0; MemRead=1'b0; MemWrite=1'b0; MemtoReg=1'b0; IRWrite=1'b0; 
		PCSource=1'b0;	ALUSrcB=2'b00; ALUSrcA=1'b0; RegWrite=1'b0; 
		RegDst=1'b0; PCWrite=1'b0; PCWriteCond=1'b0; ALUOp=2'b00;

    		case (cs)
        	FETCH:		begin
            		MemRead = 1'b1; //not sure on this
            		IRWrite = 1'b1;
            		ALUSrcB = 2'b01;
            		PCWrite = 1'b1;
          	end
        	DECODE:
		    ALUSrcB = 2'b11;
        	MEM_ADR:	begin
            		ALUSrcA = 1'b1;
            		ALUSrcB = 2'b10;
          	end
        	MEM_READ:	begin
            		MemRead = 1'b1;
            		IorD    = 1'b1;
          	end
        	MEM_WRITE:	begin
            		MemWrite = 1'b1;
			IorD    = 1'b1;
          	end
        	MEM_WB:	begin
            		RegDst   = 1'b0;
            		MemtoReg = 1'b1;
			RegWrite = 1'b1;
          	end
        	EXECUTION:	begin
            		ALUSrcA = 1'b1;
            		ALUOp   = 2'b10;
          	end
        	RTYPE:	begin
            		RegDst   = 1'b1;
            		RegWrite = 1'b1;
          	end
        	BRANCH:		begin
            		ALUSrcA = 1'b1;
            		ALUOp   = 2'b01;
            		PCWriteCond = 1'b1;
	    		PCSource = 2'b01;
          	end
		JUMP:		begin
	    		PCSource = 2'b10;
			PCWrite = 1'b1;
          	end
      		endcase
    	end
endmodule
