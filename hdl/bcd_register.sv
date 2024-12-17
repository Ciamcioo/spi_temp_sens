module bcd_register (
    // Bits passed from SPI 
    input wire [23:0] spi_data,
    // Triger input to recive data
    input wire new_data_triger,

    // Content of BCD register
    output wire [15:0] bcd_values
    );

    // INTERNAL REGISTERS
    reg [15:0] spi_data_reg;
    reg [15:0] bcd_values_reg;

    // INITIALIZATION
    initial begin
        spi_data_reg <= 16'b0;
        bcd_values_reg <= 16'b0;
    end

    // ASIGNS
    assign bcd_values[15:0] = bcd_values_reg[15:0];

    /*
    * Function converting the spi_data into bcd_value 
    * stored on 3 bytes whenever the new_data_triger is
    * on posedge
    */
    always @(posedge new_data_triger) begin
        spi_data_reg <= spi_data[23:8];

        bcd_values_reg[3:0] = spi_data_reg%10;
        spi_data_reg = spi_data_reg/10;

        bcd_values_reg[7:4] = spi_data_reg%10;
        spi_data_reg = spi_data_reg/10;

        bcd_values_reg[11:8] = spi_data_reg%10;
        spi_data_reg = spi_data_reg/10;

        bcd_values_reg[15:12] = spi_data_reg%10;
        spi_data_reg = spi_data_reg/10;
    end


endmodule 
