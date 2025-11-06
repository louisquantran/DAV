module miniALU(
    input logic [3:0] op1,
    input logic [3:0] op2,
    input logic operation,
    input logic sign,
    output logic [19:0] result
);

    always_comb begin
        if (!operation && !sign) begin
            result = op1 + op2;
        end else if (!operation && sign) begin
            result = op1 - op2;
        end else if (operation && !sign) begin
            result = op1 << op2;
        end else if (operation && sign) begin
            result = op1 >> op2;
        end else begin
            result = 20'b0;
        end
    end

endmodule