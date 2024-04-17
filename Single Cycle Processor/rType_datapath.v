module rType_datapath();
    reg clk;
    wire [31:0] pc , pc_out;
    wire [31:0] instruction;
    reg rst;
    wire zero;
    wire [31:0] rs, rt, rd, ans;
    //temp var
    reg [4:0] wr;
    reg [4:0] tempD;   
    //control signals
    wire regDest, jump, branch, MemRead, MemWrite, ALUSrc, RegWrite;wire [1:0]  MemtoReg;
    wire [1:0] ALUOp;
    wire branchCheck;
    reg [31:0] tempPC, jumpPC;
    wire [31:0] data_out;
    //for program counter
    PC uut (
        .pc(pc),
        .jump_address(jumpPC),
        .pc_out(pc_out),
        .jump(jump),
        .clk(clk),
        .rst(rst)
    );

    //get instruction
    instr_rom getInstruction (.address(pc), .instr(instruction));
    
    //set control signals
    control_sig cs(
        .regDest(regDest),
        .jump(jump),
        .branch(branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .opcode(instruction[31:26])
    );

    //register memory, get data and also update register memory if needed 
    reg_file getData(
        .rdata1(rs),
        .rdata2(rt),
        .rs1(instruction[25:21]),
        .rs2(instruction[20:16]),
        .rd(tempD), 
        .write_data(rd),
        .clk(clk),
        .mem_write(RegWrite)
    );

    // Mux for selecting between rs and rt based on regDest
    always @* begin
        tempD = regDest ? instruction[15:11] : instruction[20:16];
    end

    // Mux for selecting between immediate and rt based on ALUSrc
    reg [31:0] temp2;
    always @* begin
        if (ALUSrc == 1) begin
            temp2[14:0] = instruction[14:0];
            temp2[31] = instruction[15];
        end
        else begin
            temp2 = rt;
        end
    end

    // Mux for branch calculation
    always @* begin
        if (branch == 1) begin
            tempPC = (instruction[15:0] << 2) + pc; // Branch offset calculation
        end
        jumpPC = instruction[25:0] << 2; // Jump address calculation
    end

    reg PCSrc;
    always @(posedge clk) begin
        PCSrc = zero & branch;  // Checking for branch condition
        if (PCSrc)
            tempPC  = tempPC;  // Branch/jump to address if condition met
    end
    
    // Mux for selecting the PC value
    assign pc = rst ? 32'b0 : (PCSrc ? tempPC : pc_out); // Reset Mux

    // Mux for selecting the destination register value
   // assign rd = (MemtoReg == 2'b01) ? data_out : ans; // Mux After Data Memory (for lw or alu)
   wire [31:0]lui_temp;  lui LUIc(instruction[15:0], lui_temp);
   reg condLUI;
always@(*) begin
   if(rs == rt && MemtoReg == 2'b10)begin
		   condLUI = 1'b1;
	end
	else condLUI = 1'b0;
end	 
	assign rd = (condLUI) ? lui_temp : rd;
	//assign rd = lui_temp;
    // ALU calculation
    alu calc(
        .ans(ans),
        .zero(zero),
        .a(rs),
        .b(temp2),
        .aluOP(ALUOp),
        .sel(instruction[5:0])
    );

    // Data memory access
    data_mem DataMemCall(
        .address(ans), 
        .data_in(temp2),
        .data_out(data_out),  
        .we(MemWrite), 
        .clk(clk)
    );
    
    initial begin
        rst = 1; clk = 0;
        tempPC = 0;
        PCSrc = 0;
        #100;
        rst = 0; 
    end

    always #50 clk = ~clk;

endmodule

