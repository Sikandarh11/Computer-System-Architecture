
module PC_pipeline (jump_address, pc,enable, pc_out, jump,   clk, rst); 
		
		parameter N = 32; 
		input enable;
		input clk, rst, jump;
		input [N-1:0] jump_address, pc;
		output reg [N-1:0] pc_out; 
		
		always @(posedge clk or posedge rst)
		begin
			if (rst)
				pc_out <=0; 
			else begin
				if(enable) begin
					if (jump) pc_out <= jump_address;
				
					else 
					begin
						pc_out <= pc+1; 	
					end
				end
			end // ??? 
		end

endmodule
