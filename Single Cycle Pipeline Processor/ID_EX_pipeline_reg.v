module ID_EX_pipeline_reg (
    input wire clk,
    input wire reset,
    
    input wire [31:0] alu_data, 
    input wire [31:0] rs,
    input wire [31:0] rt,
    input wire [31:0] sign_extend_inp,
    input wire [4:0] rt_address,
    input wire [4:0] rd_address,
    
    input wire regDest,
    input wire jump,
    input wire branch,
    input wire MemRead,
    input wire MemtoReg,
    input wire MemWrite,
    input wire ALUSrc,
    input wire [1:0] ALUOp,
    input wire RegWrite,
    
    output reg [31:0] alu_data_out,
    output reg [31:0] rs_out,
    output reg [31:0] rt_out,
    output reg [31:0] sign_extend_out,
    output reg [4:0] rt_address_out,
    output reg [4:0] rd_address_out,
    
    output reg regDest_out,
    output reg jump_out,
    output reg branch_out,
    output reg MemRead_out,
    output reg MemtoReg_out,
    output reg MemWrite_out,
    output reg ALUSrc_out,
    output reg [1:0] ALUOp_out,
    output reg RegWrite_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_data_out <= 32'h0;
            rs_out <= 32'h0;
            rt_out <= 32'h0;
            sign_extend_out <= 32'h0;
            rt_address_out <= 5'b0;
            rd_address_out <= 5'b0;
            
            regDest_out <= 1'b0;
            jump_out <= 1'b0;
            branch_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            ALUSrc_out <= 1'b0;
            ALUOp_out <= 2'b0;
            RegWrite_out <= 1'b0;
        end else begin
            alu_data_out <= alu_data;
            rs_out <= rs;
            rt_out <= rt;
            sign_extend_out <= sign_extend_inp;
            rt_address_out <= rt_address;
            rd_address_out <= rd_address;
            
            regDest_out <= regDest;
            jump_out <= jump;
            branch_out <= branch;
            MemRead_out <= MemRead;
            MemtoReg_out <= MemtoReg;
            MemWrite_out <= MemWrite;
            ALUSrc_out <= ALUSrc;
            ALUOp_out <= ALUOp;
            RegWrite_out <= RegWrite;
        end
    end

endmodule
