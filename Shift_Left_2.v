module Shift_Left_2(
    input [31:0] Shift_Left_2_input,
    output [31:0] Shift_Left_2_output
    );

    assign Shift_Left_2_output = Shift_Left_2_input << 2;
endmodule