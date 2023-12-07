module notes_manager #(parameter
    DISPLAYED_BEATS = 0, // Number of beats displayed on the screen
    SIMULTANEOUS_NOTES = 0, // Number of notes displayable at once
    BEAT_BITS = 0, // Number of bits for the current beat in a song
    NOTE_BITS = 0, // Number of bits for a note
    NOTES_POS_BITS = 0 // Number of bits to store position in notes state
) (
    input wire clk, // Clock
    input wire rst, // Reset
    input wire new_note, // One-clock-long signal when a new note is ready to be stored
    input wire new_beat,
    input wire play,
    input wire [NOTE_BITS-1:0] note, // Note to store
    input wire [BEAT_BITS-1:0] duration, // Duration of the note to store
    output wire [NOTE_STATE_BITS-1:0] notes [NOTES_STATE_SIZE-1:0]
);
    localparam NOTE_STATE_BITS = NOTE_BITS+2*BEAT_BITS;
    localparam NOTES_STATE_SIZE = 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES;
    localparam [BEAT_BITS-1:0] HALF_DISPLAYED_BEATS = DISPLAYED_BEATS >> 1;

    wire [NOTES_POS_BITS-1:0] pos;
    position_counter #(
        .POS_BITS(NOTES_POS_BITS),
        .ARRAY_SIZE(NOTES_STATE_SIZE)
    ) notes_position_counter (
        .clk(clk),
        .rst(rst),
        .en(new_note),
        .pos(pos)
    );
    
    // Added to fix timing violations
    wire [NOTES_POS_BITS-1:0] notes_position;
    dffr #(NOTES_POS_BITS) notes_position_delayed (
        .clk(clk),
        .r(rst),
        .d(pos),
        .q(notes_position)
    );

    genvar i;
    generate
        for (i = 0; i < NOTES_STATE_SIZE; i = i + 1) begin : notes_state_storage
            wire [NOTE_BITS-1:0] old_note;
            wire [BEAT_BITS-1:0] old_ran_for;
            wire [BEAT_BITS-1:0] old_duration;
            assign {old_note, old_ran_for, old_duration} = notes[i];

            wire set_note = new_note && notes_position == i;

            wire [NOTE_BITS-1:0] next_note = set_note ? note : old_note;
            wire [BEAT_BITS-1:0] next_ran_for = set_note
                ? {(BEAT_BITS-2){1'b0}}
                : old_ran_for == 7'd127 // Make sure old ran for doesn't ever loop around
                    ? old_ran_for
                    : old_ran_for + 1'b1;
            wire [BEAT_BITS-1:0] next_duration = set_note ? duration : old_duration;
            
            dffre #(NOTE_STATE_BITS) note_state_dffre (
                .clk(clk),
                .r(rst),
                .en(play && (new_beat || set_note)),
                .d({next_note, next_ran_for, next_duration}),
                .q(notes[i])
            );
        end
    endgenerate

endmodule