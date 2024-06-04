module IF_ID_pipeline_reg (
    input wire clk,
    input wire reset,
    input wire enable, 
    input wire [31:0] alu_data,
    input wire [31:0] inst_mem_data,
    output reg [31:0] alu_data_out,
    output reg [31:0] inst_mem_data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_data_out <= 32'h0;
            inst_mem_data_out <= 32'h0;
        end else if (enable) begin
            alu_data_out <= alu_data;
            inst_mem_data_out <= inst_mem_data;
        end
    end
endmodule
