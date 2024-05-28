module MEM_WB_pipeline_reg (
    input wire clk,
    input wire reset,
    
    input wire [31:0] alu_data, 
    input wire [31:0] rd,
    input wire [4:0] rd_address,
    input wire RegWrite,
    input wire MemtoReg,
    input wire [31:0] data,
    output reg [31:0] alu_data_out,
    output reg [31:0] data_out,
    output reg [31:0] rd_out,
    output reg [4:0] rd_address_out, 
    output reg RegWrite_out,
    output reg MemtoReg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_data_out = 32'h0;
            rd_out = 32'h0;
	    data_out = 32'h0;
            rd_address_out = 5'b0; 
            RegWrite_out = 1'b0;
            MemtoReg_out = 1'b0;
        end else begin
            alu_data_out <= alu_data;
            rd_out <= rd;
	    data_out <= data;
            rd_address_out <= rd_address;
            RegWrite_out <= RegWrite;
            MemtoReg_out <= MemtoReg;
        end
    end

endmodule
