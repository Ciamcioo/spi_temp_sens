<<<<<<< HEAD
module top
  (
    input btn_0,
    input sys_clk_pin,
    input phy_miso,

    output led_0,
    output phy_sck,
    output phy_mosi,
    output phy_cs,

    output [2:0]led
  );

wire clk_scaled;

reg [3:0]in_bytes_count;
reg [3:0]out_bytes_count;

reg [31:0]in_bytes;
wire [31:0]out_bytes;

wire led_inter;

wire start_trans;
wire trans_done;

localparam check_con     = 3'b000;
localparam set_options   = 3'b001;
localparam chk_options   = 3'b010;
localparam read_temp     = 3'b011;

reg [2:0] cur_state;

reg led_reg;

assign led_0 = led_reg;

initial begin
  in_bytes_count    =     2'b01;
  out_bytes_count   =     2'b01;

  in_bytes          =     8'h01;

  led_reg           =     1'b0;

  cur_state         = check_con;
end

assign led = cur_state;

always @(posedge trans_done) begin
  case (cur_state)
    check_con:
      begin
        if (out_bytes[7:0] == 8'h03) begin
          cur_state   <= set_options;

          in_bytes_count        <= 3;
          out_bytes_count       <= 0;

          in_bytes[7:0]         <= 8'h03;
          in_bytes[15:8]        <= 8'h81;
          in_bytes[23:16]       <= 8'h80;
        end
        led_reg     <= ~led_reg;
      end
    set_options:
      begin
          in_bytes_count        <= 3;
          out_bytes_count       <= 0;

          in_bytes[7:0]         <= 8'h03;
          in_bytes[15:8]        <= 8'h81;
          in_bytes[23:16]       <= 8'h80;

          led_reg               <= 1'b1;
          cur_state             <= chk_options;
      end
    chk_options:
      begin
          in_bytes_count        <= 2'b01;
          out_bytes_count       <= 2'b10;

          in_bytes[7:0]         <= 8'h00;

          if (out_bytes[15:8] == 8'h81 && out_bytes[7:0] == 8'h03) begin
            cur_state <= read_temp;
          end
      end

    read_temp:
      begin
          in_bytes_count        <= 2'b01;
          out_bytes_count       <= 2'b10;

          in_bytes[7:0]         <= 8'h0C;

          if (out_bytes[15:8] == 8'h81 && out_bytes[7:0] == 8'h03) begin
            cur_state <= read_temp;
          end
      end
  endcase
end

presc     pre0
          (
            .clk_in_p(sys_clk_pin),
            .clk_out_p(clk_scaled)
          );

timer     tim0
          (
            .clk_in(sys_clk_pin),
            .sig_out(start_trans)
          );
=======
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
>>>>>>> 2158503 (Module implemenatation of seven segment display)

spi       spi0
          (
            .sck_in(clk_scaled),

            .miso(phy_miso),
            .sck_out(phy_sck),
            .mosi(phy_mosi),
            .cs(phy_cs),

            .in_bytes_count(in_bytes_count),
            .out_bytes_count(out_bytes_count),

            .in_bytes(in_bytes),
            .out_bytes(out_bytes),

            .start_trans(start_trans),
            .trans_done(trans_done)
          );


endmodule
