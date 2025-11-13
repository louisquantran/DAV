`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 09:12:19 PM
// Design Name: 
// Module Name: miniALU_tb
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


module miniALU_tb(
    );
    logic [3:0] op1;
    logic [3:0] op2;
    logic operation;
    logic sign;
    logic [19:0] result;
    
    miniALU DUT (.op1(op1), .op2(op2), .operation(operation),
    .sign(sign), .result(result));
    
    initial begin
    op1 = 4'd7;
    op2 = 4'd5;
    operation = 0;
    sign = 0;
    #20;
    operation = 0;
    sign = 1;
    #20;
    operation = 1;
    sign = 0;
    #20;
    operation = 1;
    sign = 1;
    #20;
    $finish;
    end
    
    initial begin 
        $monitor("Time=%0t op1=%d op2=%d operation=%b sign=%b result=%d",
                  $time, op1, op2, operation, sign, result);
    end 
    
    
    
endmodule
