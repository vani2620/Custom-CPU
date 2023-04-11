module alu #(
    parameter int DATA_WIDTH = 64,
    parameter int SHIFT_AMT = $clog2(DATA_WIDTH)
)(
    input [DATA_WIDTH - 1:0] data_in_a,
    input [DATA_WIDTH - 1:0] data_in_b,

    input [SHIFT_AMT - 1:0] shift_code,

    input invert_a,
    input invert_b,
    input invert_out,
    input or_enable,
    input carry_in,

    output [DATA_WIDTH - 1:0] data_out,
    output carry_out
);

endmodule
