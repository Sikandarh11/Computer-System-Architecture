module datapath_pipeline(
	input clk,
	input rst,
	output [31:0] pc,
	output stall,
	output [1:0] forwardA,
	output [1:0] forwardB
);
    wire [31:0] pc_out;
    wire [31:0] instruction, instruction_ID, instruction_EX;
    wire zero;
    wire [31:0] rs, rt, rd, ans, rd_final_data;
    // temp var
    reg [4:0] reg_des_address, regs_address, regt_address;  
    // control signals
    wire regDest, jump, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;
    wire branchCheck;
    reg [31:0] tempPC, jumpPC;
    wire [31:0] data_out, data_out_WB;
    reg control;

    //==================>Control Signals for Registers<=========================
    // IO for ID_EX_pipeline_reg 
    wire regDest_EX, jump_EX, branch_EX, MemRead_EX, MemtoReg_EX, MemWrite_EX, ALUSrc_EX, RegWrite_EX;
    wire [1:0] ALUOp_EX;

    wire [31:0] rs_EX, rt_EX, alu_data_EX, SignExtend_EX;
    wire [4:0] rt_address,  rs_address,rd_address;

    // IO for EX_MEM_pipeline_reg 
    wire jump_MEM, branch_MEM, MemRead_MEM, MemtoReg_MEM, MemWrite_MEM, RegWrite_MEM, zero_MEM;
    wire [31:0] branch_address_1;

    wire [4:0] reg_des_address_MEM;
    wire [31:0] ans_1, rt_1, ans_final;

    // IO for MEM_WB_pipeline_reg
    wire RegWrite_WB, MemtoReg_WB;
    wire [4:0] reg_des_address_WB;

    //========================Before IF/ID Register====================================
	wire [31:0] alu_data_out;
