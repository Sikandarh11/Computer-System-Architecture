module EX_MEM_pipeline_reg (
    input wire clk,
    input wire reset,
    
    input wire [31:0] alu_data1, 
    input wire [31:0] alu_data2,
    input wire [31:0] rt,
    input wire zero,
    input wire [4:0] reg_des_address,
    
    output reg [31:0] alu_data_out1,
    output reg [31:0] alu_data_out2,
    output reg [31:0] rt_out,
    output reg zero_out,
    output reg [4:0] reg_des_address_out,
    
    input wire jump,
    input wire branch,
    input wire MemRead,
    input wire MemtoReg,
    input wire MemWrite,
    input wire RegWrite,
    
    output reg regDest_out,
    output reg jump_out,
    output reg branch_out,
    output reg MemRead_out,
    output reg MemtoReg_out,
    output reg MemWrite_out,
    output reg RegWrite_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_data_out1 <= 32'h0;
            alu_data_out2 <= 32'h0;
            rt_out <= 32'h0;
            zero_out <= 1'b0;
            reg_des_address_out <= 5'b0;
            
            jump_out <= 1'b0;
            branch_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            RegWrite_out <= 1'b0;
        end else begin
            alu_data_out1 <= alu_data1;
            alu_data_out2 <= alu_data2;
            rt_out <= rt;
            zero_out <= zero;
            reg_des_address_out <= reg_des_address;
            
            jump_out <= jump;
            branch_out <= branch;
            MemRead_out <= MemRead;
            MemtoReg_out <= MemtoReg;
            MemWrite_out <= MemWrite;
            RegWrite_out <= RegWrite;
        end
    end

endmodule
