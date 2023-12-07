module display_tb;
    localparam SCREEN_WIDTH = 800;
    localparam SCREEN_HEIGHT = 480;
    localparam DISPLAYED_BEATS = 6;
    localparam SIMULTANEOUS_NOTES = 4;
    localparam BEAT_DURATION = 16;
    localparam BEAT_BITS = 7; // 128 beats max in a song
    localparam NOTE_BITS = 6; // 16 notes max in a song
    localparam SCREEN_WIDTH_BITS = 11;
    localparam SCREEN_HEIGHT_BITS = 10;

    reg [SCREEN_WIDTH_BITS-1:0] x;
    reg [SCREEN_HEIGHT_BITS-1:0] y;
    
    wire [NOTE_BITS+2*BEAT_BITS-1:0] notes [2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES-1:0];
    wire on_notes;
    display_notes #(
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
        .SCREEN_WIDTH_BITS(11), // TODO: Maybe? Needs to be high enough to hold shiftedX
        .SCREEN_HEIGHT_BITS(10),
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
    
    wire on = on_notes || on_staff_lines;

    reg clk = 0;
    reg rst;
    reg new_note;
    reg [NOTE_BITS-1:0] note;
    reg [BEAT_BITS-1:0] start_beat;
    reg [BEAT_BITS-1:0] duration;
    reg new_beat;
    notes_manager #(
        .DISPLAYED_BEATS(DISPLAYED_BEATS),
        .SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES),
        .BEAT_BITS(BEAT_BITS),
        .NOTE_BITS(NOTE_BITS),
        .NOTES_POS_BITS(6)
    ) notes_manager (
        .clk(clk),
        .rst(rst),
        .play(1'b1),
        .notes(notes),
        .new_note(new_note),
        .note(note),
        .new_beat(new_beat),
        .duration(duration)
    );

    // Assuming you want to store the 'on' values for all pixels
    reg [SCREEN_WIDTH-1:0] row_values;
    integer i, j;

    initial begin
        forever #5 clk = ~clk;
    end

    task toggle_new_beat;
        input integer times;
        integer i;
        begin
            repeat (times) begin
                #10 new_beat = 1; #10 new_beat = 0;
            end
        end
    endtask

    initial begin
        rst = 1;
        new_note = 0;
        #10 rst = 0;
        #10 note = 6'd27; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd28; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd29; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd30; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd31; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd32; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd33; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd34; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd35; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd36; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd37; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd38; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd39; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd40; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd41; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        #10 note = 6'd42; duration = 7'd16; new_note = 1; #10 new_note = 0; toggle_new_beat(16);
        
        // #10;
        // for (i = 0; i < 2*DISPLAYED_BEATS*SIMULTANEOUS_NOTES; i = i + 1) begin
        //     $display("%d %d %d", notes[i][19:14], notes[i][13:7], notes[i][6:0]);
        // end
        // $finish;

        repeat (3) begin
            #10;
            for (x = 0; x < SCREEN_WIDTH + 2; x = x + 1) begin
                $write("1");
            end
            $write("\n");
            for (y = 0; y < SCREEN_HEIGHT; y = y + 1) begin
                // Loop through all x values
                row_values = 0;
                $write("1");
                for (x = 0; x < SCREEN_WIDTH; x = x + 1) begin
                    #10; // Clock delay for simulation stability
                    if (on)
                        $write("1");
                    else
                        $write("0");
                end
                $write("1");
                $write("\n");
            end
            for (x = 0; x < SCREEN_WIDTH + 2; x = x + 1) begin
                $write("1");
            end
            $write("\n");
            #10 new_beat = 1; #10 new_beat = 0;
        end
        $finish;
    end

endmodule