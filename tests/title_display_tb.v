module title_display_tb (

);

reg [10:0] x;
reg [9:0] y;
reg [8:0] char1, char2, char3, char4, char5,
    char6, char7, char8, char9, char10, char11, char12;
reg pixel_on;
wire expected;

title_display #(.X_COORD(11'd88), .Y_COORD(10'd32), .BOX_WIDTH(8'd40)) title_display_test (
    .x(x),
    .y(y),
    .char1(char1),
    .char2(char2),
    .char3(char3),
    .char4(char4),
    .char5(char5),
    .char6(char6),
    .char7(char7),
    .char8(char8),
    .char9(char9), 
    .char10(char10),
    .char11(char11),
    .char12(char12),
    .pixel_on(pixel_on)
);

initial begin
    /* The parameters for the module are used for instantiating the song title. 
    With this testbench, we will assume the complete functionality of the song title display
    implies the complete functionality of the instrument text */

    // Use the song title "pink panther"
    char1 = 9'h080; char2 = 9'h048; char3 = 9'h070; char4 = 9'h058;
    char5 = 9'h100; char6 = 9'h080; char7 = 9'h008; char8 = 9'h070;
    char9 = 9'h0a0; char10 = 9'h040; char11 = 9'h028; char12 = 9'h090;

    // Check for a pixel on char 1
    x = 11'd106;
    y = 10'd32;
    expected = 1'b1;
    #10
    $display("actual %b, expected %b", pixel_on, expected);

    // Check for a pixel on char 9
    x = 11'd426;
    y = 10'd38;
    expected = 1'b1;
    #10
    $display("actual %b, expected %b", pixel_on, expected);
    
    // Check for a pixel within the bounds of these boxes, but not on a char
    x = 11'd558;
    y = 10'd38;
    expected = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected);
    
    // Check for a pixel outside of the bounds of these boxes
    x = 11'd366;
    y = 10'd115;
    expected = 1'b0;
    #10
    $display("actual %b, expected %b", pixel_on, expected);

end

endmodule