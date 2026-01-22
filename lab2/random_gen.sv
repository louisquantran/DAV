`timescale 1ns / 1ps

module random_gen(
    input logic clk,
    input logic clk_1khz,
    input logic reset,
    
    input logic generate_num,
    output logic [7:0] rand_num,
    output logic generated
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rand_num <= 8'b10000000;
            generated <= 1'b0;
        end else begin
            if (generate_num && !generated) begin
                automatic logic feedback = rand_num[7] ^ rand_num[5] ^ rand_num[4] ^ rand_num[3];
                rand_num <= {rand_num[6:0], feedback};
                generated <= 1'b1;
            end
        end
    end
endmodule
