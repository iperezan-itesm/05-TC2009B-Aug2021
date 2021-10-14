/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module uart (clk16x,clrn,     // universal asynchronous receiver transmitter
             rdn,d_out,r_ready,rxd,parity_error,frame_error,wrn,d_in,
             t_empty,txd,cnt16x,no_bits_rcvd,r_buffer,r_clk1x,sampling,
             r_data,no_bits_sent,t_buffer,t_clk1x,sending,t_data);
    input         clk16x, clrn;                    // baud rate * 16 clock
    // signals for receiver
    input         rdn;                             // cpu read, active low
    input         rxd;                             // uart rxd
    output  [7:0] d_out;                           // data byte to cpu
    output        r_ready;                         // receiver is ready
    output        parity_error;                    // parity check error
    output        frame_error;                     // data frame error
    // signals for transmitter
    input   [7:0] d_in;                            // data byte from cpu
    input         wrn;                             // cpu write, active low
    output        txd;                             // uart txd
    output        t_empty;                         // transmitter empty
    // for test (internal signals)
    output [10:0] r_buffer;                        // 11-bit frame
    output  [7:0] r_data;                          // received data bits
    output  [7:0] t_buffer;                        // register for sending
    output  [7:0] t_data;                          // register d_in
    output  [3:0] cnt16x;                          // x16 clock counter
    output  [3:0] no_bits_rcvd;                    // # of bits received
    output  [3:0] no_bits_sent;                    // number of bits sent
    output        sampling;                        // sampling an rxd bit
    output        r_clk1x;                         // clock for sampling rxd
    output        sending;                         // sending a txd bit
    output        t_clk1x;                         // clock for sending txd
    reg [3:0] cnt16x;                              // x16 clock counter
    // a 4-bit counter
    always @ (posedge clk16x or negedge clrn) begin
        if (!clrn) begin                           // on reset
            cnt16x <= 4'd0;                        // clear counter
        end else begin
            cnt16x <= cnt16x + 4'd1;               // counter++
        end
    end
    // receiver
    uart_rx recver (clk16x, clrn, rdn, d_out, r_ready, rxd, parity_error, 
                    frame_error, cnt16x, r_data, no_bits_rcvd, r_buffer,
                    r_clk1x, sampling);
    // transmitter
    uart_tx sender (clk16x, clrn, wrn, d_in,  t_empty, txd, cnt16x, 
                    no_bits_sent, t_buffer, t_clk1x, sending, t_data);
endmodule
