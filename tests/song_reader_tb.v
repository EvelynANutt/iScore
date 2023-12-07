module song_reader_tb();

    reg clk, rst, play;
    reg [1:0] song;
    wire [5:0] note;
    wire [6:0] duration;
    wire song_done, new_note, new_beat;

    song_reader sr(
        .clk(clk),
        .rst(rst),
        .song(song),
        .new_beat(new_beat),
        .play(play),
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note)
    );

    beat_generator #(.WIDTH(17), .STOP(1500)) beat_generator(
        .clk(clk),
        .reset(rst),
        .en(1'b1),
        .beat(new_beat)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        repeat (4) #5 clk = ~clk;
        rst = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    initial begin
        // Initialize
        play = 0;
        song = 2'b00;
        #25;

        // Test 1: Play songs of index 0, 1, 2, 3, and 0 again
        play = 1;
        repeat (5) begin
            while (!song_done) begin
                if (!song_done) #10; // Simulate note duration
                if (!song_done) #10; // Delay between notes
                if (!song_done) #10; // Delay between notes
            end
            song = song + 2'd1;
            #10;
        end
        $finish;
    end

endmodule