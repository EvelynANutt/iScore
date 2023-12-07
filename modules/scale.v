module scale #(parameter DENOM = 3'd0) (
    input wire [7:0] r_in, g_in, b_in,
    output wire [7:0] r_out, g_out, b_out
)

assign r_out = r_in / DENOM;
assign g_out = g_in / DENOM;
assign b_out = b_in / DENOM;

endmodule