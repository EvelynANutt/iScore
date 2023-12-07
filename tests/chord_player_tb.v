module chord_player_tb();
    localparam SIMULTANEOUS_NOTES = 4;
    localparam NOTE_BITS = 6;

    reg clk, reset, play_enable, generate_next_sample;
    reg [NOTE_BITS-1:0] playing_notes [SIMULTANEOUS_NOTES-1:0];
    reg [1:0] instrument;
    reg [2:0] volume;
    wire new_sample_ready;
    wire signed [15:0] sample_out;

  chord_player #(.SIMULTANEOUS_NOTES(SIMULTANEOUS_NOTES), .NOTE_BITS(NOTE_BITS)) cp(
        .clk(clk),
        .reset(reset),
        .play_enable(play_enable),
        .playing_notes(playing_notes),
        .generate_next_sample(generate_next_sample),
        .instrument(instrument),
        .volume_target(volume),
        .sample_out(sample_out),
        .new_sample_ready(new_sample_ready)
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
        play_enable = 1'b1;

        //play a chord (3 notes at once)
        playing_notes[0] = 6'd28; // 3C
        playing_notes[1] = 6'd40; // 4C
        playing_notes[2] = 6'd52; // 5C
        playing_notes[3] = 6'd0;
        instrument = 2'd0;
        volume = 3'd7;
        
        #25;
        
        repeat (100000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
            $display("%0d", sample_out);
        end
        
        playing_notes[1] = 6'd0;
        repeat (100000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
            $display("%0d", sample_out);
        end

        playing_notes[2] = 6'd0; // Initialize note_to_load, note from song_rom: 5A 
        repeat (100000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
            $display("%0d", sample_out);
        end
      
        $stop;
    end

endmodule