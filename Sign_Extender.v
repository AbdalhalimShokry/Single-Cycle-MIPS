module Sign_Extender(
    input [15:0] sign_extender_input,
    output [31:0] sign_extender_output
    );

    assign sign_extender_output = {{16{sign_extender_input[15]}}, sign_extender_input};
endmodule