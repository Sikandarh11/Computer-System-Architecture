
module reg_file(rdata1, rdata2, rs1, rs2, rd, write_data, clk, mem_write);
parameter N=32, Depth = 32;
input [4 : 0] rs1, rs2, rd;
input [N-1 : 0] write_data;
input mem_write, clk;
output [N-1 : 0] rdata1, rdata2;
reg [N-1: 0] memory [Depth-1: 0];

initial begin
memory[0] = 32'd1;
memory[1] = 32'd2;
memory[2] = 32'b1111111111111111111111;
memory[3] = 32'd4;
memory[4] = 32'd5;
memory[5] = 32'd6;
memory[6] = 32'd7;
memory[7] = 32'd8;
memory[8] = 32'd9;
memory[9] = 32'd10;
end
//Read Data
assign rdata1 = memory[rs1];
assign rdata2 = memory[rs2];
//write Data
always @(posedge clk) 
if(mem_write)
memory[rd] = write_data;
endmodule