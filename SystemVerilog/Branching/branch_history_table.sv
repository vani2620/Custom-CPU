`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module branch_history_table #(
    parameter int HISTORY_DEPTH = 128,
    parameter int ADDR_WIDTH = 32
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire [ADDR_WIDTH-1:0] branch_address,
    input wire last_branch_result
);

endmodule

`default_nettype wire
