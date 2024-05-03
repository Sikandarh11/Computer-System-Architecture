
module RegisterB (
    input wire clk,
    input wire reset,
    input wire [31:0] data,
    output reg [31:0] B
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        B <= 32'h0;
    end else begin
        B <= data;
    end
end

endmodule
