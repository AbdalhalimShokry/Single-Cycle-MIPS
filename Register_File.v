module Reg_File(
    input [4:0] read_reg_1, read_reg_2, write_reg,
    input [31:0] reg_file_write_data,
    input reg_write,
    input clk, rst_n,
    output [31:0] reg_file_read_data_1, reg_file_read_data_2
    );

    reg [31:0] registers [0:31]; // 32 registers each of 32-bit length
    integer i; // Used as index in for loop
    
    // Synchronous write
    always @(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
            begin
                for(i = 1; i < 32; i = i + 1)
                    begin
                        registers[i] <= 32'd0;
                    end
            end
            else if(reg_write && (write_reg != 5'd0))
                begin
                    registers[write_reg] <= reg_file_write_data;
                end
        end
    
    // Asynchronous read - Always on
    assign reg_file_read_data_1 = (read_reg_1 == 5'd0)? 32'd0 : registers[read_reg_1];
    assign reg_file_read_data_2 = (read_reg_2 == 5'd0)? 32'd0 : registers[read_reg_2];
endmodule