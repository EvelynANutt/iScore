module playing_notes_manager #(parameter
    DISPLAYED_BEATS = 9, // Number of beats displayed on the screen
    SIMULTANEOUS_NOTES = 4, // Number of notes displayable at once
    BEAT_BITS = 7, // Number of bits for the current beat in a song
    NOTE_BITS = 6, // Number of bits for a note
    NOTES_POS_BITS = 7, // Number of bits to store position in notes state
    PLAYING_NOTES_POS_BITS = 2, // Number of bits to store position in playing notes state
    PLAY_OFFSET = 0
) (
    input wire clk,
    input wire rst,
    input wire new_beat,
    input wire play,
    input wire [NOTE_STATE_BITS-1:0] notes [NOTES_STATE_SIZE-1:0],
    output wire [NOTE_BITS-1:0] playing_notes [SIMULTANEOUS_NOTES-1:0]
);
    localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
    localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;
    
    wire delayed_beat;
    dff delayed_new_beat (
        .clk(clk),
        .d(new_beat),
        .q(delayed_beat)
    );

    wire [NOTES_POS_BITS-1:0] notes_position;
    position_counter #(
        .POS_BITS(NOTES_POS_BITS),
        .ARRAY_SIZE(NOTES_STATE_SIZE + 1'b1)
    ) notes_position_counter (
        .clk(clk),
        .rst(rst || delayed_beat),
        .en(notes_position < NOTES_STATE_SIZE),
        .pos(notes_position)
    );

    wire [NOTE_BITS-1:0] note;
    wire [BEAT_BITS-1:0] ran_for;
    wire [BEAT_BITS-1:0] duration;
    assign {note, ran_for, duration} = notes[notes_position];
    wire is_playing = note && ran_for >= PLAY_OFFSET && ran_for < duration + PLAY_OFFSET;

    wire [PLAYING_NOTES_POS_BITS-1:0] playing_notes_position;
    position_counter #(
        .POS_BITS(PLAYING_NOTES_POS_BITS),
        .ARRAY_SIZE(SIMULTANEOUS_NOTES)
    ) playing_notes_position_counter (
        .clk(clk),
        .rst(rst || delayed_beat),
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
                .d(play ? note : {NOTE_BITS{1'b0}}),
                .q(playing_notes[i])
            );
        end
    endgenerate

endmodule