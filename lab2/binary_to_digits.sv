`timescale 1ns / 1ps

module binary_to_digits(
    input logic [$clog2(10000)-1:0] binary_in,
    output logic [3:0] digits [3:0]  
);
    always_comb begin
        if (binary_in > 9999) begin
            digits[0] = '0;
            digits[1] = '0;
            digits[2] = '0;
            digits[3] = '0;
            $display("Exceed 9999");
        end else begin
            digits[0] = binary_in / 1000;
            digits[1] = (binary_in / 100) % 10;
            digits[2] = (binary_in / 10) % 10;
            digits[3] = binary_in % 10;
        end
    end
endmodule
