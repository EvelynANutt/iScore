module sine_reader_tb();

    reg clk, reset, generate_next;
    reg [19:0] step_size;
    wire sample_ready;
    wire [15:0] sample;
    sine_reader reader(
        .clk(clk),
        .rst(reset),
        .step_size(step_size),
        .generate_next(generate_next),
        .sample_ready(sample_ready),
        .sample(sample)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    initial begin
        #25;
        step_size = 20'b0000001010_1000000000;
        repeat (1000) begin
            generate_next = 1;
            #10;
            generate_next = 0;
            #10;
        end
        
        step_size = 20'b0010001010_1001001000;
        repeat (1000) begin
            generate_next = 1;
            #10;
            generate_next = 0;
            #10;
        end
        
        step_size = 20'b0011101010_1001101001;
        repeat (1000) begin
            generate_next = 1;
            #10;
            generate_next = 0;
            #10;
        end
        
        step_size = 20'b0000000110_0010000000;
        repeat (1000) begin
            generate_next = 1;
            #10;
            generate_next = 0;
            #10;
        end
        
        $stop;

    end

endmodule