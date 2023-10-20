`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

`include "operations.svh"

module shifter #(
    parameter int DATA_WIDTH = 32,
    parameter int SHIFT_WIDTH = $clog2(DATA_WIDTH)
)(
    input wire [SHIFT_OPCODE_WIDTH-1:0] mode,
    input wire [SHIFT_WIDTH-1:0] shift_amt,

    input wire [DATA_WIDTH-1:0] data_in,


    output reg [DATA_WIDTH-1:0] data_out
);

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

always_comb begin
    case(mode)
        LLOG: data_out = data_llog[DATA_WIDTH-1:0];
        RLOG: data_out = data_rlog[DATA_WIDTH-1:0];
        LROT: data_out = data_lrot[DATA_WIDTH-1:0];
        RROT: data_out = data_rrot[DATA_WIDTH-1:0];
        RAR: data_out = data_rar[DATA_WIDTH-1:0];
        default: data_out = data;
    endcase
end

endmodule

`default_nettype wire
