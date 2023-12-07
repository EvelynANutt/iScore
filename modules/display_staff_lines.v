`include "constants.v"

module display_staff_lines #(parameter
    SCREEN_WIDTH = 0, // Width of screen in pixels
    SCREEN_HEIGHT = 0, // Height of screen in pixels
    SCREEN_WIDTH_BITS = 0, // Number of bits for width of the screen
    SCREEN_HEIGHT_BITS = 0, // Number of bits for height of the screen
    DISPLAYED_BEATS = 0 // Number of beats displayed on the screen
) (
    input wire [SCREEN_WIDTH_BITS-1:0] x, // Requested x coordinate
    input wire [SCREEN_HEIGHT_BITS-1:0] y, // Requested y coordinate
    output wire on // Whether a note is on the requested pixel
);
    localparam LINE_DIFF = SCREEN_HEIGHT / 20;
    localparam LINE_3_Y = SCREEN_HEIGHT >> 1;
    localparam LINE_4_Y = LINE_3_Y - LINE_DIFF;
    localparam LINE_5_Y = LINE_4_Y - LINE_DIFF;
    localparam LINE_2_Y = LINE_3_Y + LINE_DIFF;
    localparam LINE_1_Y = LINE_2_Y + LINE_DIFF;
    localparam HALF_DISPLAYED_BEATS = DISPLAYED_BEATS >> 1;
    localparam DOT_SPACING = LINE_DIFF / 3;
    localparam HALF_NOTE_WIDTH = `NOTE_WIDTH >> 1;

    assign on = (y == LINE_1_Y) || (y == LINE_2_Y) || (y == LINE_3_Y) || (y == LINE_4_Y) || (y == LINE_5_Y)
             || (y == LINE_1_Y + 1) || (y == LINE_2_Y + 1) || (y == LINE_3_Y + 1) || (y == LINE_4_Y + 1) || (y == LINE_5_Y + 1)
             || (x == SCREEN_WIDTH >> 1);

endmodule