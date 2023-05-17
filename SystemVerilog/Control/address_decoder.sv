module address_decoder #(
    parameter int ADDR_WIDTH = 0,
    parameter int SELECT_WIDTH = 0
)(
    input wire [ADDR_WIDTH - 1:0] addr_in,
    input wire [ADDR_WIDTH - 1:0] base_addr,
    input wire [ADDR_WIDTH - 1:0] bound_addr,

    output reg [SELECT_WIDTH - 1:0] select_wire
);
endmodule
