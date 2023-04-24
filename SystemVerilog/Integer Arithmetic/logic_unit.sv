module logic_unit #(
    parameter int DATA_WIDTH = 64,
    parameter int SH_CTRL_WIDTH = $clog2(DATA_WIDTH),
    parameter int OPCODE_WIDTH = 7
)(
    input [OPCODE_WIDTH - 1:0] lu_opcode,
    input [DATA_WIDTH - 1:0] data_in_a,
    input [DATA_WIDTH - 1:0] data_in_b,

    input busy,

    output [DATA_WIDTH - 1:0] data_out,
    output valid
);



endmodule
