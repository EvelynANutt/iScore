module counter_flop #(parameter X_BOX = 11'd0, Y_BOX = 10'd0, COUNT_SIZE = 5'd0) (
    input wire [COUNT_SIZE-1:0] count_enable_in,
    input wire clk, rst,
    input wire [11:0] x,
    input wire [10:0] y,
    output wire [3:0] count_enable_out,
    output reg pixel_on
);

wire [3:0] current_time, next_time, time_select;
reg [19:0] prev_count;

dffre #(3) counter(.clk(clk), .r(rst), .en(count_enable_in >= prev_count), .d(time_select), .q(current_time));
assign next_time = current_time + 4'd1;
assign time_select = (next_time < 4'd9) ? next_time : 4'd0;
assign count_enable_out = next_time;

always @(*) begin
    if (COUNT_SIZE == 5'd20) begin
        assign prev_count = 20'd999999;
    end
    else if (COUNT_SIZE == 5'd4) begin
        assign prev_count = 4'd9;
    end
    else begin
        assign prev_count = 20'd0;
    end
end

char_display #(.X_BOX(X_BOX), .Y_BOX(Y_BOX)) digit_display(
    .pixel_x(x),
    .pixel_y(y),
    .rom_base_addr((current_time * 9'd8) + 9'h180),
    .pixel_on(pixel_on)
);

endmodule