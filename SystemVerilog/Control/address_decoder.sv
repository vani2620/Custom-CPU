`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module address_decoder #(
    parameter int ADDR_WIDTH = 0,
    parameter int SELECT_WIDTH = 0
)(
    input wire [ADDR_WIDTH - 1:0] addr_in,
    input wire [ADDR_WIDTH - 1:0] base_addr,
    input wire [ADDR_WIDTH - 1:0] bound_addr,

    output reg [SELECT_WIDTH - 1:0] addr_hit
);

always_comb begin
    if (addr_in >= base_addr && addr_in < bound_addr) begin
        addr_hit = 1;
    end else begin
        addr_hit = 0;
    end
end

endmodule

`default_nettype wire
