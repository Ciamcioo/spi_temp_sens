module bcd_register_tb;

    reg clk;
    reg [23:0] spi_data_mock;
    wire [15:0] bcd_values;



    bcd_register register(
        .new_data_triger(clk),
        .spi_data(spi_data_mock),
        .bcd_values(bcd_values)
    );

    always #5 clk=~clk;

    initial begin
        clk = 0;
        spi_data_mock = 24'b0;
        bcd_register_test();
    end

    task bcd_register_test();
        begin
            $monitor("Time: %0t Applied spi_data_mock = %d | bcd_values = %b %b %b %b ", 
                     $time, 
                     spi_data_mock[23:8], 
                     bcd_values[15:12],
                     bcd_values[11:8],
                     bcd_values[7:4],
                     bcd_values[3:0]
                     );

            #10 spi_data_mock = 24'h006464;
            #20 spi_data_mock = 24'h00;
            #30 spi_data_mock = 24'h04444;
            #100 $finish;
        end
    endtask

endmodule

