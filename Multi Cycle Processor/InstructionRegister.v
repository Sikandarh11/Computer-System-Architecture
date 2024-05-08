module InstructionRegister (
	input wire clk,
	input wire reset,
	input IRWrite,
	input wire [31:0] instruction,
	output reg [31:0] IR
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        IR <= 32'h0;
    end else begin
	if(IRWrite)
	        IR <= instruction;
	end
end

endmodule
