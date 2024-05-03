module MemoryDataRegister (
    input wire clk,
    input wire reset,
    input wire [31:0] memory_data,
    output reg [31:0] MDR
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        MDR <= 32'h0;
    end else begin
        MDR <= memory_data;
    end
end

endmodule
