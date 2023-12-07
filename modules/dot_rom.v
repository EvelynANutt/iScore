`include "constants.v"

module dot_rom(
    input [2:0] addr,
    output reg [`DOT_WIDTH-1:0] data
);
    always @(addr)
        case (addr)
            3'd0: data = 8'b00111100;
            3'd1: data = 8'b01111110;
            3'd2: data = 8'b11111111;
            3'd3: data = 8'b11111111;
            3'd4: data = 8'b11111111;
            3'd5: data = 8'b11111111;
            3'd6: data = 8'b01111110;
            3'd7: data = 8'b00111100;
            default: data = 8'b0;
        endcase

endmodule