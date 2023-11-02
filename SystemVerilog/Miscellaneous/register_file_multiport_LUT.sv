// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

/*TODO
 *Ensure write and read data is packed
 *Remove references to state & create separate module for regfile instantiating this
 *or higher level module implementing this for state-tracking
 *Set all default param values to 0
 *Change ADDR_WIDTH to localparam
*/

`default_nettype none

module register_file_multiport_LUT #(
    parameter int DATA_WIDTH = 8,
    parameter int REG_COUNT = 16,
    parameter int ADDR_WIDTH = $clog2(REG_COUNT),
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 8,
    parameter string INIT_FILE = "",
    parameter string RAM_STYLE = "block"
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire [DATA_WIDTH * WRITE_PORTS - 1:0] wr_data,

    input wire [WRITE_PORTS - 1:0] wr_data_en,
    input wire [ADDR_WIDTH * WRITE_PORTS - 1:0] wr_addr,

    input wire [READ_PORTS - 1:0] rd_data_en,
    input wire [ADDR_WIDTH * READ_PORTS - 1:0] rd_addr,


    output reg [DATA_WIDTH * READ_PORTS - 1:0] rd_data
);



reg [DATA_WIDTH - 1:0] data_reg_file [REG_COUNT]; //Register file for holding data

//Initialize memory to either all zeros or contents of hex file
initial begin
    if (INIT_FILE == "") begin
        for (int i = 0; i < REG_COUNT; i = i + 1) begin
            data_reg_file[i] = 'b0;
        end
    end
    else if (INIT_FILE != "") begin
        $readmemh({INIT_FILE, ".hex"}, data_reg_file);
    end
end

//Reset & write logic
always_ff @(posedge clk or negedge sync_rst_n) begin
    if (!sync_rst_n) begin
        for (int i = 0; i < REG_COUNT; i = i + 1) begin
            data_reg_file[i] <= 'b0;
        end
    end
    else if (clk_en) begin
        for (int i = 0; i < WRITE_PORTS; i = i + 1) begin
            if(wr_data_en[i]) begin
                data_reg_file[wr_addr[(i + 1)  * ADDR_WIDTH - 1 -: ADDR_WIDTH]] <= wr_data[(i + 1) * ADDR_WIDTH - 1 -: ADDR_WIDTH];
           end
        end
    end
end

//Read logic
always_comb begin
    for (int i = 0; i < READ_PORTS; i = i + 1) begin
        if (clk_en && rd_data_en[i]) begin
            rd_data[i] = data_reg_file[rd_addr[(i + 1) * ADDR_WIDTH - 1 -: ADDR_WIDTH]];
        end
    end
end

endmodule

`default_nettype wire
