module PC (jump_address, pc,pc_out, jump,   clk, rst); 
		
		parameter N = 32; 
		
		input clk, rst, jump;
		input [N-1:0] jump_address, pc;
		output reg [N-1:0] pc_out; 
		
		always @(posedge clk or posedge rst)
		begin
			if (rst)
				pc_out <=0; 
			else begin
				if (jump) pc_out <= jump_address;
				
				else 
					pc_out <= pc + 1; 
			end // ??? 
		end

endmodule
