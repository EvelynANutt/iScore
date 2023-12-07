module song_progression_tb (

);

    reg reset_player, song_done, play, clk, rst;
    reg [10:0] x;
    reg [9:0] y;
    reg [7:0] pixel_on;

    song_progression #(.X_COORD(11'd820), .Y_COORD(10'd72), .BOX_WIDTH(8'd50)) (
        .reset_player(reset_player),
        .song_done(song_done),
        .play(play),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .pixel_on(pixel_on)
    )    

    initial begin
        forever #5 clk = ~clk;
    end

    // Initial block for testbench stimulus
    initial begin
        // Initialize inputs
        reset_player = 1'b1;
        song_done = 1'b1;
        play = 1'b0;
        clk = 1'b0;
        rst = 1'b1;
        x = 11'd0;
        y = 10'd0;

        #10;
        reset = 1'b0;
        song_done = 1'b0;
        play = 1'b1;
        x = 11'd848;
        y = 10'd74;
        
        // A song should now be playing. We should turn this pixel turn on and off in periods of ms.
        
        #100000
        #100000
        #100000
        #100000
        #100000

        /* With this testbench, we will assume the complete functionality of 
        the song progression module. */

        $finish;
    end

endmodule