/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module uart_tx (clk16x,clrn,wrn,d_in,t_empty,txd,cnt16x,no_bits_sent,
                t_buffer,clk1x,sending,t_data);    // uart transmitter
    input      [7:0] d_in;                         // data byte from cpu
    input      [3:0] cnt16x;                       // x16 clock counter
    input            clk16x,clrn;                  // baud rate * 16 clock
    input            wrn;                          // cpu write, active low
    output reg       txd;                          // uart txd
    output reg       t_empty;                      // transmitter empty
    output reg [3:0] no_bits_sent;                 // number of bits sent
    output reg [7:0] t_data;                       // reg d_in
    output reg [7:0] t_buffer;                     // reg for sending
    output           clk1x;                        // clock for sending txd
    output reg       sending;                      // sending a txd bit
    reg              load_t_buffer;                // load t_buffer
    // load data to t_data, then to t_buffer, and generate sending signal
    always @ (posedge clk16x or negedge clrn or negedge wrn) begin
        if (!clrn) begin                           // on a reset
            sending       <= 0;                    // clear sending
            t_empty       <= 1;                    // transmitter is ready
            load_t_buffer <= 0;                    // clear load_t_buffer
            t_data        <= 0;                    // clear t_data
            t_buffer      <= 0;                    // clear t_buffer
        end else begin
            if (!wrn) begin                        // cpu write
                t_data  <= d_in;                   // load t_data
                t_empty <= 0;                      // transmitter is busy
                load_t_buffer <= 1;                // ready to load t_buffer
            end else begin
                if (!sending) begin                // not sending
                    if (load_t_buffer) begin       // d2t ready
                        sending <= 1;              // sending please
                        t_buffer <= t_data;        // load t_buffer
                        t_empty <= 1;              // transmitter is ready
                        load_t_buffer <= 0;        // clear load_t_buffer
                    end
                end else begin                     // sending
                    if (no_bits_sent == 4'd11)     // sent a frame
                        sending <= 0;              // clear sending
                end
            end
        end
    end
    // send a frame: [start, d0, d1, ..., d7, parity, stop]
    assign clk1x = cnt16x[3];                      // clock for sending txd
    always @ (posedge clk1x or negedge sending) begin
        if (!sending) begin                        // if not sending
            no_bits_sent <= 4'd0;                  // clear counter
            txd <= 1;                              // stop bits
        end else begin                             // sending
            case (no_bits_sent)                    // sending serially
                0: txd <= 0;                       // sending start bit
                1: txd <= t_buffer[0];             // sending data bit 0
                2: txd <= t_buffer[1];             // sending data bit 1
                3: txd <= t_buffer[2];             // sending data bit 2
                4: txd <= t_buffer[3];             // sending data bit 3
                5: txd <= t_buffer[4];             // sending data bit 4
                6: txd <= t_buffer[5];             // sending data bit 5
                7: txd <= t_buffer[6];             // sending data bit 6
                8: txd <= t_buffer[7];             // sending data bit 7
                9: txd <= ^t_buffer;               // sending parity (even)
                default: txd <= 1;                 // sending stop bit(s)
            endcase
            no_bits_sent <= no_bits_sent + 4'd1;   // counter++
        end
    end
endmodule
