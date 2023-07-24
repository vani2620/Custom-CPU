`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style


module multiplier #(
    parameter int DATA_WIDTH = 64
)(
    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire [DATA_WIDTH - 1:0] data_in_b,

    output reg [2*DATA_WIDTH - 1:0] data_out
);

always_comb begin
    data_out = data_in_a * data_in_b;
end

endmodule

`default_nettype wire
