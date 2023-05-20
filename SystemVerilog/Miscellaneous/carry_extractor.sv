//From http://fpgacpu.ca/fpga/CarryIn_Binary.html
`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module carry_extractor #(
    parameter int DATA_WIDTH = 0
)(
    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire [DATA_WIDTH - 1:0] data_in_b,
    input wire [DATA_WIDTH - 1:0] sum,
    output reg [DATA_WIDTH - 1:0] carries
);

initial begin
    carries = {DATA_WIDTH{1'b0}};
end

always_comb begin
    carries = data_in_a ^ data_in_b ^ sum;
end

endmodule

`default_nettype wire
