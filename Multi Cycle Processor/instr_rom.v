module instr_rom #(parameter N=32, Depth = 32)
(input [N-1 : 0] address, output reg [N-1 : 0] instr);
reg [N-1: 0] memory [Depth-1: 0];

initial begin
memory[0] = 32'd234;
memory[1] = 32'd45353;
memory[2] = 32'd4343;
end

always @(address) begin
instr <= memory[address];
end
endmodule
