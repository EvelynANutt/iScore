module char_display_tb (

);

reg [10:0] pixel_x;
reg [9:0] pixel_y;
reg [8:0] rom_base_addr;
reg pixel_on;
wire expected_on;

// Instantiate with first letter box corner
char_display #(.X_BOX(11'd88), .Y_BOX(10'd32)) char_display_test (
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .rom_base_addr(rom_base_addr),
    .pixel_on(pixel_on)
);

initial begin
    // Going to do all tests with letter E
    rom_base_addr = 9'h028;

    // Pixel on the corner
    pixel_x = 11'd88;
    pixel_y = 10'd32;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

    // Pixel in the middle, random
    pixel_x = 11'd118;
    pixel_y = 10'd50;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

    // Pixel in the middle, on the colon
    pixel_x = 11'd100;
    pixel_y = 10'd50;
    expected_on = 1'b1;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

    // Pixel on x boundary of the box
    pixel_x = 11'd138;
    pixel_y = 10'd60;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);
    
    // Pixel on the y boundary of the box
    pixel_x = 11'd138;
    pixel_y = 10'd72;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

end

endmodule