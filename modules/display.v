`define WHITE 24'hFFFFFF

module display #(parameter
    DISPLAYED_BEATS = 0, // Number of beats displayed on the screen
    SIMULTANEOUS_NOTES = 0, // Number of notes displayable at once
    BEAT_DURATION = 0, // Duration of a beat in beat48
    BEAT_BITS = 0, // Number of bits for the current beat in a song
    NOTE_BITS = 0 // Number of bits for a note
) (
    input wire [10:0] x, // Requested x coordinate
    input wire [9:0] y, // Requested y coordinate
    // Array of all possibly displayable (notes, start beat, duration) triples
    input wire [NOTE_STATE_BITS-1:0] notes [NOTES_STATE_SIZE-1:0],
    input wire valid,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);
    localparam SCREEN_WIDTH = 800;
    localparam SCREEN_HEIGHT = 480;
    localparam SCREEN_WIDTH_BITS = 11;
    localparam SCREEN_HEIGHT_BITS = 10;
    localparam SCREEN_START_X = 88;
    localparam SCREEN_START_Y = 32;
    localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
    localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;

    wire [7:0] r_tmp, g_tmp, b_tmp;

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
    ) display_pixel (.x(x - SCREEN_START_X), .y(y - SCREEN_START_Y), .notes(notes), .r(r_tmp), .g(g_tmp), .b(b_tmp));

    wire valid_pixel = x >= SCREEN_START_X && x < SCREEN_START_X + SCREEN_WIDTH
                      && y >= SCREEN_START_Y && y < SCREEN_START_Y + SCREEN_HEIGHT;
    assign {r, g, b} = valid && valid_pixel ? {r_tmp, g_tmp, b_tmp} : `WHITE;
    
endmodule