`timescale 1ns / 1ps

module clock_divider(
    input logic clk,
    input logic reset,
    output logic clk_1khz,
    output logic clk_sevenseg,
    output logic clk_1hz
);
    logic [16:0] ctr_1khz;
    logic [17:0] ctr_sevenseg;
    logic [31:0] ctr_1hz;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_1khz <= 1'b1;
            ctr_1khz <= '0;
            
            clk_1hz <= 1'b1;
            ctr_1hz <= '0;
            
            clk_sevenseg <= 1'b1;
            ctr_sevenseg <= '0;
        end else begin
            ctr_1hz <= ctr_1hz + 1;
            ctr_1khz <= ctr_1khz + 1;
            ctr_sevenseg <= ctr_sevenseg + 1;
            
            // clk_1hz
            if (ctr_1hz == 50000000) begin
                clk_1khz <= 1'b0;
            end else if (ctr_1hz == 100000000) begin
                ctr_1hz <= '0;
                clk_1hz <= 1'b1;
            end
            
            // clk_1khz
            if (ctr_1khz == 50000) begin
                clk_1khz <= 1'b0;
            end else if (ctr_1khz == 100000) begin
                ctr_1khz <= '0;
                clk_1khz <= 1'b1;
            end
            
            // clk_500hz
            if (ctr_sevenseg == 100000) begin
                clk_sevenseg <= 1'b0;
            end else if (ctr_sevenseg == 200000) begin
                clk_sevenseg <= 1'b1;
                ctr_sevenseg <= '0;
            end
        end
    end
endmodule
