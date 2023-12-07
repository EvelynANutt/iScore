`define BLACK 24'h000000
`define WHITE 24'hFFFFFF
`define BLUE 24'h0000FF

module display_pixel #(parameter
    SCREEN_WIDTH = 0, // Width of screen in pixels
    SCREEN_HEIGHT = 0, // Height of screen in pixels
    SCREEN_WIDTH_BITS = 0, // Number of bits for width of the screen
    SCREEN_HEIGHT_BITS = 0, // Number of bits for height of the screen
    DISPLAYED_BEATS = 0, // Number of beats displayed on the screen
    SIMULTANEOUS_NOTES = 0, // Number of notes displayable at once
    BEAT_DURATION = 0, // Duration of a beat in beat48
    BEAT_BITS = 0, // Number of bits for the current beat in a song
    NOTE_BITS = 0 // Number of bits for a note
) (
    input wire [SCREEN_WIDTH_BITS-1:0] x, // Requested x coordinate
    input wire [SCREEN_HEIGHT_BITS-1:0] y, // Requested y coordinate
    // Array of all possibly displayable (notes, start beat, duration) triples
    input wire [NOTE_STATE_BITS-1:0] notes [NOTES_STATE_SIZE-1:0],
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);
    localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
    localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;
    
    wire on_notes;
    display_notes #(
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
        .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS), // TODO: Maybe? Needs to be high enough to hold shiftedX
        .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
        .DISPLAYED_BEATS(DISPLAYED_BEATS),
        .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
        .BEAT_DURATION(BEAT_DURATION),
        .BEAT_BITS(BEAT_BITS),
        .NOTE_BITS(NOTE_BITS)
    ) display_notes (.x(x), .y(y), .notes(notes), .on(on_notes));

    wire on_staff_lines;
    display_staff_lines #(
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
        .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
        .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
        .DISPLAYED_BEATS(DISPLAYED_BEATS)
    ) display_staff_lines (
        .x(x),
        .y(y),
        .on(on_staff_lines)
    );

    assign {r, g, b} = on_notes ? `BLUE : on_staff_lines ? `BLACK : `WHITE;
    
endmodule