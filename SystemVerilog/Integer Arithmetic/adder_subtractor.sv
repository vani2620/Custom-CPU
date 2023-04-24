module adder_subtractor #(
    parameter int WORD_WIDTH = 0
)(
    input [1:0] mode,

    input [WORD_WIDTH - 1:0] data_in_a,
    input [WORD_WIDTH - 1:0] data_in_b,
    input carry_in,

    output [WORD_WIDTH - 1:0] sum,
    output carry_out
);
// verilog_lint: waive-start line-length
always_comb begin
    case (mode)
        2'b00: {carry_out, sum} = $unsigned(data_in_a) + $unsigned(data_in_b) + $unsigned(carry_in);
        2'b01: {carry_out, sum} = $signed(data_in_a) + $signed(data_in_b) + $signed(carry_in);
        2'b10: {carry_out, sum} = $unsigned(data_in_a) - $unsigned(data_in_b) - $unsigned(carry_in);
        2'b11: {carry_out, sum} = $signed(data_in_a) - $signed(data_in_b) - $signed(carry_in);
        default: {carry_out, sum} = $unsigned(data_in_a) + $unsigned(data_in_b) + $unsigned(carry_in);
    endcase
end
// verilog_lint: waive-stop line-length
endmodule
