`include "headers/seven_segment_defines.vh"

module ss_display (
    // Bits passed from BCD register 
    input wire [15:0] bcd_register,
    // External clock
    input wire clk,
    
    // Control pins to specife digit on the display
    output wire [3:0] control_pins,
    // Seven pins for seven segment display to represent digit
    output wire [6:0] display_pins
    );

    // INTERNAL WIRES
    wire display_clk;
    
    // INTERNAL REGISTERS
    reg [6:0] display_reg;
    reg [3:0] control_reg;

     // INETRNAL MODULES
     presc #(
        .value(4)
        ) prescaler_inst (
           .clk_in(clk),
           .clk_out(display_clk)
        ); 

     // ASSIGNS
     assign display_pins[6:0] = display_reg[6:0];
     assign control_pins[3:0] = control_reg[3:0];  


     // INITIALIZATION
     initial begin
         display_reg[6:0] = 7'b0;
         control_reg[3:0] = 4'b0001;
     end

     always @(negedge display_clk) begin
        case (control_reg)
            4'b0001: begin
                display_reg[6:0] = convert_number_to_ss_digit(bcd_register[3:0]);
                control_reg = control_reg << 1;
            end
            4'b0010: begin
                display_reg[6:0] = convert_number_to_ss_digit(bcd_register[7:4]);
                control_reg = control_reg << 1;
            end
            4'b0100: begin
                display_reg[6:0] = convert_number_to_ss_digit(bcd_register[11:8]);
                control_reg = control_reg << 1;
            end
            4'b1000: begin
                display_reg[6:0] = convert_number_to_ss_digit(bcd_register[15:12]);
                control_reg = 4'b0001;
            end
        endcase 
     end

    function [7:0] convert_number_to_ss_digit;
        input [4:0] number;

        begin
           case (number)
               4'b0000: convert_number_to_ss_digit = `SEG_0; 
               4'b0001: convert_number_to_ss_digit = `SEG_1; 
               4'b0010: convert_number_to_ss_digit = `SEG_2; 
               4'b0011: convert_number_to_ss_digit = `SEG_3; 
               4'b0100: convert_number_to_ss_digit = `SEG_4; 
               4'b0101: convert_number_to_ss_digit = `SEG_5; 
               4'b0110: convert_number_to_ss_digit = `SEG_6; 
               4'b0111: convert_number_to_ss_digit = `SEG_7; 
               4'b1000: convert_number_to_ss_digit = `SEG_8; 
               4'b1001: convert_number_to_ss_digit = `SEG_9; 
               default: convert_number_to_ss_digit = `SEG_0;
            endcase 
        end
    endfunction
      
endmodule
