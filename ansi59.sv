// ansi 59 - overvoltage relay
module ansi59 (
    clk,
    rstn,
    sample_en,
    v_in,
    v_pickup,
    hysteresis,
    sample_limit,
    trip
);

import relay_pkg::*;

input logic clk;
input logic rstn;
input logic sample_en;
input logic [ACC_DW-1:0] v_in;
input logic [ACC_DW-1:0] v_pickup;
input logic [ACC_DW-1:0] hysteresis;
input logic [15:0] sample_limit;
output logic trip;

logic [15:0] pickup_counter;
logic pickup;

wire [ACC_DW-1:0] upper_sum = v_pickup + hysteresis;
wire [ACC_DW-1:0] lower_sum = v_pickup - hysteresis;

wire above_limit = v_in > upper_sum;
wire below_limit = v_in < lower_sum;
wire counter_limit = pickup_counter >= sample_limit;

always_ff @(posedge clk)
    if (!rstn) begin
        pickup_counter <= '0;
        pickup <= '0;
    end else if (sample_en) begin
        if (above_limit) begin
            if (!counter_limit) pickup_counter <= pickup_counter + 1'b1;
            pickup <= 1'b1;
        end else if (below_limit) begin
            pickup_counter <= '0;
            pickup <= 1'b0;
        end
    end

assign trip = pickup && counter_limit;

endmodule