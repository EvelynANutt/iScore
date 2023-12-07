module note_player_tb();

    reg clk, reset, play_enable, generate_next_sample;
    reg [5:0] note_to_load;
    reg [1:0] instrument;
    reg [2:0] volume;
    wire new_sample_ready;
    wire [15:0] sample_out;

    note_player np(
        .clk(clk),
        .reset(reset),

        .play_enable(play_enable),
        .note(note_to_load),
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
        volume = 0;
    
        #25;
        
        play_enable = 1'b1;

        note_to_load = 6'd35; // Initialize note_to_load, note from song_rom: 3G
        instrument = 2'd0;
        volume = 3'd2;
        #10; 
        repeat (1000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
        end
        
        volume = 3'd7;
        #10; 
        repeat (1000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
        end
        
        note_to_load = 6'd35; // Initialize note_to_load, note from song_rom: 3G
        instrument = 2'd1;
        volume = 3'd2;
        #10; 
        repeat (1000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
        end
        
        note_to_load = 6'd35; // Initialize note_to_load, note from song_rom: 3G
        instrument = 2'd2;
        volume = 3'd7;
        #10; 
        repeat (1000) begin
            generate_next_sample = 1'b1;
            #10;
            generate_next_sample = 1'b0;
            #10;
        end
        
    
        
        $stop;
    end

endmodule