// Hazard Detection Unit
    hazard_detection_unit hdu(
	.clk(clk),
        .rs1_ID(instruction_ID[25:21]),
        .rs2_ID(instruction_ID[20:16]),
        .rt_EX(rt_address),
        .MemRead_EX(MemRead_EX),
        .stall(stall)
    );

    // PC Call
    PC_pipeline uut (
        .pc(pc),
        .jump_address(jumpPC),
        .pc_out(pc_out),
	.enable(~stall),
        .jump(jump),
        .clk(clk),
        .rst(rst)
    );

    // get instruction Call
    instr_rom getInstruction (
        .address(pc), 
        .instr(instruction)
    );

    //=====================>IF/ID reg Call<======================
    
    IF_ID_pipeline_reg IF_ID_call(
        .clk(clk),
        .reset(rst),
        .enable(~stall), // Enable the register only if there's no stall
        .alu_data(pc + 1),
        .inst_mem_data(instruction),
        .alu_data_out(alu_data_out),
        .inst_mem_data_out(instruction_ID)
    );

    //======================================>Before ID_EX Register<================================
    // set control signals
    control_sig cs(
        .control(control),
        .regDest(regDest),
        .jump(jump),
        .branch(branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .opcode(instruction_ID[31:26])
    );
	always@(*) begin
		regs_address= instruction_ID[25:21];
		regt_address = instruction_ID[20:16];
	end
    // register file call
    reg_file getData(
        .rdata1(rs),
        .rdata2(rt),
        .rs1(regs_address),
        .rs2(regt_address),
        .rd(reg_des_address_WB), 
        .write_data(rd_final_data),
        .clk(clk),
        .mem_write(RegWrite_WB)
    );

    // SignExtend Call
    wire [31:0] SignExtend;
    sign_extend se(instruction_ID[15:0], SignExtend);

    

    //=====================================>ID_EX_pipeline_reg call<====================================    
    ID_EX_pipeline_reg ID_EX_Call(
        .clk(clk),
        .reset(rst),  
	.stall(stall), 
        .alu_data(alu_data_out),
        .rs(rs),
        .rt(rt),
        .sign_extend_inp(SignExtend),
	.rs_address(regs_address),
        .rt_address(instruction_ID[20:16]),
        .rd_address(instruction_ID[15:11]),

        .alu_data_out(alu_data_EX),
        .rs_out(rs_EX),
        .rt_out(rt_EX),
        .sign_extend_out(SignExtend_EX),
	.rs_address_out(rs_address),
        .rt_address_out(rt_address),
        .rd_address_out(rd_address),

        .regDest(regDest),
        .jump(jump),
        .branch(branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),

        .regDest_out(regDest_EX),
        .jump_out(jump_EX),
        .branch_out(branch_EX),
        .MemRead_out(MemRead_EX),
        .MemtoReg_out(MemtoReg_EX),
        .MemWrite_out(MemWrite_EX),
        .ALUSrc_out(ALUSrc_EX),
        .ALUOp_out(ALUOp_EX),
        .RegWrite_out(RegWrite_EX),
        .instruction(instruction_ID),
        .instruction_out(instruction_EX)
    );

    // Forwarding Unit
    forwarding_unit fu(
        .rs_EX(rs_address),
        .rt_EX(rt_address),
        .rd_MEM(reg_des_address_MEM),
        .rd_WB(reg_des_address_WB),
        .RegWrite_MEM(RegWrite_EX),
        .RegWrite_WB(RegWrite_MEM),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    always @* begin
        reg_des_address = regDest_EX ? rd_address : rt_address;
    end

    reg [31:0] alu_inp_2, alu_inp_1;
    reg [31:0] branch_address;

    always @* begin
        // Forwarding logic for ALU inputs   (ALUSrc_EX) ? {SignExtend_EX[15], instruction_EX[14:0]} : rt_EX;  
	//.MemRead_EX(MemtoReg_EX),
        case (forwardA)
            2'b00: alu_inp_1 = (MemtoReg_EX) ?data_out:rs_EX;
            2'b01: alu_inp_1 = ans_1;
            2'b10: alu_inp_1 = rd_final_data;
	    2'b11: alu_inp_1 = data_out;
        endcase

        case (forwardB)
            2'b00: alu_inp_2 = (ALUSrc_EX) ? {SignExtend_EX[15], instruction_EX[14:0]} : rt_EX;
            2'b01: alu_inp_2 = ans_1;
            2'b10: alu_inp_2 = rd_final_data;
	    2'b11: alu_inp_1 = data_out;
        endcase

        if (branch_EX == 1) begin
            branch_address[14:0] = instruction_EX[15:0];
            branch_address = branch_address << 2;
            branch_address = branch_address + pc;
        end else
            branch_address = 0;

        jumpPC = 0;
        jumpPC = instruction[25:0];
        jumpPC = jumpPC << 2;
    end

    alu_pipeline calc(
        .ans(ans),
        .zero(zero),
        .a(alu_inp_1),
        .b(alu_inp_2),
        .aluOP(ALUOp_EX),
        .sel(instruction_EX[5:0])
    );

    //=====================================> EX/MEM <==============================
    EX_MEM_pipeline_reg EX_MEM_CALL(
        .clk(clk),
        .reset(rst),

        .alu_data1(branch_address), 
        .alu_data2(ans),
        .rt(rt_EX),
        .zero(zero),
        .reg_des_address(reg_des_address),

        .alu_data_out1(branch_address_1),
        .alu_data_out2(ans_1),
        .rt_out(rt_1),
        .zero_out(zero_MEM),
        .reg_des_address_out(reg_des_address_MEM),

        .jump(jump_EX),
        .branch(branch_EX),
        .MemRead(MemRead_EX),
        .MemtoReg(MemtoReg_EX),
        .MemWrite(MemWrite_EX),
        .RegWrite(RegWrite_EX),

        .jump_out(jump_MEM),
        .branch_out(branch_MEM),
        .MemRead_out(MemRead_MEM),
        .MemtoReg_out(MemtoReg_MEM),
        .MemWrite_out(MemWrite_MEM),
        .RegWrite_out(RegWrite_MEM)
    );

    reg PCSrc;
    always @(*) begin
        PCSrc = zero_MEM & branch_MEM;

        tempPC = branch_address_1;
    end
    assign branchCheck = zero_MEM & branch_MEM;
    assign pc = rst ? 32'b0 : (branchCheck) ? tempPC : pc_out;

    // Calling Data Memory
    data_mem DataMemCall(
        .address(ans_1),
        .data_in(rt_1),
        .data_out(data_out),
        .we(MemWrite_MEM),
        .clk(clk)
    );

    //========================>MEM_WB Call<=================================
    MEM_WB_pipeline_reg MEM_WB(
        .clk(clk),
        .reset(rst),

        .alu_data(ans_1),
        .rd(rd),
        .rd_address(reg_des_address_MEM),
        .data(data_out),

        .RegWrite(RegWrite_MEM),
        .MemtoReg(MemtoReg_MEM),

        .rd_out(rd),
        .alu_data_out(ans_final),
        .rd_address_out(reg_des_address_WB),
        .data_out(data_out_WB),

        .RegWrite_out(RegWrite_WB),
        .MemtoReg_out(MemtoReg_WB)
    );
    assign rd_final_data = MemtoReg_WB ? data_out_WB : ans_final;

    initial begin
        tempPC = 0;
        PCSrc = 0;
        control = 0;
        #100;
        control = 1;
    end

endmodule
