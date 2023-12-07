module color (
    input wire [1:0] pixel_type, instrument_type,
    output reg [7:0] r, g, b
);

reg [2:0] color_choice;

always @(*) begin
    case(pixel_type)
        2'b00: color_choice = instrument_type;
        2'b01: color_choice = 3'b011;
        2'b10: color_choice = 3'b100;
        2'b11: color_choice = 3'b101;
        default: color_choice = 3'b101;
    endcase
end

always @(*) begin
    case(color_choice)
        3'b000: {r,g,b} = 24'hFF0000;
        3'b001: {r,g,b} = 24'h00FF00;
        3'b010: {r,g,b} = 24'h0000FF;
        3'b011: {r,g,b} = 24'hFFFFFF;
        3'b100: {r,g,b} = 24'hFFFFFF;
        3'b101: {r,g,b} = 24'h000000;
        3'b110: {r,g,b} = 24'h000000;
        3'b111: {r,g,b} = 24'h000000;
        default: {r,g,b} = 24'h000000;
    endcase
end

endmodule
