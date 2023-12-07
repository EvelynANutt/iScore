module avg_pix (
    input wire [7:0] a, b, c, d, e, f, g, h, orig,
    output wire [7:0] new_color
)

wire [9:0] sum;
wire [9:0] weighted_avg;
assign sum = a + b + c + d + e + f + g + h + orig;
assign weighted_avg = sum / 3'd4;
assign new_color = weighted_avg[7:0];

endmodule
