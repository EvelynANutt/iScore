`include "constants.v"

module display_notes #(parameter
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
    output wire on // Whether a note is on the requested pixel
);
    localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
    localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;
    localparam HALF_DISPLAYED_BEATS = DISPLAYED_BEATS >> 1;
    localparam BEAT_WIDTH = SCREEN_WIDTH / (DISPLAYED_BEATS - 1);

    genvar i;
    wire [NOTES_STATE_SIZE-1:0] onNotes;
    generate
        for (i = 0; i < NOTES_STATE_SIZE; i = i + 1) begin : gen_block
            wire [NOTE_BITS-1:0] note;
            wire [BEAT_BITS-1:0] ran_for;
            wire [BEAT_BITS-1:0] duration;
            assign {note, ran_for, duration} = notes[i];
            
            wire onNote;
            display_note #(
                .SCREEN_WIDTH(SCREEN_WIDTH),
                .SCREEN_HEIGHT(SCREEN_HEIGHT),
                .SCREEN_WIDTH_BITS(SCREEN_WIDTH_BITS),
                .SCREEN_HEIGHT_BITS(SCREEN_HEIGHT_BITS),
                .DISPLAYED_BEATS(DISPLAYED_BEATS),
                .BEAT_DURATION(BEAT_DURATION),
                .BEAT_BITS(BEAT_BITS),
                .NOTE_BITS(NOTE_BITS),
                .BEAT_WIDTH(BEAT_WIDTH)
            ) display_note(
                .x(x),
                .y(y),
                .note(note),
                .ran_for(ran_for),
                .duration(duration),
                .on(onNote)
            );

            assign onNotes[i] = onNote;
        end
    endgenerate    

    assign on = |onNotes;

endmodule