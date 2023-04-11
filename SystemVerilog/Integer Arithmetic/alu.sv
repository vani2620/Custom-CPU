module alu #(
    parameter int DATA_WIDTH = 64,
    parameter int SHIFT_AMT = $clog2(DATA_WIDTH)
)(
    input [DATA_WIDTH - 1:0] data_in_a,
    input [DATA_WIDTH - 1:0] data_in_b,

    input [SHIFT_AMT - 1:0] shift_code,

    input [4:0] func_code,

    output [DATA_WIDTH - 1:0] data_out
);
// verilog_lint: waive-start line-length
always_comb begin
    case (func_code)
        5'b00000: result = $unsigned(data_in_a) + $unsigned(data_in_b); //ADD unsigned
        5'b00001: result = $signed(data_in_a) + $signed(data_in_b); //ADD Signed
        5'b00010: result = $unsigned(data_in_a) - $unsigned(data_in_b); //SUB
        5'b00011: result = $signed(data_in_a) - $signed(data_in_b); //SUB Signed
        5'b00100: result = data_in_a ^ data_in_b; //bitwise XOR
        5'b00101: result = data_in_a & data_in_b; //bitwise AND
        5'b00110: result = data_in_a | data_in_b; //bitwise OR
        5'b00111: result = ($unsigned(data_in_a) < $unsigned(data_in_b)) ? 64'h1 : 64'h0; //Set Less Than
        5'b01000: result = ($signed(data_in_a) < $signed(data_in_b)) ? 64'h1: 64'h0;
        5'b01001: result = ~data_in_a + 1;
        default: data_out = 64'h0;
    endcase
end
// verilog_lint: waive-stop line-length
endmodule
