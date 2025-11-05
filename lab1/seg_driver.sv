//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 11:49:51 AM
// Design Name: 
// Module Name: seg_driver
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


module seg_driver(
    input logic [6:0] displayBits [3:0],
    input clk,
    output logic [3:0] trigger,
    output logic [6:0] segBits 
    );
    logic [1:0] counter;
    logic [15:0] clkdiv;
    logic slow_clk = clkdiv[15]; 

    always @(posedge clk) begin
    clkdiv <= clkdiv + 1;
    end

    
    always @(posedge slow_clk) begin
        case (counter)
        0: begin
        segBits <= displayBits[0];
        trigger <= 4'b1110;
        end
        1: begin
        segBits <= displayBits[1];
        trigger <= 4'b1101;
        end
        2: begin
        segBits <= displayBits[2];
        trigger <= 4'b1011;
        end
        3: begin
        segBits <= displayBits[3];
        trigger <= 4'b0111;
        end
        endcase
        
        if (counter == 3) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
        
endmodule
