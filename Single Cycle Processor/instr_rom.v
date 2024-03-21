module instr_rom #(parameter N=32, Depth = 32)
(input [N-1 : 0] address, output reg [N-1 : 0] instr);
reg [N-1: 0] memory [Depth-1: 0];

initial begin
  memory[0] = 32'b0;
  memory[1] = 32'b0001_0000_0000_0001_0000_0000_0001_0000;
  memory[2] = 32'b100011_00000_00001_00000_00000_000001;
  memory[3] = 32'b101011_00000_00001_00000_00000_000010;
  memory[4] = 32'b010;
  memory[5] = 32'b011;
  memory[6] = 32'b100;
  memory[7] = 32'b101;
  memory[8] = 32'b110;
  memory[9] = 32'b1000;
  memory[10] = 32'b000000_00000_00001_00010_00000_100000;
end

always @(address) begin
instr <= memory[address];
end
endmodule
