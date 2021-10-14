/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`define IDLE  0                                   // i2c master controller
`define START 1                                   // define states
`define TX    2
`define RX    3
`define STOP  4
`define WAIT  5
module i2c (clk,clrn,csn,addr,wrn,d_in,rdn,d_out,i2c_sda,i2c_scl);
    input        clk, clrn;                       // system clock, 50MHz
    input        csn;                             // chip select
    input  [1:0] addr;                            // address
    input        wrn;                             // write, active low
    input  [7:0] d_in;                            // data to be sent
    input        rdn;                             // read, active low
    output [7:0] d_out;                           // received data or status
    inout        i2c_sda;                         // i2c sda, input/output
    inout        i2c_scl;                         // i2c scl, input/output
    reg    [2:0] prev_state = `IDLE;              // previous state
    reg    [2:0] curr_state = `IDLE;              // current state
    reg    [2:0] next_state = `IDLE;              // next state
    reg    [2:0] pulse_count = 0;                 // counting i2c_clk cycles
    reg    [3:0] bit_count   = 0;                 // counting number of bits
    reg    [7:0] in_buf;                          // data to be sent
    reg          tx_ack;                          // ack sent be master
    reg    [7:0] out_buf;                         // data received
    reg          rx_ack;                          // ack received
    reg          txd;                             // bit to be sent
    reg          scl_h;                           // high impedance
    reg          sda_h;                           // high impedance
    reg          started;                         // = 0 if stop issued
    // i2c clock
    reg    [4:0] clk_count = 0;                   // clk / 25 = 2MHz
    reg          i2c_clk   = 1;                   // 2MHz
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            clk_count <= 0;
        end else begin
            if  (clk_count == 24) clk_count <= 0;
            else                  clk_count <= clk_count + 5'd1;
            if  (clk_count <= 12) i2c_clk   <= 1;
            else                  i2c_clk   <= 0;
        end
    end
    // pulse_count and bit_count
    always @(posedge i2c_clk) begin
        prev_state <= curr_state;
        if (pulse_count == 4)
            pulse_count <= 0;                     // pulse_count
        else if ((curr_state != `WAIT) || i2c_scl)
            pulse_count <= pulse_count + 3'd1;
        if ((bit_count == 8) && (pulse_count == 4))
            bit_count <= 0;                       // bit_count
        else if ((curr_state == `TX) || (curr_state == `RX)) begin 
            if (pulse_count == 4) bit_count <= bit_count + 4'd1;
        end else bit_count <= 0;
    end
    // next state and data inputs
    always @(posedge clk or negedge clrn) begin
        if (!clrn) begin
            started <= 0;
        end else begin
            case (curr_state)
                `IDLE:  begin
                    if ((!csn) && (!wrn)) begin
                        case (addr)
                            2'd0: begin next_state <= `START; end
                            2'd1: begin next_state <= `TX;
                                        in_buf <= d_in;       end
                            2'd2: begin next_state <= `RX;
                                        tx_ack <= d_in[0];    end
                            2'd3: begin next_state <= `STOP;  end
                        endcase
                    end 
                    if (prev_state == `START) started <= 1;
                end
                `START: begin
                    if (prev_state == `START) begin
                        case (pulse_count)
                            3'd3: if (i2c_scl == 0) next_state <= `WAIT;
                            3'd4: if (i2c_scl == 0) next_state <= `WAIT;
                                  else              next_state <= `IDLE;
                            default: ;
                        endcase
                    end
                end
                `TX: begin
                    if ((bit_count == 8) && (prev_state == `TX)) begin
                        case (pulse_count)
                            3'd3: if (i2c_scl == 0) next_state <= `WAIT;
                            3'd4: if (i2c_scl == 0) next_state <= `WAIT;
                                  else              next_state <= `IDLE;
                            default: ;
                        endcase
                    end
                end
                `RX: begin
                    if ((bit_count == 8) && (prev_state == `RX)) begin
                        case (pulse_count)
                            3'd3: if (i2c_scl == 0) next_state <= `WAIT;
                            3'd4: if (i2c_scl == 0) next_state <= `WAIT;
                                  else              next_state <= `IDLE;
                            default: ;
                        endcase
                    end
                end
                `STOP: begin
                    if ((pulse_count == 4) && (prev_state == `STOP))
                        next_state <= `IDLE;
                    started <= 0;
                end                
                `WAIT: begin
                    if (i2c_scl != 0) next_state <= `IDLE;
                end
            endcase
        end
    end
    // current state
    always @(posedge i2c_clk) begin
        if (pulse_count == 4) curr_state <= next_state;
    end
    // transfer data via i2c bus
    assign i2c_scl = scl_h ? 1'bz : 1'b0;
    assign i2c_sda = sda_h ? 1'bz : 1'b0;
    always @(posedge i2c_clk) begin
        case (curr_state)
            `IDLE: begin
                if (started) begin                // started
                    sda_h <= 0; scl_h <= 0;
                end else begin                    // stopped
                    sda_h <= 1; scl_h <= 1;
                end end
            `START: begin                         // send start bit
                if (started) begin                // send re-start bit
                    case (pulse_count)
                        3'd0: begin scl_h <= 1; sda_h <= 0; end
                        3'd1: begin scl_h <= 1; sda_h <= 1; end
                        3'd2: begin scl_h <= 1; sda_h <= 1; end
                        3'd3: begin scl_h <= 1; sda_h <= 1; end
                        3'd4: begin scl_h <= 1; sda_h <= 0; end
                    endcase
                end else begin                    // send start bit
                    case (pulse_count)
                        3'd0: begin scl_h <= 1; sda_h <= 1; end
                        3'd1: begin scl_h <= 1; sda_h <= 0; end
                        3'd2: begin scl_h <= 1; sda_h <= 0; end
                        3'd3: begin scl_h <= 1; sda_h <= 0; end
                        3'd4: begin scl_h <= 1; sda_h <= 0; end
                    endcase 
                end end
            `TX: begin 
                if (bit_count == 8) begin         // receive ack/nack
                    case (pulse_count)
                        3'd0: begin scl_h <= 0; sda_h <= 1; end
                        3'd1: begin scl_h <= 0; sda_h <= 1; end
                        3'd2: begin scl_h <= 1; sda_h <= 1; end
                        3'd3: begin scl_h <= 1; sda_h <= 1;
                                    rx_ack <= i2c_sda;      end
                        3'd4: begin scl_h <= 0; sda_h <= 1; end
                    endcase
                end else begin                    // send data bit
                    rx_ack <= 1;                  // no ack
                    case (pulse_count)
                        3'd0: begin scl_h <= 0;
                                    sda_h <= in_buf[7-bit_count]; end
                        3'd1: begin scl_h <= 0;
                                    sda_h <= in_buf[7-bit_count]; end
                        3'd2: begin scl_h <= 1;
                                    sda_h <= in_buf[7-bit_count]; end
                        3'd3: begin scl_h <= 1;
                                    sda_h <= in_buf[7-bit_count]; end
                        3'd4: begin scl_h <= 0;
                                    sda_h <= in_buf[7-bit_count]; end
                    endcase
                end end
            `RX: begin 
                if (bit_count == 8) begin         // send ack/nack
                    case (pulse_count)
                        3'd0: begin scl_h <= 0; sda_h <= tx_ack; end
                        3'd1: begin scl_h <= 0; sda_h <= tx_ack; end
                        3'd2: begin scl_h <= 1; sda_h <= tx_ack; end
                        3'd3: begin scl_h <= 1; sda_h <= tx_ack; end
                        3'd4: begin scl_h <= 0; sda_h <= tx_ack; end
                    endcase
                end else begin                    // receive data bit
                    case (pulse_count)
                        3'd0: begin scl_h <= 0; sda_h <= 1;      end
                        3'd1: begin scl_h <= 0; sda_h <= 1;      end
                        3'd2: begin scl_h <= 1; sda_h <= 1;      end
                        3'd3: begin scl_h <= 1; sda_h <= 1;
                                out_buf[7-bit_count] <= i2c_sda; end
                        3'd4: begin scl_h <= 0; sda_h <= 1;      end
                    endcase
                end end
            `STOP: begin                          // send stop bit
                case (pulse_count)
                    3'd0: begin scl_h <= 1; sda_h <= 0; end
                    3'd1: begin scl_h <= 1; sda_h <= 0; end
                    3'd2: begin scl_h <= 1; sda_h <= 1; end
                    3'd3: begin scl_h <= 1; sda_h <= 1; end
                    3'd4: begin scl_h <= 1; sda_h <= 1; end
                endcase end
            `WAIT:        begin scl_h <= 1; sda_h <= 1; end
        endcase
    end
    // read from host
    wire       ready  = (curr_state == `IDLE) && (next_state == `IDLE);
    wire [7:0] status = {2'd0,ready,1'b0,rx_ack,curr_state};
    assign     d_out  = (addr == 0) ? out_buf : status;
endmodule
