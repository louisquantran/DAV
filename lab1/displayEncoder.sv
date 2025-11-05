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
        if (result > 9999) $display("Exceed 9999");
        else begin 
            // There is at least one thousand digit
            if (temp < 20'd1000) numberBits[0] = 4'b0000;
            if (temp >= 20'd1000 && temp <= 20'd2000) begin
                numberBits[0] = 4'b0001;
                temp = temp - 20'd1000;
            end 
            if (temp >= 20'd2000 && temp <= 20'd2999) begin
                numberBits[0] = 4'b0010;
                temp = temp - 20'd2000;
            end 
            if (temp >= 20'd3000 && temp <= 20'd3999) begin
                numberBits[0] = 4'b0011;
                temp = temp - 20'd3000;
            end 
            if (temp >= 20'd4000 && temp <= 20'd4999) begin
                numberBits[0] = 4'b0100;
                temp = temp - 20'd4000;
            end
            if (temp >= 20'd5000 && temp <= 20'd5999) begin
                numberBits[0] = 4'b0101;
                temp = temp - 20'd5000;
            end
            if (temp >= 20'd6000 && temp <= 20'd6999) begin
                numberBits[0] = 4'b0110;
                temp = temp - 20'd6000;
            end
            if (temp >= 20'd7000 && temp <= 20'd7999) begin
                numberBits[0] = 4'b0111;
                temp = temp - 20'd7000;
            end
            if (temp >= 20'd8000 && temp <= 20'd8999) begin
                numberBits[0] = 4'b1000;
                temp = temp - 20'd8000;
            end
            if (temp >= 20'd9000 && temp <= 20'd9999) begin
                numberBits[0] = 4'b1001;
                temp = temp - 20'd9000;
            end
            $display("Thousands: %d ", numberBits[0]); 
            
            // Hundreds
            if (temp < 20'd100) numberBits[1] = 4'b0000;
            if (temp >= 20'd100 && temp <= 20'd200) begin
                numberBits[1] = 4'b0001;
                temp = temp - 20'd100;
            end 
            if (temp >= 20'd200 && temp <= 20'd299) begin
                numberBits[1] = 4'b0010;
                temp = temp - 20'd200;
            end 
            if (temp >= 20'd300 && temp <= 20'd399) begin
                numberBits[1] = 4'b0011;
                temp = temp - 20'd300;
            end 
            if (temp >= 20'd400 && temp <= 20'd499) begin
                numberBits[1] = 4'b0100;
                temp = temp - 20'd400;
            end
            if (temp >= 20'd500 && temp <= 20'd599) begin
                numberBits[1] = 4'b0101;
                temp = temp - 20'd500;
            end
            if (temp >= 20'd600 && temp <= 20'd699) begin
                numberBits[1] = 4'b0110;
                temp = temp - 20'd600;
            end
            if (temp >= 20'd700 && temp <= 20'd799) begin
                numberBits[1] = 4'b0111;
                temp = temp - 20'd700;
            end
            if (temp >= 20'd800 && temp <= 20'd899) begin
                numberBits[1] = 4'b1000;
                temp = temp - 20'd800;
            end
            if (temp >= 20'd900 && temp <= 20'd999) begin
                numberBits[1] = 4'b1001;
                temp = temp - 20'd900;
            end
            $display("Hundreds: %d ", numberBits[1]); 
            
            // tenth
            if (temp < 20'd10) numberBits[2] = 4'b0000;
            if (temp >= 20'd10 && temp <= 20'd19) begin
                numberBits[2] = 4'b0001;
                temp = temp - 20'd10;
            end 
            if (temp >= 20'd20 && temp <= 20'd29) begin
                numberBits[2] = 4'b0010;
                temp = temp - 20'd20;
            end 
            if (temp >= 20'd30 && temp <= 20'd39) begin
                numberBits[2] = 4'b0011;
                temp = temp - 20'd30;
            end 
            if (temp >= 20'd40 && temp <= 20'd49) begin
                numberBits[2] = 4'b0100;
                temp = temp - 20'd40;
            end
            if (temp >= 20'd50 && temp <= 20'd59) begin
                numberBits[2] = 4'b0101;
                temp = temp - 20'd50;
            end
            if (temp >= 20'd60 && temp <= 20'd69) begin
                numberBits[2] = 4'b0110;
                temp = temp - 20'd60;
            end
            if (temp >= 20'd70 && temp <= 20'd79) begin
                numberBits[2] = 4'b0111;
                temp = temp - 20'd70;
            end
            if (temp >= 20'd80 && temp <= 20'd89) begin
                numberBits[2] = 4'b1000;
                temp = temp - 20'd80;
            end
            if (temp >= 20'd90 && temp <= 20'd99) begin
                numberBits[2] = 4'b1001;
                temp = temp - 20'd90;
            end
            $display("Tens: %d ", numberBits[2]); 
            
            // Ones
            case (temp)
                20'd1: numberBits[3] = 4'b0001;
                20'd2: numberBits[3] = 4'b0010;
                20'd3: numberBits[3] = 4'b0011;
                20'd4: numberBits[3] = 4'b0100;
                20'd5: numberBits[3] = 4'b0101;
                20'd6: numberBits[3] = 4'b0110;
                20'd7: numberBits[3] = 4'b0111;
                20'd8: numberBits[3] = 4'b1000;
                20'd9: numberBits[3] = 4'b1001;
                default: numberBits[3] = 4'b0000;
            endcase
            $display("Ones: %d ", numberBits[3]); 
        end
    end
endmodule
