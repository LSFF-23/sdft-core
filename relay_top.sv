module relay_top (
    clk,
    rstn,
    adc_vin,
    trip
);

import relay_pkg::*;

input logic clk;
input logic rstn;
input logic [ADC_DW-1:0] adc_vin;
output logic trip;

// future memory mapped registers
logic [ACC_DW-1:0] a59_pickup;
logic [ACC_DW-1:0] a59_hysteresis;
logic [15:0] a59_limit;

logic sample_en, sdft_valid;
logic [ACC_DW-1:0] sdft_out;

clk_divider u_clk_divider (
    .clk(clk),
    .rstn(rstn),
    .sample_en(sample_en)
);

sdft u_sdft (
    .clk(clk),
    .rstn(rstn),
    .sample_en(sample_en),
    .sample(adc_vin),
    .out(sdft_out),
    .valid(sdft_valid)
);

ansi59 u_ansi59 (
    .clk(clk),
    .rstn(rstn),
    .sample_en(sdft_valid),
    .v_in(sdft_out),
    .v_pickup(a59_pickup),
    .hysteresis(a59_hysteresis),
    .sample_limit(a59_limit),
    .trip(trip)
);

// REMINDER DO ADJUST LATER
always_ff @(posedge clk) begin
    a59_pickup <= ACC_DW'(A59_PICKUP);
    a59_hysteresis <= ACC_DW'(A59_HYSTERESIS);
    a59_limit <= 16'(10);
end

endmodule