module ALUOutput (
    input wire clk,
    input wire reset,
    input wire [31:0] ALU_result,
    output reg [31:0] ALUout
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ALUout <= 32'h0;
    end else begin
        ALUout <= ALU_result;
    end
end

endmodule

