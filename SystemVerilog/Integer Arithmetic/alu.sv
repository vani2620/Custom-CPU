`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

`include "operations.svh"

module alu #(
    parameter int DATA_WIDTH = 32
)(
    input wire [OPCODE_WIDTH - 1:0] opcode,

    input wire [DATA_WIDTH - 1:0] data_in_a,
    input wire [DATA_WIDTH - 1:0] data_in_b,
    input wire carry_in,

    input wire [SHIFT_WIDTH - 1:0] shift_amt,

    output reg [DATA_WIDTH - 1:0] data_out,
    output reg carry_out,
    output reg overflow
);

localparam int SHIFT_WIDTH = $clog2(DATA_WIDTH);

//Shifts
reg [DATA_WIDTH-1:0] data;
reg [(DATA_WIDTH*2)-1:0] data_vector = {data, data};
reg [(2*DATA_WIDTH)-1:0] signed_data_vector = {{DATA_WIDTH{data[DATA_WIDTH-1]}}, data_vector};
// Logical shifts
wire [DATA_WIDTH-1:0] data_llog = data_vector << shift_amt; // left logical shift
wire [DATA_WIDTH-1:0] data_rlog = data_vector >> shift_amt; // right logical shift
// Rotates
wire [DATA_WIDTH-1:0] data_lrot = data_vector << {1'b0, shift_amt}; // left rotate
wire [DATA_WIDTH-1:0] data_rrot = data_vector >> {1'b0, shift_amt}; // right rotate
//Arithmetic shift
wire [DATA_WIDTH-1:0] data_rar = signed_data_vector >> {1'b0, shift_amt}; // right arithmetic shift


//Logic operations
wire xor_result = data_in_a ^ data_in_b;
wire and_result = data_in_a & data_in_b;
wire or_result = data_in_a | data_in_b;
wire zero = 32'h0;

//Adder/Subtractor
wire add_sub_mode;

always_comb begin
    if (opcode == SUB) begin
        add_sub_mode = 1'b1;
    end
    else begin
        add_sub_mode = 1'b0;
    end
end

adder_subtractor #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_add_sub (
    .mode(add_sub_mode),

    .data_in_a(data_in_a),
    .data_in_b(data_in_b),
    .carry_in(carry_in),

    .sum(add_sub_result),
    .carry_out(carry_out),
    .overflow(overflow)
);

always_comb begin
    case(opcode)
        ADD: data_out = add_sub_result;
        SUB: data_out = add_sub_result;
        AND: data_out = and_result;
        OR: data_out = or_result;
        XOR: data_out = xor_result;
        LLOG: data_out = data_llog;
        RLOG: data_out = data_rlog;
        LROT: data_out = data_lrot;
        RROT: data_out = data_rrot;
        RAR: data_out = data_rar;
        default: data_out = zero;
    endcase
end

endmodule

`default_nettype wire
