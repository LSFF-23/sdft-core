// fsm implementation: new non-restoring square-root (Li & Chu, 1996)
module nnr_sqrt #
(
    parameter int IN_SIZE = 8
)
(
    clk,
    rstn,
    sample_en,
    D_in,
    Q_out,
    valid
);

localparam int OUT_SIZE = IN_SIZE / 2;
localparam int I_SIZE = $clog2(OUT_SIZE);

input logic clk;
input logic rstn;
input logic sample_en;
input logic [IN_SIZE-1:0] D_in;
output logic [OUT_SIZE-1:0] Q_out;
output logic valid;

logic [IN_SIZE-1:0] D;
logic [OUT_SIZE-1:0] Q;
logic [OUT_SIZE+1:0] R;
logic [I_SIZE-1:0] i;

enum logic [1:0] {
    IDLE, FOREACH, DONE
} state, next_state;

always_ff @(posedge clk)
    if (!rstn)
        state <= IDLE;
    else
        state <= next_state;

always_comb begin
    next_state = state;
    case (state)
        IDLE: if (sample_en) next_state = FOREACH;
        FOREACH: if (i == '0) next_state = DONE;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

wire signed [OUT_SIZE+3:0] Rs2 = $signed(R) <<< 2;
wire [OUT_SIZE+1:0] common_R = Rs2[OUT_SIZE+1:0] | D[i + i + 1 -: 2];
wire [OUT_SIZE+1:0] Q01 = (Q << 2) | 1;
wire [OUT_SIZE+1:0] Q11 = (Q << 2) | 3;
wire [OUT_SIZE+1:0] pos_R = $unsigned($signed(common_R) - $signed(Q01));
wire [OUT_SIZE+1:0] neg_R = $unsigned($signed(common_R) + $signed(Q11));
wire [OUT_SIZE-1:0] neg_Q = (Q << 1) | 0;
wire [OUT_SIZE-1:0] pos_Q = (Q << 1) | 1;

always_ff @(posedge clk)
    if (!rstn) begin
        D <= '0;
        Q <= '0;
        R <= '0;
        i <= OUT_SIZE - 1;
    end else begin
        case (state)
            IDLE: begin
                if (sample_en) begin
                    i <= OUT_SIZE - 1;
                    D <= D_in;
                    Q <= '0;
                    R <= '0;
                end
            end
            FOREACH: begin
                i <= i - 1'b1;
                if (R[OUT_SIZE+1]) begin
                    R <= neg_R;
                    Q <= neg_R[OUT_SIZE+1] ? neg_Q : pos_Q;
                end else begin
                    R <= pos_R;
                    Q <= pos_R[OUT_SIZE+1] ? neg_Q : pos_Q;
                end
            end
            DONE: begin // remainder ignored
                i <= '0;
            end
        endcase
    end

assign valid = state == DONE;
assign Q_out = Q;

endmodule