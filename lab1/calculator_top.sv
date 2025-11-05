`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 10:42:30 PM
// Design Name: 
// Module Name: calculator_top
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


module calculator_top(
    // seg_driver
    input logic clk,
    output logic [6:0] segBits,
    output logic [3:0] trigger,
    
    // miniALU
    input logic [3:0] op1,
    input logic [3:0] op2, 
    input logic operation,
    input logic sign,
    output logic [19:0] result,
    
    // displayEncoder
    output logic [3:0] numberBits[0:3],
    output logic [6:0] displayBits[0:3]
);
    miniALU alu_dut (
        .op1(op1),
        .op2(op2),
        .operation(operation),
        .sign(sign),
        .result(result)
    );
    
    displayEncoder encoder_dut (
        .result(result),
        .numberBits(numberBits)
    );
    
    sevenSegDigit thousands_dut (
        .digit(numberBits[0]),
        .displayBits(displayBits[0])
    );
    
    sevenSegDigit hundreds_dut (
        .digit(numberBits[1]),
        .displayBits(displayBits[1])
    );
    
    sevenSegDigit tens_dut (
        .digit(numberBits[2]),
        .displayBits(displayBits[2])
    );
    
    sevenSegDigit ones_dut (
        .digit(numberBits[3]),
        .displayBits(displayBits[3])
    );
    
    seg_driver driver_dut (
        .displayBits(displayBits),
        .clk(clk),
        .segBits(segBits),
        .trigger(trigger)
    );
endmodule
