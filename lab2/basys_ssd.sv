`timescale 1ns / 1ps

module basys_ssd(
    input logic clk,
    input logic clk_sevenseg,
    input logic reset,
    input logic [6:0] ssd_in [0:3],
    output logic [3:0] an,
    output logic [6:0] seg
);
    logic [1:0] ctr;
    logic clk_sevenseg_en;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_sevenseg_en <= 1'b0;
            an <= '0;
            seg <= '0;
            ctr <= '0;
        end else begin
            if (clk_sevenseg && !clk_sevenseg_en) begin
                clk_sevenseg_en <= 1'b1;
                case (ctr) 
                    2'b00: begin
                        an <= 4'b1110;
                        seg <= ssd_in[0]; 
                    end
                    2'b01: begin
                        an <= 4'b1101;
                        seg <= ssd_in[1];
                    end
                    2'b10: begin
                        an <= 4'b1011;
                        seg <= ssd_in[2];
                    end
                    2'b11: begin
                        an <= 4'b0111;
                        seg <= ssd_in[3];
                    end
                    default: begin
                        an <= 4'b1111;
                        seg <= '1;
                    end
                endcase
                if (ctr == 2'b11) begin
                    ctr <= '0;
                end else begin
                    ctr <= ctr + 1;
                end
            end else if (!clk_sevenseg && clk_sevenseg_en) begin 
                clk_sevenseg_en <= 1'b0; 
            end
        end
    end
endmodule
