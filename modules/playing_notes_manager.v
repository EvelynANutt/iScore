module playing_notes_manager #(parameter
    DISPLAYED_BEATS = 9, // Number of beats displayed on the screen
    SIMULTANEOUS_NOTES = 4, // Number of notes displayable at once
    BEAT_BITS = 7, // Number of bits for the current beat in a song
    NOTE_BITS = 6, // Number of bits for a note
    NOTES_POS_BITS = 7, // Number of bits to store position in notes state
    PLAYING_NOTES_POS_BITS = 2 // Number of bits to store position in playing notes state
) (
    input wire clk, // Clock
    input wire rst, // Reset
    input wire [BEAT_BITS-1:0] cur_beat, // Current beat in the song
    input wire new_beat, // One-clock-long signal when entering a new beat
    // Array of all possibly displayable (notes, start beat, duration) triples
    input wire [NOTE_STATE_BITS-1:0] notes [NOTES_STATE_SIZE-1:0],
    // Array of all currently playing notes
    output wire [NOTE_BITS-1:0] playing_notes [SIMULTANEOUS_NOTES-1:0]
);
    localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
    localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;

    wire [NOTES_POS_BITS-1:0] notes_position;
    position_counter #(
        .POS_BITS(NOTES_POS_BITS),
        .ARRAY_SIZE(NOTES_STATE_SIZE + 1)
    ) notes_position_counter (
        .clk(clk),
        .rst(rst || new_beat),
        .en(notes_position < NOTES_STATE_SIZE),
        .pos(notes_position)
    );

    wire [NOTE_BITS-1:0] note;
    wire [BEAT_BITS-1:0] start_beat;
    wire [BEAT_BITS-1:0] duration;
    assign {note, start_beat, duration} = notes[notes_position];
    wire is_playing = cur_beat >= start_beat && cur_beat < start_beat + duration;

    wire [PLAYING_NOTES_POS_BITS-1:0] playing_notes_position;
    position_counter #(
        .POS_BITS(PLAYING_NOTES_POS_BITS),
        .ARRAY_SIZE(SIMULTANEOUS_NOTES)
    ) playing_notes_position_counter (
        .clk(clk),
        .rst(rst || new_beat),
        .en(is_playing),
        .pos(playing_notes_position)
    );

    genvar i;
    generate
        for (i = 0; i < SIMULTANEOUS_NOTES; i = i + 1) begin : playing_notes_state_storage
            dffre #(NOTE_BITS) playing_note_state_dffre (
                .clk(clk),
                .r(rst || new_beat),
                .en(playing_notes_position == i && is_playing),
                .d(note),
                .q(playing_notes[i])
            );
        end
    endgenerate

endmodule