/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
`define IDLE   0                  // pci target controller for memory access
`define R_MEM  1                               // define states
`define W_MEM  2
module pci_target_mem (clk,rstn,framen,cben,ad,irdyn,trdyn,devseln,
                       mem_read_write,mem_ready,mem_addr,mem_data_write,
                       mem_data_read,state);
    input  [31:0] mem_data_read;               // data from memory
    input   [3:0] cben;                        // command/byte enable
    input         clk;                         // clock
    input         rstn;                        // reset
    input         framen;                      // frame
    input         irdyn;                       // initiator ready
    input         mem_ready;                   // memory ready
    inout  [31:0] ad;                          // bi-directional addr/data
    output [31:0] mem_addr;                    // memory address
    output [31:0] mem_data_write;              // data to memory
    output  [1:0] state;                       // state of controller
    output        trdyn;                       // target ready
    output        devseln;                     // device select
    output        mem_read_write;              // memory read(1) / write(0)
    reg    [31:0] mem_addr;                    // memory address
    reg     [1:0] state;                       // state for memory access
    reg           pre_framen;                  // for detecting falling edge
    always @ (posedge clk) begin
        pre_framen <= framen;
    end
    // state transition
    reg     [1:0] next_state = `IDLE;          // next state
    reg    [31:0] auto_addr  = 0;              // address for burst mode
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            next_state <= `IDLE;
            auto_addr  <= 0;
        end else begin
            if (!framen && pre_framen) begin   // start transaction
                if (ad[31:16] == 16'hffff) begin
                    case (cben)
                        4'b0110: begin next_state <= `R_MEM;
                                       auto_addr  <= ad;    end
                        4'b0111: begin next_state <= `W_MEM;
                                       auto_addr  <= ad;    end
                        default: begin next_state <= `IDLE;
                                       auto_addr  <=  0;    end
                    endcase
                end
            end else begin
                case (next_state)
                    `R_MEM: begin
                        if (!irdyn && !trdyn) begin
                            auto_addr <= auto_addr + 4;
                        end else begin
                            if (framen && irdyn) begin
                                next_state <= `IDLE;
                            end
                        end
                    end
                    `W_MEM: begin
                        if (!irdyn && !trdyn) begin
                            auto_addr <= auto_addr + 4;
                        end else begin
                            if (framen && irdyn) begin
                                next_state <= `IDLE;
                            end
                        end
                    end
                endcase
            end
        end
    end
    // memory signals
    wire write = (state == `W_MEM);
    assign mem_read_write = ~(write & ~irdyn & ~trdyn);
    assign mem_data_write = write ? ad : 32'hzzzzzzzz;
    always @(negedge clk) begin
        state    <= next_state;
        mem_addr <= auto_addr;
    end
    // pci output signals
    wire enable = (state == `R_MEM) & !irdyn;
    assign ad = enable ? mem_data_read : 32'hzzzzzzzz;
    assign trdyn = ~mem_ready;
    assign devseln = ~((state != `IDLE) & ~(framen & irdyn));
endmodule
