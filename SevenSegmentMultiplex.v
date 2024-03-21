module CustomSevenSegmentMultiplex(
    input wire clk,
    input wire rst,
    input wire [15:0] binary_input,
    output reg [6:0] seg_output,
    output reg [3:0] anode_output
);
    reg update_flag;
    reg [3:0] digit_counter = 4'b0000;
    reg [2:0] counter;
    reg [19:0] refresh_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            refresh_count <= 0;
            update_flag = 0;
        end else begin
            counter <= counter + 1'b1;
            refresh_count <= refresh_count + 1'b1;
            if(refresh_count == 100_000) begin
                refresh_count <= 0;
                update_flag = 1;
            end else
                update_flag = 0;
        end
    end

    reg [6:0] seven_seg_patterns [15:0];

    initial begin
        seven_seg_patterns[0] = 7'b1000000; // 0
        seven_seg_patterns[1] = 7'b1111001; // 1
        seven_seg_patterns[2] = 7'b0100100; // 2
        seven_seg_patterns[3] = 7'b0110000; // 3
        seven_seg_patterns[4] = 7'b0011001; // 4
        seven_seg_patterns[5] = 7'b0010010; // 5
        seven_seg_patterns[6] = 7'b0000010; // 6
        seven_seg_patterns[7] = 7'b1111000; // 7
        seven_seg_patterns[8] = 7'b0000000; // 8
        seven_seg_patterns[9] = 7'b0010000; // 9
        seven_seg_patterns[10] = 7'b0001000; // 9
        seven_seg_patterns[11] = 7'b0000011; // 9
        seven_seg_patterns[12] = 7'b1000110; // 9
        seven_seg_patterns[13] = 7'b0100001; // 9
        seven_seg_patterns[14] = 7'b0000110; // 9
        seven_seg_patterns[15] = 7'b0001110; // 9
    end

    always @(posedge clk) begin
        if(update_flag == 1) begin
            if (digit_counter == 4'd3)
                digit_counter <= 4'd0;
            else
                digit_counter <= digit_counter + 1;
        end
        case(digit_counter)
            4'd0: begin
                seg_output <= seven_seg_patterns[binary_input[3:0]];
                anode_output <= 4'b1110;
            end
            4'd1: begin
                seg_output <= seven_seg_patterns[binary_input[7:4]];
                anode_output <= 4'b1101;
            end
            4'd2: begin
                seg_output <= seven_seg_patterns[binary_input[11:8]];
                anode_output <= 4'b1011;
            end
            4'd3: begin
                seg_output <= seven_seg_patterns[binary_input[15:12]];
                anode_output <= 4'b0111;
            end
        endcase
    end
endmodule

