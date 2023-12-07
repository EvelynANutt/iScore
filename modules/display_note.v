`include "constants.v"

module display_note #(parameter
    SCREEN_WIDTH = 0, // Width of screen in pixels
    SCREEN_HEIGHT = 0, // Height of screen in pixels
    SCREEN_WIDTH_BITS = 0, // Number of bits for width of the screen
    SCREEN_HEIGHT_BITS = 0, // Number of bits for height of the screen
    DISPLAYED_BEATS = 0, // Number of beats displayed on the screen
    BEAT_DURATION = 0, // Duration of a beat in beat48
    BEAT_BITS = 0, // Number of bits for the current beat in a song
    NOTE_BITS = 0, // Number of bits for a note
    BEAT_WIDTH = 0 // Width of a beat in pixels
) (
    input wire [SCREEN_WIDTH_BITS-1:0] x, // Requested x coordinate
    input wire [SCREEN_HEIGHT_BITS-1:0] y, // Requested y coordinate
    input wire [NOTE_BITS-1:0] note, // Note number
    input wire [BEAT_BITS-1:0] ran_for, // Beat number of start of note
    input wire [BEAT_BITS-1:0] duration, // Duration of the note in beats
    output wire on // Whether the note is on the requested pixel
);
    localparam LINE_DIFF = SCREEN_HEIGHT / 20;
    localparam HALF_LINE_DIFF = LINE_DIFF >> 1;
    localparam LINE_3_Y = SCREEN_HEIGHT >> 1;
    localparam LINE_4_Y = LINE_3_Y - LINE_DIFF;
    localparam LINE_5_Y = LINE_4_Y - LINE_DIFF;
    localparam LINE_2_Y = LINE_3_Y + LINE_DIFF;
    localparam LINE_1_Y = LINE_2_Y + LINE_DIFF;
    localparam DOT_SPACING = LINE_DIFF / 3;
    localparam HALF_NOTE_WIDTH = `NOTE_WIDTH >> 1;
    localparam RAN_FOR_TO_WIDTH = BEAT_WIDTH / BEAT_DURATION;

    // Divide by BEAT_DURATION (16) and round up (3 beats per second)
    wire [BEAT_BITS-1:0] beat_duration = (duration + 4'd15) >> 4;
    wire [SCREEN_WIDTH_BITS-1:0] noteX = SCREEN_WIDTH - (ran_for * RAN_FOR_TO_WIDTH) + (BEAT_WIDTH >> 1) - HALF_NOTE_WIDTH;
    wire onDisplay = ran_for > 1'b0 && ran_for < DISPLAYED_BEATS * BEAT_DURATION;
    
    reg [SCREEN_HEIGHT_BITS-1:0] noteY;
    always @(*) begin
        case (note)
            1: noteY = LINE_1_Y + 17 * HALF_LINE_DIFF;
            2: noteY = LINE_1_Y + 17 * HALF_LINE_DIFF;
            3: noteY = LINE_1_Y + 16 * HALF_LINE_DIFF;
            4: noteY = LINE_1_Y + 15 * HALF_LINE_DIFF;
            5: noteY = LINE_1_Y + 15 * HALF_LINE_DIFF;
            6: noteY = LINE_1_Y + 14 * HALF_LINE_DIFF;
            7: noteY = LINE_1_Y + 14 * HALF_LINE_DIFF;
            8: noteY = LINE_1_Y + 13 * HALF_LINE_DIFF;
            9: noteY = LINE_1_Y + 12 * HALF_LINE_DIFF;
            10: noteY = LINE_1_Y + 12 * HALF_LINE_DIFF;
            11: noteY = LINE_1_Y + 11 * HALF_LINE_DIFF;
            12: noteY = LINE_1_Y + 11 * HALF_LINE_DIFF;
            13: noteY = LINE_1_Y + 10 * HALF_LINE_DIFF;
            14: noteY = LINE_1_Y + 10 * HALF_LINE_DIFF;
            15: noteY = LINE_1_Y + 9 * HALF_LINE_DIFF;
            16: noteY = LINE_1_Y + 8 * HALF_LINE_DIFF;
            17: noteY = LINE_1_Y + 8 * HALF_LINE_DIFF;
            18: noteY = LINE_1_Y + 7 * HALF_LINE_DIFF;
            19: noteY = LINE_1_Y + 7 * HALF_LINE_DIFF;
            20: noteY = LINE_1_Y + 6 * HALF_LINE_DIFF;
            21: noteY = LINE_1_Y + 5 * HALF_LINE_DIFF;
            22: noteY = LINE_1_Y + 5 * HALF_LINE_DIFF;
            23: noteY = LINE_1_Y + 4 * HALF_LINE_DIFF;
            24: noteY = LINE_1_Y + 4 * HALF_LINE_DIFF;
            25: noteY = LINE_1_Y + 3 * HALF_LINE_DIFF;
            26: noteY = LINE_1_Y + 3 * HALF_LINE_DIFF;
            27: noteY = LINE_1_Y + 2 * HALF_LINE_DIFF;
            28: noteY = LINE_1_Y + HALF_LINE_DIFF;
            29: noteY = LINE_1_Y + HALF_LINE_DIFF;
            30: noteY = LINE_1_Y;
            31: noteY = LINE_1_Y;
            32: noteY = LINE_1_Y - HALF_LINE_DIFF;
            33: noteY = LINE_2_Y;
            34: noteY = LINE_2_Y;
            35: noteY = LINE_2_Y - HALF_LINE_DIFF;
            36: noteY = LINE_2_Y - HALF_LINE_DIFF;
            37: noteY = LINE_3_Y;
            38: noteY = LINE_3_Y;
            39: noteY = LINE_3_Y - HALF_LINE_DIFF;
            40: noteY = LINE_4_Y;
            41: noteY = LINE_4_Y;
            42: noteY = LINE_4_Y - HALF_LINE_DIFF;
            43: noteY = LINE_4_Y - HALF_LINE_DIFF;
            44: noteY = LINE_5_Y;
            45: noteY = LINE_5_Y - HALF_LINE_DIFF;
            46: noteY = LINE_5_Y - HALF_LINE_DIFF;
            47: noteY = LINE_5_Y - 2 * HALF_LINE_DIFF;
            48: noteY = LINE_5_Y - 2 * HALF_LINE_DIFF;
            49: noteY = LINE_5_Y - 3 * HALF_LINE_DIFF;
            50: noteY = LINE_5_Y - 3 * HALF_LINE_DIFF;
            51: noteY = LINE_5_Y - 4 * HALF_LINE_DIFF;
            52: noteY = LINE_5_Y - 5 * HALF_LINE_DIFF;
            53: noteY = LINE_5_Y - 5 * HALF_LINE_DIFF;
            54: noteY = LINE_5_Y - 6 * HALF_LINE_DIFF;
            55: noteY = LINE_5_Y - 6 * HALF_LINE_DIFF;
            56: noteY = LINE_5_Y - 7 * HALF_LINE_DIFF;
            57: noteY = LINE_5_Y - 8 * HALF_LINE_DIFF;
            58: noteY = LINE_5_Y - 8 * HALF_LINE_DIFF;
            59: noteY = LINE_5_Y - 9 * HALF_LINE_DIFF;
            60: noteY = LINE_5_Y - 9 * HALF_LINE_DIFF;
            61: noteY = LINE_5_Y - 10 * HALF_LINE_DIFF;
            62: noteY = LINE_5_Y - 10 * HALF_LINE_DIFF;
            63: noteY = LINE_5_Y - 11 * HALF_LINE_DIFF;
            default: noteY = 0;
        endcase
    end
    
    wire onNote = x >= noteX && x < noteX + `NOTE_WIDTH
                && y >= noteY && y < noteY + `NOTE_HEIGHT;

    reg [1:0] noteType;
    reg hasStem;
    reg hasDot;
    always @(*) begin
        case (beat_duration)
            1: {noteType, hasStem, hasDot} = {`QUARTER_NOTE, 1'b1, 1'b0};
            2: {noteType, hasStem, hasDot} = {`HALF_NOTE, 1'b1, 1'b0};
            3: {noteType, hasStem, hasDot} = {`HALF_NOTE, 1'b1, 1'b1};
            4: {noteType, hasStem, hasDot} = {`WHOLE_NOTE, 1'b0, 1'b0};
            default: {noteType, hasStem, hasDot} = {2'd0, 1'b1, 1'b0};
        endcase
    end
    
    wire [4:0] notesRomX = x - noteX;
    wire [4:0] notesRomY = y - noteY;

    wire [`NOTE_WIDTH-1:0] noteRomData;
    notes_rom notes_rom(
        .noteType(noteType),
        .addr(notesRomY),
        .data(noteRomData)
    );
    wire onNoteGraphic = noteRomData[`NOTE_WIDTH - notesRomX - 1];


    
    wire bottomStem = noteY <= LINE_3_Y;
    wire onTopStem = x >= noteX + `NOTE_WIDTH - `STEM_WIDTH && x < noteX + `NOTE_WIDTH
                    && y >= noteY - `STEM_LINES * LINE_DIFF && y < noteY + `STEM_ATTACH_HEIGHT;
    wire onBottomStem = x >= noteX && x < noteX + `STEM_WIDTH
                        && y >= noteY + `NOTE_HEIGHT - `STEM_ATTACH_HEIGHT && y < noteY + `NOTE_HEIGHT + `STEM_LINES * LINE_DIFF;
    wire onStem = bottomStem ? onBottomStem : onTopStem;


    wire [SCREEN_WIDTH_BITS-1:0] dotX = noteX + `NOTE_WIDTH + DOT_SPACING + 1;
    wire [SCREEN_HEIGHT_BITS-1:0] dotY = noteY - ((note + 1) % 2 * HALF_LINE_DIFF) + DOT_SPACING + 1;
    wire onDot = x >= dotX && x < dotX + `DOT_WIDTH
                && y >= dotY && y < dotY + `DOT_WIDTH;

    wire [2:0] dotRomX = x - dotX;
    wire [2:0] dotRomY = y - dotY;

    wire [`DOT_WIDTH-1:0] dotRomData;
    dot_rom dot_rom(
        .addr(dotRomY),
        .data(dotRomData)
    );
    wire onDotGraphic = dotRomData[`DOT_WIDTH - dotRomX - 1];

    assign on = note && onDisplay && (
        (onNote && onNoteGraphic)
        || (hasStem && onStem)
        || (hasDot && onDot && onDotGraphic)
    );
endmodule