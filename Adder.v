module Adder(
    input [31:0] adder_input_1, adder_input_2,
    output [31:0] adder_output
    );
    
    assign adder_output = adder_input_1 + adder_input_2;
endmodule