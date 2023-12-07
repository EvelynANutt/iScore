// When instantiating, use Y_COORD = 10'd32 for song title 
// and Y_COORD = 10'd112 for instrument title.
// Default set to song title Y_COORD.

module title_display #(parameter X_COORD = 11'd88, Y_COORD = 10'd32, BOX_WIDTH = 8'd40) (
    input wire [10:0] x,
    input wire [9:0] y,
    input wire [8:0] char1, char2, char3, char4, char5,
        char6, char7, char8, char9, char10, char11, char12,
    output wire pixel_on
)

wire char1_on, char2_on, char3_on, char4_on, char5_on, char6_on, char7_on,
    char8_on, char9_on, char10_on, char11_on, char12_on;

char_display #(.X_BOX(X_COORD), .Y_BOX(Y_COORD)) char1_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char1),
    .pixel_on(char1_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd1)), .Y_BOX(Y_COORD)) char2_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char2),
    .pixel_on(char2_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd2)), .Y_BOX(Y_COORD)) char3_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char3),
    .pixel_on(char3_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd3)), .Y_BOX(Y_COORD)) char4_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char4),
    .pixel_on(char4_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd4)), .Y_BOX(Y_COORD)) char5_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char5),
    .pixel_on(char5_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd5)), .Y_BOX(Y_COORD)) char6_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char6),
    .pixel_on(char6_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd6)), .Y_BOX(Y_COORD)) char7_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char7),
    .pixel_on(char7_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd7)), .Y_BOX(Y_COORD)) char8_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char8),
    .pixel_on(char8_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd8)), .Y_BOX(Y_COORD)) char9_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char9),
    .pixel_on(char9_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd9)), .Y_BOX(Y_COORD)) char10_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char10),
    .pixel_on(char10_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd10)), .Y_BOX(Y_COORD)) char11_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char11),
    .pixel_on(char11_on)
);

char_display #(.X_BOX(X_COORD + (BOX_WIDTH * 4'd11)), .Y_BOX(Y_COORD)) char12_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr(char12),
    .pixel_on(char12_on)
);

assign pixel_on = char1_on || char2_on || char3_on || char4_on || char5_on ||
    char6_on || char7_on || char8_on || char9_on || char10_on || char11_on ||
    char12_on;

endmodule