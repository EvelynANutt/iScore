module scale_tb (

);

reg [7:0] r_in, g_in, b_in;
wire [7:0] r_out, g_out, b_out;
reg [23:0] expected_color;

wire [7:0] r_out2, g_out2, b_out2;
reg [23:0] expected_color_2;

// Test both half and quarter scaling
scale #(3'd2) half_test (
    .r_in(r_in),
    .g_in(g_in),
    .b_in(b_in),
    .r_out(r_out),
    .g_out(g_out),
    .b_out(b_out)
);
scale #(3'd4) quarter_test (
    .r_in(r_in),
    .g_in(g_in),
    .b_in(b_in),
    .r_out(r_out2),
    .g_out(g_out2),
    .b_out(b_out2)
);

initial begin

    // Test black color
    r_in = 8'b00000000;
    g_in = 8'b00000000;
    b_in = 8'b00000000;
    expected_color = 24'h000000;
    expected_color_2 = 24'h000000;
    #10
    $display("actual half %h, expected half %h, actual quarter %h, expected quarter %h", {r_out,g_out,b_out}, expected_color, {r_out2,g_out2,b_out2}, expected_color_2);

    // Test red color
    r_in = 8'b11111111;
    g_in = 8'b00000000;
    b_in = 8'b00000000;
    expected_color = 24'h7F0000;
    expected_color_2 = 24'h3F0000;
    #10
    $display("actual half %h, expected half %h, actual quarter %h, expected quarter %h", {r_out,g_out,b_out}, expected_color, {r_out2,g_out2,b_out2}, expected_color_2);

    // Test green color
    r_in = 8'b00000000;
    g_in = 8'b11111111;
    b_in = 8'b00000000;
    expected_color = 24'h007F00;
    expected_color_2 = 24'h003F00;
    #10
    $display("actual half %h, expected half %h, actual quarter %h, expected quarter %h", {r_out,g_out,b_out}, expected_color, {r_out2,g_out2,b_out2}, expected_color_2);

    // Test blue color
    r_in = 8'b00000000;
    g_in = 8'b00000000;
    b_in = 8'b11111111;
    expected_color = 24'h00007F;
    expected_color_2 = 24'h00003F;
    #10
    $display("actual half %h, expected half %h, actual quarter %h, expected quarter %h", {r_out,g_out,b_out}, expected_color, {r_out2,g_out2,b_out2}, expected_color_2);

    // Test yellow color
    r_in = 8'b00000000;
    g_in = 8'b01111111;
    b_in = 8'b01111111;
    expected_color = 24'h003F3F;
    expected_color_2 = 24'h001F1F;
    #10
    $display("actual half %h, expected half %h, actual quarter %h, expected quarter %h", {r_out,g_out,b_out}, expected_color, {r_out2,g_out2,b_out2}, expected_color_2);

    // Test white color
    r_in = 8'b11111111;
    g_in = 8'b11111111;
    b_in = 8'b11111111;
    expected_color = 24'h7F7F7F;
    expected_color_2 = 24'h3F3F3F;
    #10
    $display("actual half %h, expected half %h, actual quarter %h, expected quarter %h", {r_out,g_out,b_out}, expected_color, {r_out2,g_out2,b_out2}, expected_color_2);

end

endmodule