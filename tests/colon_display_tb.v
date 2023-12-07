module colon_display_tb (

);

reg [10:0] pixel_x;
reg [9:0] pixel_y;
wire pixel_on;
reg expected_on;

// Instantiate with correct box corner
colon_display #(.X_BOX(11'd700), .Y_BOX(10'd72)) colon_display_test (
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .pixel_on(pixel_on)
);

initial begin
    // Pixel on the corner
    pixel_x = 11'd700;
    pixel_y = 10'd72;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

    // Pixel in the middle, random
    pixel_x = 11'd710;
    pixel_y = 10'd90;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

    // Pixel in the middle, on the colon
    pixel_x = 11'd708;
    pixel_y = 10'd100;
    expected_on = 1'b1;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

    // Pixel on x boundary of the box
    pixel_x = 11'd720;
    pixel_y = 10'd100;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);
    
    // Pixel on the y boundary of the box
    pixel_x = 11'd720;
    pixel_y = 10'd112;
    expected_on = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected_on);

end

endmodule