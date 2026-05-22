module Instruction_Memory(
    input [31:0] current_pc,
    output instr_mem_fault_flag,
    output [31:0] instruction
    );

    reg [31:0] memory_reg [0:255]; // Memory stores up to 256 instructions each of 32-bit length
    wire [31:0] mem_address; // Byte address -> Word address
    assign mem_address = current_pc >> 2;
    
    /* Indicates invalid instruction memory access (out-of-bounds), can be used furthur in error detection and handling
       It does not stop the CPU like other faults */ 
    assign instr_mem_fault_flag = (mem_address >= 32'd256);
    
    // For invalid access, instruction = 32'd0 which means no operation (nop) till the accessing become valid again
    assign instruction = (!instr_mem_fault_flag)? memory_reg[mem_address] : 32'd0;
endmodule