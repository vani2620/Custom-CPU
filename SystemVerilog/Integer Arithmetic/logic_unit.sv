`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style
`include "logic_ops.svh"

module logic_unit #(
    parameter int DATA_WIDTH = 32
)(
    input wire [LOGIC_OPCODE_WIDTH-1:0] func_code,
    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire [DATA_WIDTH - 1:0] data_in_b,

    output reg [DATA_WIDTH - 1:0] data_out
);

always_comb begin
    case(func_code)
        OR: data_out = data_in_a | data_in_b;
        AND: data_out = data_in_a & data_in_b;
        XOR: data_out = data_in_a ^ data_in_b;
        default: data_out = 0;
    endcase
end

endmodule

`default_nettype wire
