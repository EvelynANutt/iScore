module counter_flop_tb (

);

    reg [19:0] count_enable_in;
    reg clk;
    reg rst;
    reg [11:0] x;
    reg [10:0] y;
    reg [3:0] count_enable_out;
    reg [3:0] count_enable_out_2;
    wire pixel_on;
    wire pixel_on_2;
    wire [3:0] expected_count_ms;
    wire [3:0] expected_count_hs;

    // Need to test 2 cases for when we need the ns count and when we don't
    
    counter_flop #(.X_BOX(11'820), .Y_BOX(10'd72), .COUNT_SIZE(5'd20)) ms_test (
        .count_enable_in(count_enable_in),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .count_enable_out(count_enable_out),
        .pixel_on(pixel_on)
    )

    counter_flop #(.X_BOX(11'770), .Y_BOX(10'd72), .COUNT_SIZE(5'd4)) hs_test (
        .count_enable_in(count_enable_out),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .count_enable_out(count_enable_out_2),
        .pixel_on(pixel_on_2)
    )


    initial begin
        forever #5 clk = ~clk;
    end

    // Initial block for testbench stimulus
    initial begin
        // Initialize inputs
        clk = 1'b0;
        rst = 1'b1;
        x = 1'b0;
        y = 1'b0;
        count_enable_in = 1'b0;
        count_enable_in_2 = 1'b0;
        expected_count_ms = 4'd0;
        expected_count_hs = 4'd0;
        #10;
        reset = 1'b0;
        
        /* For the ms clock, we should check that the count is going up every 999999ns or so
        Let's wait that long and check for a 1. */
        #100000
        expected_count_ms = 4'd1;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);


        /* On the waveform, count_enable_out should read 1. If so, we can assume that the char_display 
        instantiation will work based on the complete functionality of our previous testbenches. 
        For good measure, let's wait again and see the count go up. */
        #100000
        expected_count_ms = 4'd2;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000
        expected_count_ms = 4'd3;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000
        expected_count_ms = 4'd4;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);

        /* For the hs clock, we should check the the count is going up every 9ms, and count_enable_out
        for the ms clock should reset at that point. */
        #100000
        expected_count_ms = 4'd5;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000
        expected_count_ms = 4'd6;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000
        expected_count_ms = 4'd7;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000
        expected_count_ms = 4'd8;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000
        expected_count_ms = 4'd9; // Our DFF waits a clock cycle before updating 
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        #100000

        // It should have changed around here.
        expected_count_ms = 4'd0;
        expected_count_hs = 4'd1;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        $display("actual %d, expected %d", count_enable_out_2, expected_count_hs);

        // Some more time for good measure. If nothing looks unordinary, this module works.
        #100000
        #100000
        #100000
        #100000

        /* With this testbench, we will assume the complete functionality of the counter flop module
        implies the complete functionality of all instantiations of counter flop. */

        $finish;
    end

endmodule