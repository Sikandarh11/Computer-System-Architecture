
module lui (
    input [15:0] immediate,
    output reg [31:0] result
);

always @* begin
    result = {immediate, 16'b0}; // Shift left the immediate value by 16 bits
end

endmodule
