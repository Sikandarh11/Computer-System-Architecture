
module RegisterA (
    input wire clk,
    input wire reset,
    input wire [31:0] data,
    output reg [31:0] A
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        A <= 32'h0;
    end else begin
        A <= data;
    end
end

endmodule
