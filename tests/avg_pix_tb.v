module avg_pix_tb (

);

reg [7:0] a,b,c,d,e,f,g,h,orig;
wire [7:0] new_color;
reg [7:0] expected_color;

avg_pix avg_pix_test (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g),
    .h(h),
    .orig(orig),
    .new_color(new_color)
);

initial begin

    // Test smallest possible case
    a = 8'b00000000;
    b = 8'b00000000;
    c = 8'b00000000;
    d = 8'b00000000;
    e = 8'b00000000;
    f = 8'b00000000;
    g = 8'b00000000;
    h = 8'b00000000;
    orig = 8'b00000000;
    expected_color = 8'b00000000;
    #10
    $display("actual %h, expected %h", new_color, expected_color);

    // Test largest possible case
    a = 8'b00111111;
    b = 8'b01111111;
    c = 8'b00111111;
    d = 8'b01111111;
    e = 8'b00111111;
    f = 8'b01111111;
    g = 8'b00111111;
    h = 8'b01111111;
    orig = 8'b11111111;
    expected_color = 8'b11111101;
    #10
    $display("actual %h, expected %h", new_color, expected_color);

    // Test a random collection in the middle
    a = 8'b00011111;
    b = 8'b00111111;
    c = 8'b00011111;
    d = 8'b00111111;
    e = 8'b00011111;
    f = 8'b00111111;
    g = 8'b00011111;
    h = 8'b00111111;
    orig = 8'b01111111;
    expected_color = 8'b01111101;
    #10
    $display("actual %h, expected %h", new_color, expected_color);

end

endmodule