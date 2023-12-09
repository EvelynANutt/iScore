module color_tb (

);

reg [4:0] pixel_type;
reg [1:0] instrument_type;
wire [7:0] r, g, b;
reg [23:0] expected_color;

color color_test (
    .pixel_type(pixel_type),
    .instrument_type(instrument_type),
    .r(r),
    .g(g),
    .b(b)
);

initial begin

    // Note pixel, try all 4 instrument types
    // Violin audio
    pixel_type = 5'b00001;
    instrument_type = 3'b000;
    expected_color = 24'hFF0000;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

    // Piano audio
    pixel_type = 5'b10000;
    instrument_type = 3'b001;
    expected_color = 24'h00FF00;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

    // Electric audio
    pixel_type = 5'b10000;
    instrument_type = 3'b010;
    expected_color = 24'h0000FF;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

    // Default audio
    pixel_type = 5'b10000;
    instrument_type = 3'b011;
    expected_color = 24'hFFFFFF;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

    // Staff line pixel
    pixel_type = 5'b00010;
    expected_color = 24'hFFFFFF;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

    // Text pixel
    pixel_type = 5'b00100;
    expected_color = 24'hFFFFFF;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

    // Any other pixel
    pixel_type = 5'b00000;
    expected_color = 24'h000000;
    #10
    $display("actual %h, expected %h", {r,g,b}, expected_color);

end

endmodule