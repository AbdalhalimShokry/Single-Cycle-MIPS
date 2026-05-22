`timescale 1ns / 1ps
module Top_Module(
    input clk, rst_n
    );
    
    // Wires Declaration

    // Program Counter (PC) I/P
    wire [31:0] next_pc;

    // Program Counter (PC) O/Ps
    wire [31:0] current_pc; // Also Instruction Memory I/P
    wire [31:0] pc_by_4; // current_pc + 32'd4

    // Instruction Memory (IM) O/Ps
    wire instr_mem_fault_flag; // Can be used in future adjustments and detection
    wire [31:0] instruction; // Also I/P of some Modules

    wire [31:0] jump_address;
    assign jump_address = {pc_by_4[31:28], instruction[25:0], 2'b00};

    wire [15:0] immediate_field; // Used in I-Format instructions
    assign immediate_field = instruction[15:0];

    wire [31:0] immediate_field_extended; // MUXed with read_data_2 to get ALU 2nd input
    wire [31:0] immediate_field_extended_SL2; // immediate_field_extended Shifted Left By 2

    // Register File (RF) I/Ps
    wire [4:0] read_reg_1;
    assign read_reg_1 = instruction[25:21];

    wire [4:0] read_reg_2;
    assign read_reg_2 = instruction[20:16];

    wire [4:0] write_reg_input_2;
    assign write_reg_input_2 = instruction[15:11]; // MUXed with read_reg_2 to get Write Register
    
    wire [4:0] write_reg; // O/P of MUXing read_reg_2 & write_reg_input_2
    wire [31:0] reg_file_write_data;

    // Register File (RF) O/Ps
    wire [31:0] reg_file_read_data_1; // Also ALU 1st I/P
    wire [31:0] reg_file_read_data_2; // Also I/P of DM Write Data

    // Control Unit (CU) I/P
    wire [5:0] control_instruction;
    assign control_instruction = instruction[31:26];

    // Control Unit (CU) O/P (Control Signals)
    wire ctrl_unit_fault_flag;
    wire reg_dst, jump, branch_equal, branch_not_equal, mem_read;
    wire mem_to_reg, mem_write, alu_src, reg_write;
    wire [1:0] alu_op;
    
    wire branch_sel; // Result of ANDing Branch Control Signals with ALU Zero Flag
    assign branch_sel = ((branch_equal & zero_flag) | (branch_not_equal & ~zero_flag));

    // ALU Control I/Ps
    wire [5:0] funct;
    assign funct = instruction[5:0];

    // ALU Control O/Ps
    wire alu_ctrl_fault_flag;
    wire [2:0] alu_sel;

    // ALU I/P
    wire [31:0] alu_input_2;

    // ALU O/Ps
    wire zero_flag;
    wire overflow_flag;
    wire [31:0] alu_res; // Also I/P of DM Address & MUXed with DM Read Data to get RF Write Data

    // Data Memory (DM) O/Ps
    wire data_mem_fault_flag;
    wire [31:0] data_mem_read_data;
    
    // Internal Wires
    wire [31:0] branch_pc_by_4; // O/P of Adding pc_by_4 and immediate_field_extended_SL2
    wire[31:0] branch_jump; // O/P of Muxing branch_pc_by_4 and pc_by_4

    // -----------------------------------------------------------------------------------------------------------------------------------------------------------------

    // Modules

    (* dont_touch = "true" *) Program_Counter PC(
        .next_pc(next_pc),
        .clk(clk),
        .rst_n(rst_n),
        .overflow_flag(overflow_flag),
        .alu_ctrl_fault_flag(alu_ctrl_fault_flag),
        .data_mem_fault_flag(data_mem_fault_flag),
        .ctrl_unit_fault_flag(ctrl_unit_fault_flag),
        .current_pc(current_pc)
    );

    (* dont_touch = "true" *) Instruction_Memory IM(
        .current_pc(current_pc),
        .instr_mem_fault_flag(instr_mem_fault_flag),
        .instruction(instruction)
    );

    (* dont_touch = "true" *) Reg_File RF(
        .read_reg_1(read_reg_1),
        .read_reg_2(read_reg_2),
        .write_reg(write_reg),
        .reg_file_write_data(reg_file_write_data),
        .reg_write(reg_write),
        .clk(clk),
        .rst_n(rst_n),
        .reg_file_read_data_1(reg_file_read_data_1),
        .reg_file_read_data_2(reg_file_read_data_2)
    );

    (* dont_touch = "true" *) Control_Unit CU(
        .control_instruction(control_instruction),
        .ctrl_unit_fault_flag(ctrl_unit_fault_flag),
        .reg_dst(reg_dst),
        .jump(jump),
        .branch_equal(branch_equal),
        .branch_not_equal(branch_not_equal),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_op(alu_op)
    );

    (* dont_touch = "true" *) ALU_Control ALU_Ctrl(
        .funct(funct),
        .alu_op(alu_op),
        .alu_ctrl_fault_flag(alu_ctrl_fault_flag),
        .alu_sel(alu_sel)
    );

    (* dont_touch = "true" *) ALU alu(
        .alu_input_1(reg_file_read_data_1),
        .alu_input_2(alu_input_2),
        .alu_sel(alu_sel),
        .zero_flag(zero_flag),
        .overflow_flag(overflow_flag),
        .alu_res(alu_res)
    );

    (* dont_touch = "true" *) Data_Memory DM(
        .address(alu_res),
        .write_data(reg_file_read_data_2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .clk(clk),
        .data_mem_fault_flag(data_mem_fault_flag),
        .data_mem_read_data(data_mem_read_data)
    );

    (* dont_touch = "true" *) Sign_Extender Immediate_Extender(
        .sign_extender_input(immediate_field),
        .sign_extender_output(immediate_field_extended)
    );

    (* dont_touch = "true" *) Shift_Left_2 Immediate_Shifting(
        .Shift_Left_2_input(immediate_field_extended),
        .Shift_Left_2_output(immediate_field_extended_SL2)
    );

    (* dont_touch = "true" *) Adder Immediate(
        .adder_input_1(pc_by_4),
        .adder_input_2(immediate_field_extended_SL2),
        .adder_output(branch_pc_by_4)
    );

    (* dont_touch = "true" *) Adder PC_Plus_4(
        .adder_input_1(32'd4),
        .adder_input_2(current_pc),
        .adder_output(pc_by_4)
    );

    (* dont_touch = "true" *) MUX2x1 MUX_RF(
        .mux_input_1(read_reg_2),
        .mux_input_2(write_reg_input_2),
        .mux_sel(reg_dst),
        .mux_out(write_reg)
    );

    (* dont_touch = "true" *) MUX2x1 MUX_ALU(
        .mux_input_1(reg_file_read_data_2),
        .mux_input_2(immediate_field_extended),
        .mux_sel(alu_src),
        .mux_out(alu_input_2)
    );

    (* dont_touch = "true" *) MUX2x1 MUX_DM(
        .mux_input_1(alu_res),
        .mux_input_2(data_mem_read_data),
        .mux_sel(mem_to_reg),
        .mux_out(reg_file_write_data)
    );

    (* dont_touch = "true" *) MUX2x1 MUX_branch_pc_by_4(
        .mux_input_1(pc_by_4),
        .mux_input_2(branch_pc_by_4),
        .mux_sel(branch_sel),
        .mux_out(branch_jump)
    );

    (* dont_touch = "true" *) MUX2x1 MUX_PC(
        .mux_input_1(branch_jump),
        .mux_input_2(jump_address),
        .mux_sel(jump),
        .mux_out(next_pc)
    );
endmodule