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
    input wire reset_player, song_done, play, clk, rst,
    input [1:0] song_index, instrument_type,
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
    
    wire on_clock, on_song, on_instrument, on_interface;
    wire [5:0] pixel_type;
    assign pixel_type = {on_interface, on_instrument, on_song, on_clock, on_staff_lines, on_notes};
    
    reg [8:0] song_char1, song_char2, song_char3, song_char4, song_char5, song_char6, song_char7, song_char8, song_char9, song_char10, song_char11, song_char12;
    reg [8:0] instrument_char1, instrument_char2, instrument_char3, instrument_char4, instrument_char5, instrument_char6, instrument_char7, instrument_char8, instrument_char9, instrument_char10, instrument_char11, instrument_char12;
    reg [8:0] ui_char1, ui_char2, ui_char3, ui_char4, ui_char5, ui_char6, ui_char7, ui_char8, ui_char9, ui_char10, ui_char11, ui_char12;

    song_progression #(11'd820, 10'd72, 8'd50) clock(
        .reset_player(reset_player),
        .song_done(song_done),
        .play(play),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .pixel_on(on_clock)
    );
    
    always @(*) begin
        case (song_index) // fill in once we know the song title
            2'b00: begin
                song_char1 = 9'h000;
                song_char2 = 9'h000;
                song_char3 = 9'h000;
                song_char4 = 9'h000;
                song_char5 = 9'h000;
                song_char6 = 9'h000;
                song_char7 = 9'h000;
                song_char8 = 9'h000;
                song_char9 = 9'h000;
                song_char10 = 9'h000;
                song_char11 = 9'h000;
                song_char12 = 9'h000;
            end
            2'b01: begin
                song_char1 = 9'h000;
                song_char2 = 9'h000;
                song_char3 = 9'h000;
                song_char4 = 9'h000;
                song_char5 = 9'h000;
                song_char6 = 9'h000;
                song_char7 = 9'h000;
                song_char8 = 9'h000;
                song_char9 = 9'h000;
                song_char10 = 9'h000;
                song_char11 = 9'h000;
                song_char12 = 9'h000;
            end
            2'b10: begin
                song_char1 = 9'h000;
                song_char2 = 9'h000;
                song_char3 = 9'h000;
                song_char4 = 9'h000;
                song_char5 = 9'h000;
                song_char6 = 9'h000;
                song_char7 = 9'h000;
                song_char8 = 9'h000;
                song_char9 = 9'h000;
                song_char10 = 9'h000;
                song_char11 = 9'h000;
                song_char12 = 9'h000;
            end
            2'b11: begin
                song_char1 = 9'h000;
                song_char2 = 9'h000;
                song_char3 = 9'h000;
                song_char4 = 9'h000;
                song_char5 = 9'h000;
                song_char6 = 9'h000;
                song_char7 = 9'h000;
                song_char8 = 9'h000;
                song_char9 = 9'h000;
                song_char10 = 9'h000;
                song_char11 = 9'h000;
                song_char12 = 9'h000;
            end
            default: begin
                song_char1 = 9'h100;
                song_char2 = 9'h100;
                song_char3 = 9'h100;
                song_char4 = 9'h100;
                song_char5 = 9'h100;
                song_char6 = 9'h100;
                song_char7 = 9'h100;
                song_char8 = 9'h100;
                song_char9 = 9'h100;
                song_char10 = 9'h100;
                song_char11 = 9'h100;
                song_char12 = 9'h100;
            end
        endcase
    end
    
    title_display #(11'd88, 10'd32, 8'd40) song(
        .x(x),
        .y(y),
        .char1(song_char1),
        .char2(song_char2),
        .char3(song_char3),
        .char4(song_char4),
        .char5(song_char5),
        .char6(song_char6),
        .char7(song_char7),
        .char8(song_char8),
        .char9(song_char9),
        .char10(song_char10),
        .char11(song_char11),
        .char12(song_char12),
        .pixel_on(on_song)
    );
    
    always @(*) begin
        case (instrument_type) // fill in once we know the song title
            2'b00: begin
                instrument_char1 = 9'h0b0; // V
                instrument_char2 = 9'h048; // I
                instrument_char3 = 9'h078; // O
                instrument_char4 = 9'h060; // L
                instrument_char5 = 9'h048; // I
                instrument_char6 = 9'h070; // N
                instrument_char7 = 9'h100;
                instrument_char8 = 9'h100;
                instrument_char9 = 9'h100;
                instrument_char10 = 9'h100;
                instrument_char11 = 9'h100;
                instrument_char12 = 9'h100;
            end
            2'b01: begin
                instrument_char1 = 9'h080; // P
                instrument_char2 = 9'h048; // I
                instrument_char3 = 9'h008; // A
                instrument_char4 = 9'h070; // N
                instrument_char5 = 9'h078; // O
                instrument_char6 = 9'h100;
                instrument_char7 = 9'h100;
                instrument_char8 = 9'h100;
                instrument_char9 = 9'h100;
                instrument_char10 = 9'h100;
                instrument_char11 = 9'h100;
                instrument_char12 = 9'h100;
            end
            2'b10: begin
                instrument_char1 = 9'h028; // E
                instrument_char2 = 9'h060; // L
                instrument_char3 = 9'h028; // E
                instrument_char4 = 9'h018; // C
                instrument_char5 = 9'h0a0; // T
                instrument_char6 = 9'h090; // R
                instrument_char7 = 9'h048; // I
                instrument_char8 = 9'h018; // C
                instrument_char9 = 9'h100;
                instrument_char10 = 9'h100;
                instrument_char11 = 9'h100;
                instrument_char12 = 9'h100;
            end
            2'b11: begin
                instrument_char1 = 9'h100;
                instrument_char2 = 9'h100;
                instrument_char3 = 9'h100;
                instrument_char4 = 9'h100;
                instrument_char5 = 9'h100;
                instrument_char6 = 9'h100;
                instrument_char7 = 9'h100;
                instrument_char8 = 9'h100;
                instrument_char9 = 9'h100;
                instrument_char10 = 9'h100;
                instrument_char11 = 9'h100;
                instrument_char12 = 9'h100;
            end
            default: begin
                instrument_char1 = 9'h100;
                instrument_char2 = 9'h100;
                instrument_char3 = 9'h100;
                instrument_char4 = 9'h100;
                instrument_char5 = 9'h100;
                instrument_char6 = 9'h100;
                instrument_char7 = 9'h100;
                instrument_char8 = 9'h100;
                instrument_char9 = 9'h100;
                instrument_char10 = 9'h100;
                instrument_char11 = 9'h100;
                instrument_char12 = 9'h100;
            end
        endcase
    end
    
    title_display #(11'd88, 10'd112, 8'd40) instrument(
        .x(x),
        .y(y),
        .char1(instrument_char1),
        .char2(instrument_char2),
        .char3(instrument_char3),
        .char4(instrument_char4),
        .char5(instrument_char5),
        .char6(instrument_char6),
        .char7(instrument_char7),
        .char8(instrument_char8),
        .char9(instrument_char9),
        .char10(instrument_char10),
        .char11(instrument_char11),
        .char12(instrument_char12),
        .pixel_on(on_instrument)
    );
    
    always @(*) begin
        case (play)
            1'b0: begin
                ui_char1 = 9'h100;
                ui_char2 = 9'h0f8;
                ui_char3 = 9'h100;
                ui_char4 = 9'h048;
                ui_char5 = 9'h100;
                ui_char6 = 9'h108;
                ui_char7 = 9'h100;
                ui_char8 = 9'h100;
                ui_char9 = 9'h0f0;
                ui_char10 = 9'h100;
                ui_char11 = 9'h100;
                ui_char12 = 9'h100;
            end
            1'b1: begin
                ui_char1 = 9'h100;
                ui_char2 = 9'h0f8;
                ui_char3 = 9'h100;
                ui_char4 = 9'h048;
                ui_char5 = 9'h100;
                ui_char6 = 9'h100;
                ui_char7 = 9'h110;
                ui_char8 = 9'h100;
                ui_char9 = 9'h0f0;
                ui_char10 = 9'h100;
                ui_char11 = 9'h100;
                ui_char12 = 9'h100;
            end
        endcase
    end
    
    title_display #(11'd300, 10'd472, 8'd40) user_interface(
        .x(x),
        .y(y),
        .char1(ui_char1),
        .char2(ui_char2),
        .char3(ui_char3),
        .char4(ui_char4),
        .char5(ui_char5),
        .char6(ui_char6),
        .char7(ui_char7),
        .char8(ui_char8),
        .char9(ui_char9),
        .char10(ui_char10),
        .char11(ui_char11),
        .char12(ui_char12),
        .pixel_on(on_interface)
    );
    
    color color(
        .pixel_type(pixel_type),
        .instrument_type(),
        .r(r),
        .g(g),
        .b(b)
    );

    // assign {r, g, b} = on_notes ? `BLUE : on_staff_lines ? `BLACK : `WHITE;
    
endmodule