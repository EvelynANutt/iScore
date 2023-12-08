module counter_flop_tb (

);

    reg [19:0] count_enable_in;
    reg clk;
    reg rst;
    reg [10:0] x;
    reg [9:0] y;
    wire [3:0] count_enable_out;
    wire [3:0] count_enable_out_2;
    wire pixel_on;
    wire pixel_on_2;
    reg [3:0] expected_count_ms;
    reg [3:0] expected_count_hs;
    
    parameter X_BOX = 11'd820;
    parameter Y_BOX = 10'd72;
    parameter COUNT_SIZE = 5'd20;
    
    reg [19:0] count;

    // Need to test 2 cases for when we need the ns count and when we don't
    
    counter_flop #(X_BOX, Y_BOX, COUNT_SIZE) ms_test (
        .count_enable_in(count_enable_in),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .count_enable_out(count_enable_out),
        .pixel_on(pixel_on)
    );

    counter_flop #(X_BOX - 11'd50, Y_BOX, COUNT_SIZE - 5'd16) hs_test (
        .count_enable_in(count_enable_out),
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .count_enable_out(count_enable_out_2),
        .pixel_on(pixel_on_2)
    );


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
        count_enable_in = 20'd0;
        expected_count_ms = 4'd0;
        expected_count_hs = 4'd0;
        #10;
        rst = 1'b0;
        
        /* For the ms clock, we should check that the count is going up every 999999ns or so
        Let's wait that long and check for a 1. */
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        
        /* At this point, count_enable_in should equal 20'd999999, enabling the flip flop.
        After the previous clock cycle, the flip flop should have incremented. */
        expected_count_ms = 4'd1;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;

        /* On the waveform, count_enable_out should read 1 like expected. If so, we can assume that 
        the char_display instantiation will work based on the complete functionality of our previous
        testbenches. For good measure, let's wait again and see the count go up. */
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd2;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;

        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd3;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;
        
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd4;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;

        /* For the hs clock, we should check the the count is going up every 9ms, and count_enable_out
        for the ms clock should reset at that point. */
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd5;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;

        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd6;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;
        
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd7;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;

        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd8;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;
        
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        expected_count_ms = 4'd9;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        count_enable_in = 20'd0;
        
        // Wait another milisecond for the hs DFF to update
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        
        // The hs DFF should have incremented here.
        expected_count_ms = 4'd0;
        expected_count_hs = 4'd1;
        $display("actual %d, expected %d", count_enable_out, expected_count_ms);
        $display("actual %d, expected %d", count_enable_out_2, expected_count_hs);
        count_enable_in = 20'd0;
        
        // Some more time for good measure. If nothing looks unordinary, this module works.
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end
        
        for (count = 20'd0; count < 20'd1000010; count = count + 1'd1) begin
            count_enable_in = count;
            #1;
        end

        /* With this testbench, we will assume the complete functionality of the counter flop module
        implies the complete functionality of all instantiations of counter flop. */

        $finish;
    end

endmodule