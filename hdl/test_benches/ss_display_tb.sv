module ss_display_tb;

    reg clk_mock;
    reg [15:0] bcd_register_mock;
    wire [3:0] control_pins;
    wire [6:0] display_pins;

    ss_display test_display (
        .bcd_register(bcd_register_mock),
        .clk(clk_mock),
        .control_pins(control_pins),
        .display_pins(display_pins)
        );

    always #1 clk_mock=~clk_mock;

    initial begin
        clk_mock = 0;
        bcd_register_mock = 16'b0;
        ss_display_test();
    end

    task ss_display_test();
        begin
            $monitor("Time: %0t Applied bcd_register_mock = %b %b %b %b | control_pins = %b | display_pins = %b ",
              $time, 
              bcd_register_mock[15:12],
              bcd_register_mock[11:8],
              bcd_register_mock[7:4],
              bcd_register_mock[3:0],
              control_pins[3:0],
              display_pins[6:0]
              );
              #25 bcd_register_mock[15:0] = 16'b0011001000010000;
              #225 bcd_register_mock[15:0] = 16'b0111011001010100;
              #425 bcd_register_mock[15:0] = 16'b1001100010011000;
              #625 $finish;
        end
    endtask

    


endmodule
