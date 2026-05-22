module Program_Counter(
    input [31:0] next_pc,
    input clk, rst_n,
    input overflow_flag, alu_ctrl_fault_flag,
    input data_mem_fault_flag, ctrl_unit_fault_flag,
    output reg [31:0] current_pc
    );
    
    wire halt;
    assign halt = (overflow_flag | alu_ctrl_fault_flag | ctrl_unit_fault_flag | data_mem_fault_flag);
    
    always @(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                begin
                    current_pc <= 32'b0;
                end
            else if(!halt)
                begin
                    current_pc <= next_pc;
                end
        end
endmodule