module anti_aliasing_tb (

);

    reg clk;
    reg reset;
    reg [10:0] x;
    reg [9:0] y;
    reg valid;
    reg [7:0] read_value;
    reg read_index;
    wire [8:0] read_address;
    wire valid_pixel;
    wire [7:0] r;
    wire [7:0] g;
    wire [7:0] b;
    
    wave_display UUT (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
        .read_value(read_value),
        .read_index(read_index),
        .read_address(read_address),
        .valid_pixel(valid_pixel),
        .r(r),
        .g(g),
        .b(b)
    );

    initial begin
        forever #5 clk = ~clk;
    end

    // Initial block for testbench stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1'b1;
        x = 0;
        y = 0;
        valid = 0;
        read_value = 0;
        read_index = 0;

        #10;
        reset = 1'b0;
        valid = 1'b1;
        
        // Check for correct pixel turning on for a simulated sawtooth wave
        for (x = 11'd0; x < 11'b11111111111; x = x + 11'd1) begin
            y = 10'd128; // Check for pixel (x, 128), should only turn on when the wave crosses this y
            read_value = x[7:0]; // Simulate a ramp wave value
            read_index = x[8];
            #100;
        end
        
        valid = 1'b0;
        // Nothing should turn on because coords not valid
        for (x = 11'd0; x < 11'b11111111111; x = x + 11'd1) begin
            y = 10'd128; // Check for pixel (x, 128), should only turn on when the wave crosses this y
            read_value = x[7:0]; // Simulate a ramp wave value
            read_index = x[8];
            #100;
        end
        valid = 1'b1;
        
        // Check for correct pixel turning on for a simulated line (pixel should be on for all xs in the valid quadrants)
        for (x = 11'd0; x < 11'b11111111111; x = x + 11'd1) begin
            y = 10'd192;
            read_value = 11'd128;
            read_index = x[8];
            #100;
        end
        $finish;
    end

endmodule