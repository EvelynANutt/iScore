`define assert(valid) \
    if (!(valid)) begin \
        $display("ASSERTION FAILED in %m"); \
        $finish; \
    end

module mcu_tb();
    reg clk, reset, play_button, next_button, song_done;
    wire play, reset_player;
    wire [1:0] song;

    mcu dut(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(song),
        .song_done(song_done)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    initial begin
        // Wait for reset to complete
        play_button = 1'b0;
        next_button = 1'b0;
        song_done = 1'b0;
        #25;

        // Check initial pause state
        $display("Initial state: play=%b, song=%d", play, song);
        `assert(!play)
        #20;

        // Press play
        play_button = 1'b1;
        #10 play_button = 1'b0;
        #10;
        $display("After pressing play: play=%b, song=%d", play, song);
        `assert(play)
        #20;

        // Press play again to pause
        play_button = 1'b1;
        #10 play_button = 1'b0;
        #10;
        $display("After pressing play again: play=%b, song=%d", play, song);
        `assert(!play)
        #20;

        // Press play again to keep going
        play_button = 1'b1;
        #10 play_button = 1'b0;
        #10;
        $display("After pressing play again: play=%b, song=%d", play, song);
        `assert(play)
        #20;

        // Press next
        next_button = 1'b1;
        #10 next_button = 1'b0;
        #10;
        $display("After pressing next: play=%b, song=%d", play, song);
        `assert(!play)
        `assert(song == 2'd1)
        #20;

        // Press play again to start
        play_button = 1'b1;
        #10 play_button = 1'b0;
        #10;
        $display("After pressing play again: play=%b, song=%d", play, song);
        `assert(play)
        #20;

        // 5. Finish the song
        song_done = 1'b1;
        #10 song_done = 1'b0;
        #10;
        $display("After song done: play=%b, song=%d", play, song);
        `assert(!play)
        `assert(song == 2'd2)
        #20;

        // Test wrap around
        next_button = 1'b1; // Go to song 3
        #10 next_button = 1'b0;
        #10;
        next_button = 1'b1; // Go to song 0
        #10 next_button = 1'b0;
        #10;
        $display("After pressing next twice: play=%b, song=%d", play, song);
        `assert(!play)
        `assert(song == 2'd0)
        #20;

        $finish;
    end

endmodule