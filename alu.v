
module alu(
  output reg [31:0] ans,
  output reg zero,
  input [31:0] a,
  input [31:0] b,
	input[1:0] aluOP,
  input [5:0] sel);
  reg[32:0] temp;

  always@(*)
    begin
	case(aluOP)
		2'b00: temp = a+b;
		2'b01: begin temp = a-b; 
			if(temp==0) zero=1; else zero=0;
			end
		2'b10:begin
		      case(sel)
		        6'b100000: temp = a+b;
		        6'b100010: temp = a-b;
		        6'b100100: temp = a&b;
		        6'b100101: temp = a|b;
		        default: temp = 0;
		      endcase 
		end
	endcase
      ans = temp[31:0];
    end 
endmodule
