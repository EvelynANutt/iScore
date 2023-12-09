module color (
    input wire [1:0] instrument_type,
    input wire [5:0] pixel_type,
    output reg [7:0] r, g, b
);

reg [2:0] color_choice;

always @(*) begin
    case(pixel_type)
        6'b000001: color_choice = 3'b100;
        6'b000010: color_choice = 3'b100;
        6'b000100: color_choice = 3'b100;
        6'b001000: color_choice = 3'b100;
        6'b010000: color_choice = instrument_type;
        6'b100000: color_choice = 3'b111;
        6'b000000: color_choice = 3'b101;
        default: color_choice = 3'b101;
    endcase
end

always @(*) begin
    case(color_choice)
        3'b000: {r,g,b} = 24'hFF0000;
        3'b001: {r,g,b} = 24'h00FF00;
        3'b010: {r,g,b} = 24'h0000FF;
        3'b100: {r,g,b} = 24'hFFFFFF;
        3'b101: {r,g,b} = 24'h000000;
        3'b111: {r,g,b} = 24'h00FFFF;
        default: {r,g,b} = 24'h000000;
    endcase
end

endmodule
