`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

`include "operations.svh"

module alu #(
    parameter int DATA_WIDTH = 64,
    parameter int SHIFT_AMT = $clog2(DATA_WIDTH)
)(
    input wire add_sub_mode,
    input wire [SHIFT_OPCODE_WIDTH-1:0] shift_mode,
    input wire [LOGIC_OPCODE_WIDTH-1:0] logic_opcode,

    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire [DATA_WIDTH - 1:0] data_in_b,
    input wire carry_in,

    input wire [SHIFT_AMT - 1:0] shift_amt,

    output reg [DATA_WIDTH - 1:0] data_out,
    output reg carry_out,
    output reg overflow
);

adder_subtractor #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_add_sub (
    .mode(add_sub_mode),

    .data_in_a(data_in_a),
    .data_in_b(data_in_b),
    .carry_in(carry_in),

    .sum(data_out),
    .carry_out(carry_out),
    .overflow(overflow)
);

shifter #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_shifter (
    .mode(shift_mode),

    .shift_amt(shift_amt),

    .data_in(data_in_a),

    .data_out(data_out)
);

logic_unit #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_logic_unit (
    .opcode(logic_opcode),

    .data_in_a(data_in_a),
    .data_in_b(data_in_b),

    .data_out(data_out)
);

endmodule

`default_nettype wire
