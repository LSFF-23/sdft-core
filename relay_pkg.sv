package relay_pkg;

// DATA WIDTHS MUST BE BYTE ALIGNED
localparam int BUFFER_SIZE = 64;
localparam int INDEX_SIZE = $clog2(BUFFER_SIZE);
localparam int ADC_DW = 16;
localparam int ADC_OFFSET = 2**(ADC_DW-1);
localparam int ACC_DW = 24;
localparam int MAG_DW = 2*ACC_DW;

localparam int FUNDAMENTAL_F = 60; // in Hz
localparam int SAMPLING_F = FUNDAMENTAL_F * BUFFER_SIZE;
localparam real A59_INTERVAL = 0.5; // in s
localparam int A59_TIMEOUT = int'(A59_INTERVAL * SAMPLING_F);
// test-only values, must be calibrated according to adc output
localparam int A59_NOMINAL = 4096 * BUFFER_SIZE / 2;
localparam int A59_PICKUP = int'(A59_NOMINAL * 1.2);
localparam int A59_HYSTERESIS = int'(A59_PICKUP * 0.02);

localparam int MAIN_CLK = 50_000_000;
localparam int DIVIDER_FACTOR = MAIN_CLK / SAMPLING_F;
localparam int DIVIDER_SIZE = $clog2(DIVIDER_FACTOR);

typedef enum logic [3:0] {
    SDFT_IDLE,
    SDFT_DELTA,
    SDFT_TRIG,
    SDFT_SHIFT,
    SDFT_UPDATE,
    SDFT_SQUARE,
    SDFT_SQRT,
    SDFT_MAGNITUDE,
    SDFT_DONE
} msdft_states;

endpackage