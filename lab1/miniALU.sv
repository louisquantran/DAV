`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 01:13:48 PM
// Design Name: 
// Module Name: miniALU
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


module miniALU(
    input logic [3:0] op1,
    input logic [3:0] op2,
    input logic operation,
    input logic sign,
    output logic [19:0] result   
);
    always_comb begin 
        if (!operation) begin
            if (!sign) begin
                result = op1 + op2;
            end else begin
                result = op1 - op2;
            end
        end else begin
            if (!sign) begin
                result = op1 << op2;
            end else begin
                result = op1 >> op2;
            end
        end
    end
endmodule
