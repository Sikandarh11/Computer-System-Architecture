
module alu(
  	output reg [31:0] ans,
  	output reg zero,
  	input [31:0] a,
  	input [31:0] b,
	input[3:0] op);
  	reg[32:0] temp;

  always@(*)
    begin
	case(op)
		4'b0000: temp = a+b;
		4'b0010: begin temp = a-b; 
			if(temp==0) zero=1; else zero=0;
			end
		4'b0100: temp = a&b;
		4'b0101: temp = a|b;
	endcase
//if(temp%2 == 1) temp = 0;
     ans = temp[31:0];
    end 
endmodule 