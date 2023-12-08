module counter_flop #(parameter X_BOX = 11'd0, Y_BOX = 10'd0, COUNT_SIZE = 5'd0) (
    input wire [COUNT_SIZE-1:0] count_enable_in,
    input wire clk, rst,
    input wire [10:0] x,
    input wire [9:0] y,
    input wire [19:0] time_ns,
    output wire [3:0] count_enable_out,
    output wire pixel_on
);

wire [3:0] current_time, next_time, time_select;
wire [19:0] prev_count;
wire small_enable_num;
wire big_enable_num;
wire actual_enable;

assign prev_count = (COUNT_SIZE == 5'd20) ? 20'd999999 : 20'd9;
assign small_enable_num = (count_enable_in >= prev_count) ? 1'd1 : 1'd0;
assign big_enable_num = (((time_ns * count_enable_in) == 24'd9000027) || ((time_ns * count_enable_in) == 24'd9000036))  ? 1'd1 : 1'd0;
assign actual_enable = (COUNT_SIZE == 5'd20) ? small_enable_num : big_enable_num;

dffre #(4) counter(.clk(clk), .r(rst), .en(actual_enable), .d(time_select), .q(current_time));
assign next_time = current_time + 4'd1;
assign time_select = (next_time <= 4'd9) ? next_time : 4'd0;
assign count_enable_out = current_time;

char_display #(.X_BOX(X_BOX), .Y_BOX(Y_BOX)) digit_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr((current_time * 9'd8) + 9'h180),
    .pixel_on(pixel_on)
);

endmodule