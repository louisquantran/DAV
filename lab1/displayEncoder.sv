`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 02:09:44 PM
// Design Name: 
// Module Name: displayEncoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module displayEncoder(
    input logic [19:0] result,
    output logic [3:0] numberBits[0:3]
);
    logic [19:0] temp;
    always_comb begin
        temp = result;
        numberBits[0] = 4'b0;
        numberBits[1] = 4'b0;
        numberBits[2] = 4'b0;
        numberBits[3] = 4'b0;
        if (result > 9999) begin 
            $display("Exceed 9999");
            numberBits[0] = 4'b0;
            numberBits[1] = 4'b0;
            numberBits[2] = 4'b0;
            numberBits[3] = 4'b0;
        end
        else begin 
            numberBits[0] = temp / 1000;
            temp = temp % 1000;
            numberBits[1] = temp / 100;
            temp = temp % 100;
            numberBits[2] = temp / 10;
            temp = temp % 10;
            numberBits[3] = temp;
        end
    end
endmodule
