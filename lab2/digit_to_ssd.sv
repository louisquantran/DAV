`timescale 1ns / 1ps

module digit_to_ssd(
    input logic [3:0] digit,
    output logic [6:0] display_bits
);
    always_comb begin 
        case (digit)
            4'b0001: display_bits = 7'b1111001;
            4'b0010: display_bits = 7'b0100100;
            4'b0011: display_bits = 7'b0110000;
            4'b0100: display_bits = 7'b0011001;
            4'b0101: display_bits = 7'b0010010;
            4'b0110: display_bits = 7'b0000010;
            4'b0111: display_bits = 7'b1111000;
            4'b1000: display_bits = 7'b0000000;
            4'b1001: display_bits = 7'b0010000;
            default: display_bits = 7'b1000000;
        endcase
    end
endmodule
