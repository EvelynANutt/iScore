`define SWIDTH 20

module song_progression #(parameter X_COORD = 11'd820, Y_COORD = 10'd72, BOX_WIDTH = 8'd50) (
    input wire reset_player, song_done, play, clk, rst,
    input wire [10:0] x,
    input wire [9:0] y,
    output wire pixel_on,
)

wire [`SWIDTH-1:0] time_ns, next_time_ns, time_select;
dffre #(`SWIDTH) count_ns(.clk(clk), .r(rst), .en(play), .d(time_select), .q(time_ns));
assign next_time_ns = time_ns + 20'd10;
assign time_select = ((next_time_ns > 20'd999999) || reset_player || song_done) ? 20'd0 : next_time_ns;

wire pixel_on_ms, pixel_on_hs, pixel_on_ts, pixel_on_s, pixel_on_tens, pixel_on_colon;
wire next_count_ms, next_count_hs, next_count_ts, next_count_s, next_count_tens;

counter_flop #(.X_BOX(X_COORD), .Y_BOX(Y_COORD), .COUNT_SIZE(5'd20)) count_ms(
    .count_enable_in(time_ns),
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .count_enable_out(next_count_ms),
    .pixel_on(pixel_on_ms)
);

counter_flop #(.X_BOX(X_COORD - (BOX_WIDTH * 4'd1)), .Y_BOX(Y_COORD), .COUNT_SIZE(5'd4)) count_hs(
    .count_enable_in(next_count_ms),
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .count_enable_out(next_count_hs),
    .pixel_on(pixel_on_hs)
);

counter_flop #(.X_BOX(X_COORD - (BOX_WIDTH * 4'd2)), .Y_BOX(Y_COORD), .COUNT_SIZE(5'd4)) count_ts(
    .count_enable_in(next_count_hs),
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .count_enable_out(next_count_ts),
    .pixel_on(pixel_on_ts)
);

counter_flop #(.X_BOX(X_COORD - (BOX_WIDTH * 4'd3) - 5'd20), .Y_BOX(Y_COORD), .COUNT_SIZE(5'd4)) count_s(
    .count_enable_in(next_count_ts),
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .count_enable_out(next_count_s),
    .pixel_on(pixel_on_s)
);

counter_flop #(.X_BOX(X_COORD - (BOX_WIDTH * 4'd4) - 5'd20), .Y_BOX(Y_COORD), .COUNT_SIZE(5'd4)) count_tens(
    .count_enable_in(next_count_s),
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .count_enable_out(next_count_tens),
    .pixel_on(pixel_on_tens)
);

colon_display #(.X_BOX(11'd700), .Y_BOX(Y_COORD)) colon(
    .pixel_x(x),
    .pixel_y(y),
    .pixel_on(pixel_on_colon)
);

assign pixel_on = pixel_on_ms || pixel_on_hs || pixel_on_ts || pixel_on_s || pixel_on_tens || pixel_on_colon;

endmodule