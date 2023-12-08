module song_progression_tb (

);

    reg reset_player, song_done, play, clk, rst;
    reg [10:0] x;
    reg [9:0] y;
    wire pixel_on;
    
    reg [19:0] count;

    song_progression #(.X_COORD(11'd820), .Y_COORD(10'd72), .BOX_WIDTH(8'd50)) song_progression_test (
        .reset_player(reset_player),
        .song_done(song_done),
        .play(play),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .pixel_on(pixel_on)
    );

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
        reset_player = 1'b0;
        song_done = 1'b0;
        play = 1'b1;
        rst = 1'b0;
        x = 11'd848;
        y = 10'd74;
        
        // A song should now be playing. We should see this pixel turn on and off in periods of ms.
        
        #100000
        for (count = 20'd0; count < 20'd1000; count = count + 1'd1) begin
            #10000000;
        end

        /* With this testbench, we will assume the complete functionality of 
        the song progression module. */

        $finish;
    end

endmodule