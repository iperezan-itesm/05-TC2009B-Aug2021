/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module uart_rx (clk16x,clrn,rdn,d_out,r_ready,rxd,parity_error,
                frame_error,cnt16x,r_data,no_bits_rcvd,r_buffer,
                clk1x,sampling);                   // uart receiver
    input       [3:0] cnt16x;                      // x16 clock counter
    input             clk16x,clrn;                 // baud rate * 16 clock
    input             rdn;                         // cpu read, active low
    input             rxd;                         // uart rxd
    output      [7:0] d_out;                       // data byte to cpu
    output reg        r_ready;                     // receiver is ready
    output reg        parity_error;                // parity check error
    output reg        frame_error;                 // data frame error
    output reg [10:0] r_buffer;                    // 11-bit frame
    output reg  [7:0] r_data;                      // received data bits
    output reg  [3:0] no_bits_rcvd;                // # of bits received
    output reg        clk1x;                       // clock for sampling rxd
    output reg        sampling;                    // sampling an rxd bit
    reg         [3:0] sampling_place;              // center of an rxd bit
    reg               rxd_new;                     // registered rxd
    reg               rxd_old;                     // registered rxd_new
    // latch 2 rxd bits for detecting a falling edge
    always @ (posedge clk16x or negedge clrn) begin
        if (!clrn) begin
            rxd_old <= 1;                          // stop bits
            rxd_new <= 1;                          // stop bits
        end else begin
            rxd_old <= rxd_new;                    // shift registers
            rxd_new <= rxd;                        // shift registers
        end
    end
    // detect start bit and generate sampling signal
    always @ (posedge clk16x or negedge clrn) begin
        if (!clrn) begin
            sampling <= 0;                         // stop sampling
        end else begin
            if (rxd_old && !rxd_new) begin         // had a negative edge
                if (!sampling)                     // if not sampling yet
                  sampling_place <= cnt16x + 4'd8; // +8: center place
                sampling <= 1;                     // sampling please
            end else begin
                if (no_bits_rcvd == 4'd11)         // got one frame
                  sampling <= 0;                   // stop sampling
            end
        end
    end
    // sampling clock: clk1x
    always @ (posedge clk16x or negedge clrn) begin
        if (!clrn) begin
            clk1x <= 0;
        end else begin
            if (sampling) begin                    // if sampling
                if (cnt16x == sampling_place)      // at the center place
                  clk1x <= 1;                      // generate a pos edge
                if (cnt16x == sampling_place + 4'd1)
                  clk1x <= 0;                      // one x16 cycle pulse
            end else clk1x <= 0;                   // stop clk1x
        end
    end
    // number of bits received
    always @ (posedge clk1x or negedge sampling) begin
        if (!sampling) begin
            no_bits_rcvd <= 4'd0;                  // clear counter
        end else begin
            no_bits_rcvd <= no_bits_rcvd + 4'd1;   // counter++
            r_buffer[no_bits_rcvd] <= rxd;         // save rxd to r_buffer
        end
    end
    // one frame, rdn clears r_ready
    always @ (posedge clk16x or negedge clrn or negedge rdn) begin
        if (!clrn) begin                           // on a reset
            r_ready <= 0;                          // clear ready
            parity_error <= 0;                     // clear parity error
            frame_error  <= 0;                     // clear frame error
            r_buffer     <= 0;                     // clear r_buffer
            r_data       <= 0;                     // clear r_data
        end else begin
            if (!rdn) begin                        // on a read
                r_ready      <= 0;                 // clear ready
                parity_error <= 0;                 // clear parity error
                frame_error  <= 0;                 // clear frame error
            end else begin
                if (no_bits_rcvd == 4'd11) begin   // got a frame
                    r_data <= r_buffer[8:1];       // extract data byte
                    r_ready <= 1;                  // receiver ready
                    if (^r_buffer[9:1]) begin      // parity check (even)
                        parity_error <= 1;         // parity error
                    end
                    if (!r_buffer[10]) begin       // if no stop bit
                        frame_error <= 1;          // frame error
                    end
                end
            end
        end
    end
    assign d_out = !rdn ? r_data : 8'hz;           // data byte output
endmodule
