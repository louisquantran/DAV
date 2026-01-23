`timescale 1ns / 1ps

module stopwatch(
    input logic clk,
    input logic reset,
    input logic start_watch,
    output logic [$clog2(10000)-1:0] elapsed_time,
    
    //sevenseg display
    output logic [3:0] an,
    output logic [6:0] seg
);
    logic clk_1khz;
    logic clk_1khz_en;
    logic clk_sevenseg;
    
    clock_divider u_clock (
        .clk(clk),
        .reset(reset),
        .clk_1khz(clk_1khz),
        .clk_sevenseg(clk_sevenseg)
    );
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_1khz_en <= 1'b0;
            elapsed_time <= '0;
        end else begin
            if (start_watch) begin
                if (clk_1khz && !clk_1khz_en) begin
                    clk_1khz_en <= 1'b1;
                    elapsed_time <= elapsed_time + 1;
                end else if (!clk_1khz && clk_1khz_en) begin
                    clk_1khz_en <= 1'b0;
                end
            end
        end
    end
    
    logic [3:0] digits[0:3];
    
    binary_to_digits u_btd (
        .binary_in(elapsed_time),
        .digits(digits)
    );
    
    logic [6:0] display_bits[0:3];
    
    digit_to_ssd u_ones(
        .digit(digits[0]),
        .display_bits(display_bits[0]) 
    );
    
    digit_to_ssd u_tens(
        .digit(digits[1]),
        .display_bits(display_bits[1]) 
    );
    
    digit_to_ssd u_hundreds(
        .digit(digits[2]),
        .display_bits(display_bits[2]) 
    );
    
    digit_to_ssd u_thousands(
        .digit(digits[3]),
        .display_bits(display_bits[3]) 
    );
    
    basys_ssd u_ssd (
        .clk(clk),
        .clk_sevenseg(clk_sevenseg),
        .reset(reset),
        .ssd_in(display_bits),
        .an(an),
        .seg(seg)
    );
    
endmodule
