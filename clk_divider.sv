module clk_divider (
    clk,
    rstn,
    sample_en
);

import relay_pkg::*;

input logic clk;
input logic rstn;
output logic sample_en;

logic [DIVIDER_SIZE-1:0] counter;

always_ff @(posedge clk)
    if (!rstn) begin
        sample_en <= '0;
        counter <= '0;
    end else
        if (counter == DIVIDER_FACTOR - 1) begin
            sample_en <= 1'b1;
            counter <= '0;
        end else begin
            sample_en <= 1'b0;
            counter <= counter + 1'b1;
        end

endmodule