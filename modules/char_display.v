module char_display #(parameter X_BOX = 11'd0, Y_BOX = 10'd0) (
    input wire [10:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [8:0] rom_base_addr,
    output wire pixel_on
)

wire [10:0] relative_x, flip_relative_x;
assign relative_x = (pixel_x - X_BOX) / 11'd5;

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
        assign flip_relative_x = 11'd0;
    end
end

wire [9:0] relative_y;
assign relative_y = (pixel_y - Y_BOX) / 10'd5;

wire [8:0] char_row_addr;
assign char_row_addr = relative_y + rom_base_addr;

tcgrom get_char(
    .addr(char_row_addr),
    .data(row_data)
);

assign pixel_on = (row_data[flip_relative_x]) && (pixel_x >= X_BOX) && (pixel_x < X_BOX + 11'd40) && (pixel_y >= Y_BOX) && (pixel_y < Y_BOX + 10'd40);

endmodule