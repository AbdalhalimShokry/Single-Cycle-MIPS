module Data_Memory(
    input [31:0] address, write_data,
    input mem_write, mem_read, clk,
    output data_mem_fault_flag, // Used to indicate invalid memory access attempt
    output reg [31:0] data_mem_read_data
    );
    
    reg [31:0] memory_reg [0:1023]; // Memory array
    wire [31:0] mem_address; // Byte address -> Word address
    assign mem_address = address >> 2;
    
    // Synchronous write
    always @(posedge clk)
        begin
            if(mem_write && (mem_address < 32'd1024))
                begin 
                    memory_reg[mem_address] <= write_data;
                end
        end
    
    // Asynchronous read - Controlled
    always @(*)
        begin
            data_mem_read_data = 32'd0;
            
            if(mem_read && (mem_address < 32'd1024))
                begin 
                    data_mem_read_data = memory_reg[mem_address];
                end           
        end
        
    // If reading or writing are on and the address at this moment exceeds memory addressing limit the flag should turn on
    assign data_mem_fault_flag = ((mem_address >= 32'd1024) && (mem_read || mem_write));
endmodule