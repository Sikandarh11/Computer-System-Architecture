module sign_extend(
	input [15:0]a,
	output reg [31:0]b
); 
initial begin
b = 0; 
end
always@(*)begin
b[14:0] = a[14:0];
b[31] = a[15];
end
endmodule

