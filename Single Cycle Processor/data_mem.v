module data_mem #(parameter N=32, Depth = 32)
(input [N-1 : 0] address, input [N-1 : 0] data_in, output reg [N-1 : 0] data_out, input we, input clk);
reg [N-1: 0] memory [Depth-1: 0];

initial begin
memory[0] = 32'd1;
memory[1] = 32'd2;
memory[2] = 32'd3;
memory[3] = 32'd4;
memory[4] = 32'd5;
memory[5] = 32'd6;
end

always @(posedge clk) 
if(we)
memory[address] = data_in;

always @(address) 
data_out = memory[address];
endmodule

