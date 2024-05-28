module forwarding_unit(
    input [4:0] rs_EX,
    input [4:0] rt_EX,
    input [4:0] rd_MEM,
    input [4:0] rd_WB,
    input RegWrite_MEM,
    input RegWrite_WB,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        // Forward A
        if (RegWrite_MEM && (rd_MEM != 0) && (rd_MEM == rs_EX)) begin
            forwardA = 2'b01;
        end else if (RegWrite_WB && (rd_WB != 0) && (rd_WB == rs_EX)) begin
            forwardA = 2'b10;
        end else begin
            forwardA = 2'b00;
        end

        // Forward B
        if (RegWrite_MEM && (rd_MEM != 0) && (rd_MEM == rt_EX)) begin
            forwardB = 2'b01;
        end else if (RegWrite_WB && (rd_WB != 0) && (rd_WB == rt_EX)) begin
            forwardB = 2'b10;
        end else begin
            forwardB = 2'b00;
        end
    end
endmodule
