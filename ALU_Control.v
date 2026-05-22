module ALU_Control(
    input [5:0] funct,
    input [1:0] alu_op,
    output reg alu_ctrl_fault_flag,
    output reg [2:0] alu_sel
    );
    
    always @(*)
        begin
            alu_ctrl_fault_flag = 1'b0;
            alu_sel = 3'b000;
            
            case(alu_op)
                2'b00: alu_sel = 3'b000; // ADD
                2'b01: alu_sel = 3'b001; // SUB
                2'b10: // Depend on function field (R-Type)
                    begin
                        case(funct)
                            6'd32: alu_sel = 3'b000; // ADD
                            6'd34: alu_sel = 3'b001; // SUB
                            6'd36: alu_sel = 3'b010; // AND
                            6'd37: alu_sel = 3'b011; // OR
                            6'd38: alu_sel = 3'b100; // XOR
                            6'd42: alu_sel = 3'b101; // SLT
                            default: alu_ctrl_fault_flag = 1'b1; // To indicate unused instruction
                        endcase
                    end  
                default: alu_ctrl_fault_flag = 1'b1; // To indicate unused instruction
            endcase
        end
endmodule