package relay_pkg;

// DATA WIDTHS MUST BE BYTE ALIGNED
localparam int BUFFER_SIZE = 64;
localparam int INDEX_SIZE = $clog2(BUFFER_SIZE);
localparam int ADC_DW = 16;
localparam int ADC_OFFSET = 2**(ADC_DW-1);
localparam int B_FACTOR = 10;
localparam int R64 = int'(((1.0 - 2.0**(-B_FACTOR))**64) * 2**ADC_DW);
localparam int ACC_DW = 24;
localparam int MAG_DW = 2*ACC_DW;

typedef enum logic [2:0] {
    SDFT_IDLE,
    SDFT_DELTA,
    SDFT_TRIG,
    SDFT_SHIFT,
    SDFT_UPDATE,
    SDFT_MAGNITUDE,
    SDFT_DONE
} msdft_states;

endpackage