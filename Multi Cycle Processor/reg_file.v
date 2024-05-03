// Code your design here
module reg_file(rdata1, rdata2, rs1, rs2, rd, write_data, clk, mem_write);

parameter N=32, Depth = 32;
  input [4 : 0] rs1, rs2, rd;
input [N-1 : 0] write_data;
input mem_write, clk;

output [N-1 : 0] rdata1, rdata2;
reg [N-1: 0] memory [Depth-1: 0];

initial begin
memory[0] = 32'd1;
memory[1] = 32'd1;
memory[2] = 32'd1;
memory[3] = 32'd1;
memory[4] = 32'd4;
memory[5] = 32'd5;
memory[6] = 32'd6;
memory[7] = 32'd7;
memory[8] = 32'd8;
memory[9] = 32'd9;
memory[10] = 32'd10;
memory[11] = 32'd11;
memory[12] = 32'd12;
memory[13] = 32'd13;
memory[14] = 32'd14;
memory[15] = 32'd15;
memory[16] = 32'd16;
memory[17] = 32'd0;
memory[18] = 32'd1;
memory[19] = 32'd19;
memory[20] = 32'd20;
memory[21] = 32'd21;
memory[22] = 32'd22;
memory[23] = 32'd23;
memory[24] = 32'd24;
memory[25] = 32'd25;
memory[26] = 32'd26;
memory[27] = 32'd27;
memory[28] = 32'd28;
memory[29] = 32'd29;
memory[30] = 32'd30;
memory[31] = 32'd31;
memory[32] = 32'd32;
end

assign rdata1 = memory[rs1];
assign rdata2 = memory[rs2];

always @(posedge clk) begin
	if(write_data != 0) begin
		if(mem_write)
		memory[rd] = write_data;
	end
end
endmodule