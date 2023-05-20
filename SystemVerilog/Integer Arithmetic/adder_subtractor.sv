//Follows design of adder subtractor module here: http://fpgacpu.ca/fpga/Adder_Subtractor_Binary.html
`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module adder_subtractor #(
    parameter int DATA_WIDTH = 16
)(
    input mode, //add or subtract

    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire [DATA_WIDTH - 1:0] data_in_b,
    input wire carry_in,

    output reg [DATA_WIDTH - 1:0] sum,
    output wire [DATA_WIDTH - 1:0] carries,
    output reg carry_out,
    output reg overflow
);


localparam logic ZERO = {DATA_WIDTH{1'b0}};
localparam logic ONE = {{DATA_WIDTH - 1{1'b0}}, 1'b1};

initial begin
    sum = ZERO;
    carry_out = 1'b0;
    overflow = 1'b0;
end
wire [DATA_WIDTH - 1: 0] c_in_ext_unsigned;
wire [DATA_WIDTH - 1: 0] c_in_ext_signed;

width_adjuster #(
    .INPUT_WIDTH (1),
    .OUTPUT_WIDTH (DATA_WIDTH),
    .SIGNED (0)
)extend_c_in_unsigned(
    .data_in (carry_in),
    .data_out (c_in_ext_unsigned)
);

width_adjuster #(
    .INPUT_WIDTH (1),
    .OUTPUT_WIDTH (DATA_WIDTH),
    .SIGNED (1)
)extend_c_in_signed(
    .data_in (carry_in),
    .data_out (c_in_ext_signed)
);

reg [DATA_WIDTH - 1:0] b_selected = ZERO;
reg [DATA_WIDTH - 1:0] offset = ZERO;
reg [DATA_WIDTH - 1:0] carry_in_selected = ZERO;

always_comb begin
    b_selected = (mode == 1'b0) ? data_in_b : ~data_in_b;
    offset = (mode == 1'b0) ? ZERO : ONE;
    carry_in_selected =  (mode == 1'b0) ? c_in_ext_unsigned : c_in_ext_signed;
end

always_comb begin
    {carry_out, sum} = {1'b0, data_in_a} + {1'b0, data_in_b} + {1'b0, offset} + {1'b0, carry_in_selected};
end

carry_extractor #(
    .DATA_WIDTH (DATA_WIDTH)
)extractor(
    .data_in_a (data_in_a),
    .data_in_b (data_in_b),
    .sum (sum),
    .carries (carries)
);

always_comb begin
    overflow = (carries[DATA_WIDTH - 1] != carry_out);
end

endmodule

`default_nettype wire
