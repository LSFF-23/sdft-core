package relay_pkg;

// DATA WIDTHS MUST BE BYTE ALIGNED
localparam int BUFFER_SIZE = 64;
localparam int INDEX_SIZE = $clog2(BUFFER_SIZE);
localparam int ADC_DW = 16;
localparam int ADC_OFFSET = 2**(ADC_DW-1);
localparam int ACC_DW = 24;
localparam int MAG_DW = 2*ACC_DW;

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