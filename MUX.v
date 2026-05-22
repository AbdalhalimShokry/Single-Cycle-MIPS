module MUX2x1(
    input [31:0] mux_input_1, mux_input_2,
    input mux_sel,
    output [31:0] mux_out
    );
    
    assign mux_out = mux_sel? mux_input_2 : mux_input_1;
endmodule