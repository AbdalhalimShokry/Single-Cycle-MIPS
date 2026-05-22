module ALU (
    input signed [31:0] alu_input_1, alu_input_2,
    input [2:0] alu_sel,
    output zero_flag,
    output reg overflow_flag,
    output reg signed [31:0] alu_res
    );
    
    always @(*)
        begin
            overflow_flag = 1'b0;
            alu_res = 32'd0;
            
            case(alu_sel)
                3'b000: // ADD
                    begin
                        alu_res = alu_input_1 + alu_input_2;
                        // For ADD, if sign of 1st argument = sign of 2nd argument ≠ sign of res => Overflow
                        overflow_flag = ((alu_input_1[31] & alu_input_2[31] & ~alu_res[31]) | (~alu_input_1[31] & ~alu_input_2[31] & alu_res[31]));
                    end    
                3'b001: // SUB
                    begin
                        alu_res = alu_input_1 - alu_input_2;
                        // For SUB, if sign of 1st argument ≠ sign of 2nd argument = sign of res => Overflow
                        overflow_flag = ((alu_input_1[31] & ~alu_input_2[31] & ~alu_res[31]) | (~alu_input_1[31] & alu_input_2[31] & alu_res[31]));
                    end
                3'b010: alu_res = alu_input_1 & alu_input_2;
                3'b011: alu_res = alu_input_1 | alu_input_2;
                3'b100: alu_res = alu_input_1 ^ alu_input_2;
                3'b101: alu_res = ($signed(alu_input_1) < $signed(alu_input_2)) ? 32'd1 : 32'd0; // Set on less than (SLT)
                default: alu_res = 32'd0;
            endcase
        end
        assign zero_flag = (alu_res == 32'd0);
endmodule