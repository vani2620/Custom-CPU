//From http://fpgacpu.ca/fpga/Width_Adjuster.html

module width_adjuster #(
    parameter int INPUT_WIDTH = 64,
    parameter int OUTPUT_WIDTH = 32,
    parameter bit SIGNED = 0
)(
    input wire [INPUT_WIDTH-1:0] data_in,

    output reg [OUTPUT_WIDTH-1:0] data_out
);

// verilog_lint: waive-start parameter-name-style
// verilog_lint: waive-start line-length
localparam int PAD_WIDTH = OUTPUT_WIDTH - INPUT_WIDTH;

generate
    if (PAD_WIDTH == 0) begin: gen_zero
        always_comb begin
            data_out = data_in;
        end
    end: gen_zero

    if (PAD_WIDTH > 0) begin: g_s_ext
        localparam logic PAD_ZEROS = {PAD_WIDTH{1'b0}};
        localparam logic PAD_ONES = {PAD_WIDTH{1'b1}};
        always_comb begin
            data_out = ((SIGNED != 0) && (data_in[INPUT_WIDTH-1] == 1'b1)) ? {PAD_ONES, data_in} : {PAD_ZEROS, data_in};
        end
    end: g_s_ext

    if (PAD_WIDTH < 0) begin: g_truncate
        always_comb begin
            data_out = data_in[OUTPUT_WIDTH-1:0];
        end
    end: g_truncate
endgenerate

endmodule
