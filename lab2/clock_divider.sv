`timescale 1ns / 1ps

module clock_divider(
    input logic clk,
    input logic reset,
    output logic clk_1khz,
    output logic clk_sevenseg,
    output logic clk_500hz
);
    assign clk_500hz = clk_sevenseg;
    logic [16:0] ctr_1khz;
    logic [17:0] ctr_sevenseg;
    int ctr_50hz;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_1khz <= 1'b1;
            ctr_1khz <= '0;
            
//            clk_50hz <= 1'b1;
//            ctr_50hz <= '0;
            
            clk_sevenseg <= 1'b1;
            ctr_sevenseg <= '0;
        end else begin
            ctr_1khz <= ctr_1khz + 1;
            ctr_sevenseg <= ctr_sevenseg + 1;
//            ctr_50hz <= ctr_50hz + 1;
            
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
