module Control_Unit(
    input [5:0] control_instruction,
    output reg ctrl_unit_fault_flag, // Used to prevent any unused/illegal instructions
    output reg reg_dst, jump, branch_equal, branch_not_equal, mem_read,
    output reg  mem_to_reg, mem_write, alu_src, reg_write,
    output reg [1:0] alu_op
    );

    always @(*)
    begin
        ctrl_unit_fault_flag = 1'b0;
        
        reg_dst             = 1'b0;
        jump                = 1'b0;
        branch_equal        = 1'b0;
        branch_not_equal    = 1'b0;
        mem_read            = 1'b0;
        mem_to_reg          = 1'b0;
        mem_write           = 1'b0;
        alu_src             = 1'b0;
        reg_write           = 1'b0;
        alu_op              = 2'b00;
        
        case(control_instruction)
            6'b000000: // R-Format Instructions
                begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = 2'b10;
                end
            6'b100011: // Load Word (LW)
                begin
                    alu_src = 1'b1;
                    mem_read = 1'b1;
                    mem_to_reg = 1'b1;
                    reg_write = 1'b1;
                    alu_op = 2'b00;
                end
            6'b101011: // Store Word (SW)
                begin
                    alu_src = 1'b1;
                    mem_write = 1'b1;
                    alu_op = 2'b00;
                end
            6'b000100: // Branch if Equal (BEQ)
                begin
                    branch_equal = 1'b1;
                    alu_op = 2'b01;
                end
            6'b000101: // Branch if not Equal (BNE)
            begin
                branch_not_equal = 1'b1;
                alu_op = 2'b01;
            end
            6'b000010: // Jump
                begin
                    jump = 1'b1;
                end
            6'b001000: // ADDI (Add Immediate)
                begin
                    alu_src = 1'b1;
                    reg_write = 1'b1;
                    alu_op = 2'b00; // It is like normal add but with an immediate
                end
            default: ctrl_unit_fault_flag = 1'b1; // Unused/illegal instruction
        endcase
    end 
endmodule