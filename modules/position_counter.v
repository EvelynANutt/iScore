module position_counter #(parameter
    POS_BITS = 0,
    ARRAY_SIZE = 0
) (
    input wire clk,
    input wire rst,
    input wire en,
    output wire [POS_BITS-1:0] pos
);
    dffre #(POS_BITS) pos_counter (
        .clk(clk),
        .r(rst),
        .en(en),
        .d(next_pos),
        .q(pos)
    );
    wire at_last = pos == ARRAY_SIZE - 1'b1;
    wire [POS_BITS-1:0] next_pos = at_last ? 0 : pos + 1;
endmodule