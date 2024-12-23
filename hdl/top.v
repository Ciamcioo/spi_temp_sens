module top(
  input btn_0,
  input wire sys_clk_pin,
  output [3:0] control_out_pins,
  output [6:0] display_out_pins, 
  output led_0
);


wire new_data;
wire [15:0] bcd_reg;
assign led_0 = new_data;

    
timer tim0 (
  .clk_in(sys_clk_pin),
  .sig_out(new_data)
);

bcd_register reg0 (
  .spi_data(16'h1234),
  .new_data_triger(sys_clk_pin),
  .bcd_values(bcd_reg)
);

ss_display dis0  (
    .bcd_register(bcd_reg),
    .clk(sys_clk_pin),
    .control_pins(control_out_pins),
    .display_pins(display_out_pins)
);

endmodule
