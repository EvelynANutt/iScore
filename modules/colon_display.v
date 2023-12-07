module colon_display #(parameter X_BOX = 11'd0, Y_BOX = 10'd0) (
    input wire [10:0] pixel_x,
    input wire [9:0] pixel_y,
    output wire pixel_on
)

wire [10:0] relative_x, flip_relative_x;
assign relative_x = (pixel_x - X_BOX) / 11'd2;

always @(*) begin
    if (relative_x > 11'd7) begin
        assign flip_relative_x = 11'd0;
    end
    else if (relative_x <= 11'd7 && relative_x >= 11'd0) begin
        assign flip_relative_x = 11'd7 - relative_x;
    end
    else if (relative_x < 0) begin
        assign flip_relative_x = 11'd0;
    end
    else begin
        assign flip_relative_x = 0;
    end
end

wire [9:0] relative_y;
assign relative_y = (pixel_y - Y_BOX) / 10'd5;

wire [8:0] colon_row_addr, row_data;
assign colon_row_addr = relative_y + 9'h138;

tcgrom get_digit(
    .addr(colon_row_addr),
    .data(row_data)
);

assign pixel_on = (row_data[flip_relative_x]) && (pixel_x >= X_BOX) && (pixel_x <= 11'd720) && (pixel_y >= Y_BOX) && (pixel_y <= 10'd112);

endmodule