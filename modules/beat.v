module beat #(parameter
    TIME_BITS = 0,
    BEAT_BITS = 0,
    BEAT_DURATION = 0
) (
    input wire clk,
    input wire rst,
    input wire [TIME_BITS-1:0] cur_time,
    output wire [BEAT_BITS-1:0] cur_beat,
    output wire new_beat
);

assign cur_beat = cur_time / BEAT_DURATION;

wire [BEAT_BITS-1:0] prev_beat;
dffr #(
    .WIDTH(BEAT_BITS)
) new_beat_flop (
    .clk(clk),
    .r(rst),
    .d(cur_beat),
    .q(prev_beat)
);
assign new_beat = cur_beat != prev_beat;

endmodule