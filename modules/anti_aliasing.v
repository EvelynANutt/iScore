module anti_aliasing # (parameter
    SCREEN_WIDTH = 0,
    SCREEN_HEIGHT = 0,
    SCREEN_WIDTH_BITS = 0,
    SCREEN_HEIGHT_BITS = 0,
    DISPLAYED_BEATS = 0,
    SIMULTANEOUS_NOTES = 0,
    BEAT_DURATION = 0,
    BEAT_BITS = 0,
    NOTE_BITS = 0) (
    input wire reset_player, song_done, play, clk, rst,
    input [1:0] song_index, instrument_type,
    input wire [10:0] x,
    input wire [9:0] y,
    input wire [NOTE_STATE_BITS-1:0] notes [NOTES_STATE_SIZE-1:0],
    output reg [7:0] r_new, g_new, b_new
);

localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;

wire [7:0] original_r, original_g, original_b,
    top_left_r, top_left_g, top_left_b,
    top_middle_r, top_middle_g, top_middle_b,
    top_right_r, top_right_g, top_right_b,
    right_r, right_g, right_b,
    bottom_right_r, bottom_right_g, bottom_right_b,
    bottom_middle_r, bottom_middle_g, bottom_middle_b,
    bottom_left_r, bottom_left_g, bottom_left_b,
    left_r, left_g, left_b;

wire [7:0] red_a, red_b, red_c, red_d, red_e, red_f, red_g, red_h,
    green_a, green_b, green_c, green_d, green_e, green_f, green_g, green_h,
    blue_a, blue_b, blue_c, blue_d, blue_e, blue_f, blue_g, blue_h;
    
localparam HALF = 3'd2;
localparam QUARTER = 3'd4;

// original pixel
display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) original_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(x),
    .y(y),
    .r(original_r),
    .g(original_g),
    .b(original_b)
);

// top-left pixel
wire [10:0] top_left_x = x - 1'b1;
wire [9:0] top_left_y = y - 1'b1;
assign top_left_x = x - 1'b1;
assign top_left_y = y - 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) top_left_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(top_left_x),
    .y(top_left_y),
    .r(top_left_r),
    .g(top_left_g),
    .b(top_left_b)
);

scale #(QUARTER) top_left_scale (
    .r_in(top_left_r),
    .g_in(top_left_g),
    .b_in(top_left_b),
    .r_out(red_a),
    .g_out(green_a),
    .b_out(blue_a)
);

// top-middle pixel
wire [9:0] top_middle_y;
assign top_middle_y = y - 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) top_middle_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(x),
    .y(top_middle_y),
    .r(top_middle_r),
    .g(top_middle_g),
    .b(top_middle_b)
);

scale #(HALF) top_middle_scale (
    .r_in(top_middle_r),
    .g_in(top_middle_g),
    .b_in(top_middle_b),
    .r_out(red_b),
    .g_out(green_b),
    .b_out(blue_b)
);

// top-right pixel
wire [10:0] top_right_x;
wire [9:0] top_right_y;
assign top_right_x = x + 1'b1;
assign top_right_y = y - 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) top_right_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(top_right_x),
    .y(top_right_y),
    .r(top_right_r),
    .g(top_right_g),
    .b(top_right_b)
);

scale #(QUARTER) top_right_scale (
    .r_in(top_right_r),
    .g_in(top_right_g),
    .b_in(top_right_b),
    .r_out(red_c),
    .g_out(green_c),
    .b_out(blue_c)
);

// right pixel
wire [10:0] right_x;
assign right_x = x + 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) right_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(right_x),
    .y(y),
    .r(right_r),
    .g(right_g),
    .b(right_b)
);

scale #(HALF) right_scale (
    .r_in(right_r),
    .g_in(right_g),
    .b_in(right_b),
    .r_out(red_d),
    .g_out(green_d),
    .b_out(blue_d)
);

// bottom-right pixel
wire [10:0] bottom_right_x;
wire [9:0] bottom_right_y;
assign bottom_right_x = x + 1'b1;
assign bottom_right_y = y + 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) bottom_right_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(bottom_right_x),
    .y(bottom_right_y),
    .r(bottom_right_r),
    .g(bottom_right_g),
    .b(bottom_right_b)
);

scale #(QUARTER) bottom_right_scale (
    .r_in(bottom_right_r),
    .g_in(bottom_right_g),
    .b_in(bottom_right_b),
    .r_out(red_e),
    .g_out(green_e),
    .b_out(blue_e)
);

// bottom-middle pixel
wire [9:0] bottom_middle_y;
assign bottom_middle_y = y + 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) bottom_middle_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(x),
    .y(bottom_middle_y),
    .r(bottom_middle_r),
    .g(bottom_middle_g),
    .b(bottom_middle_b)
);

scale #(HALF) bottom_middle_scale (
    .r_in(bottom_middle_r),
    .g_in(bottom_middle_g),
    .b_in(bottom_middle_b),
    .r_out(red_f),
    .g_out(green_f),
    .b_out(blue_f)
);

// bottom-left pixel
wire [10:0] bottom_left_x;
wire [9:0] bottom_left_y;
assign bottom_left_x = x - 1'b1;
assign bottom_left_y = y + 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) bottom_left_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(bottom_left_x),
    .y(bottom_left_y),
    .r(bottom_left_r),
    .g(bottom_left_g),
    .b(bottom_left_b)
);

scale #(QUARTER) bottom_left_scale (
    .r_in(bottom_left_r),
    .g_in(bottom_left_g),
    .b_in(bottom_left_b),
    .r_out(red_g),
    .g_out(green_g),
    .b_out(blue_g)
);

// left pixel
wire [10:0] left_x;
assign left_x = x - 1'b1;

display_pixel #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .SCREEN_HEIGHT(SCREEN_HEIGHT),
    .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
    .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
    .DISPLAYED_BEATS(DISPLAYED_BEATS),
    .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
    .BEAT_DURATION(BEAT_DURATION),
    .BEAT_BITS(BEAT_BITS),
    .NOTE_BITS(NOTE_BITS) 
    ) left_pixel (
    .reset_player(reset_player),
    .song_done(song_done),
    .play(play),
    .clk(clk),
    .rst(rst),
    .song_index(song_index),
    .instrument_type(instrument_type),
    .notes(notes),
    .x(left_x),
    .y(y),
    .r(left_r),
    .g(left_g),
    .b(left_b)
);

scale #(HALF) left_scale (
    .r_in(left_r),
    .g_in(left_g),
    .b_in(left_b),
    .r_out(red_h),
    .g_out(green_h),
    .b_out(blue_h)
);

// red weighted average
avg_pix red_weighted_average (
    .orig(original_r),
    .a(red_a),
    .b(red_b),
    .c(red_c),
    .d(red_d),
    .e(red_e),
    .f(red_f),
    .g(red_g),
    .h(red_h),
    .new_color(r_new)
);

// green weighted average
avg_pix green_weighted_average (
    .orig(original_g),
    .a(green_a),
    .b(green_b),
    .c(green_c),
    .d(green_d),
    .e(green_e),
    .f(green_f),
    .g(green_g),
    .h(green_h),
    .new_color(g_new)
);

// blue weighted average
avg_pix blue_weighted_average (
    .orig(original_b),
    .a(blue_a),
    .b(blue_b),
    .c(blue_c),
    .d(blue_d),
    .e(blue_e),
    .f(blue_f),
    .g(blue_g),
    .h(blue_h),
    .new_color(b_new)
);

endmodule