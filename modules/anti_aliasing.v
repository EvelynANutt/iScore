module anti_aliasing (
    input wire [10:0] x,
    input wire [9:0] y,
    output reg [7:0] r_new, g_new, b_new
);

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
    
parameter HALF = 3'd2;
parameter QUARTER = 3'd4;

// original pixel
display_pixel original_pixel (
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

display_pixel top_left_pixel (
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
assign wire [9:0] top_middle_y = y - 1'b1;

display_pixel top_middle_pixel (
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
assign wire [10:0] top_right_x = x + 1'b1;
assign wire [9:0] top_right_y = y - 1'b1;

display_pixel top_right_pixel (
    .x(top_right_x),
    .y(top_right_y),
    .r(top_right_r),
    .g(top_right_g),
    .b(top_right_b)
);

scale #(.DENOM(`QUARTER)) top_right_scale (
    .r_in(top_right_r),
    .g_in(top_right_g),
    .b_in(top_right_b),
    .r_out(red_c),
    .g_out(green_c),
    .b_out(blue_c)
);

// right pixel
assign wire [10:0] right_x = x + 1'b1;

display_pixel right_pixel (
    .x(right_x),
    .y(y),
    .r(right_r),
    .g(right_g),
    .b(right_b)
);

scale #(.DENOM(`HALF)) right_scale (
    .r_in(right_r),
    .g_in(right_g),
    .b_in(right_b),
    .r_out(red_d),
    .g_out(green_d),
    .b_out(blue_d)
);

// bottom-right pixel
assign wire [10:0] bottom_right_x = x + 1'b1;
assign wire [9:0] bottom_right_y = y + 1'b1;

display_pixel bottom_right_pixel (
    .x(bottom_right_x),
    .y(bottom_right_y),
    .r(bottom_right_r),
    .g(bottom_right_g),
    .b(bottom_right_b)
);

scale #(.DENOM(`QUARTER)) bottom_right_scale (
    .r_in(bottom_right_r),
    .g_in(bottom_right_g),
    .b_in(bottom_right_b),
    .r_out(red_e),
    .g_out(green_e),
    .b_out(blue_e)
);

// bottom-middle pixel
assign wire [9:0] bottom_middle_y = y + 1'b1;

display_pixel bottom_middle_pixel (
    .x(x),
    .y(bottom_middle_y),
    .r(bottom_middle_r),
    .g(bottom_middle_g),
    .b(bottom_middle_b)
);

scale #(.DENOM(`HALF)) bottom_middle_scale (
    .r_in(bottom_middle_r),
    .g_in(bottom_middle_g),
    .b_in(bottom_middle_b),
    .r_out(red_f),
    .g_out(green_f),
    .b_out(blue_f)
);

// bottom-left pixel
assign wire [10:0] bottom_left_x = x - 1'b1;
assign wire [9:0] bottom_left_y = y + 1'b1;

display_pixel bottom_left_pixel (
    .x(bottom_left_x),
    .y(bottom_left_y),
    .r(bottom_left_r),
    .g(bottom_left_g),
    .b(bottom_left_b)
);

scale #(.DENOM(`QUARTER)) bottom_left_scale (
    .r_in(bottom_left_r),
    .g_in(bottom_left_g),
    .b_in(bottom_left_b),
    .r_out(red_g),
    .g_out(green_g),
    .b_out(blue_g)
);

// left pixel
assign wire [10:0] left_x = x - 1'b1;

display_pixel left_pixel (
    .x(left_x),
    .y(y),
    .r(left_r),
    .g(left_g),
    .b(left_b)
);

scale #(.DENOM(`HALF)) left_scale (
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