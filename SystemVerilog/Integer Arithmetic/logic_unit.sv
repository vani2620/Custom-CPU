`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style
`include "logic_ops.svh"

module logic_unit #(
    parameter int DATA_WIDTH = 64,
    parameter int SHF_ROT_WIDTH = $clog2(DATA_WIDTH),
    parameter int FUNC_CODE_WIDTH = 7
)(
    input wire [FUNC_CODE_WIDTH - 1:0] lu_func_code,
    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire[DATA_WIDTH - 1:0] data_in_b,

    input wire [SHF_ROT_WIDTH - 1: 0] shift_amt,

    input wire busy,

    output reg [DATA_WIDTH - 1:0] data_out,
    output reg valid
);

always_comb begin
    if (!busy) begin
        case (lu_func_code)
            OR: data_out = data_in_a | data_in_b;
            AND: data_out = data_in_a & data_in_b;
            XOR: data_out = data_in_a ^ data_in_b;
            LRS: data_out = data_in_a >> shift_amt;
            ARS: data_out = $signed(data_in_a) >>> shift_amt;
            LLS: data_out = data_in_a << shift_amt;
            default: data_out = 0;
        endcase
        valid = 1'b1;
    end
end

endmodule

`default_nettype wire
