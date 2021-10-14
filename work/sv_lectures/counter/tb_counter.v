`timescale 1ns/100ps
// Syntaxis: unidad_de_tiempo/precision
// #1 -> 1ns
// #3 -> 3ns
// #0.2 -> 200ps
// #0.04 -> 100ps porque el menor retraso posible es 100ps


module tb_counter;

localparam N_BITS = 3;

// wire -> continous assignments, connecting modules
// assign my_signal = a;

// reg -> procedural assignments
// inside always blocks

// Signals specific to testbench
reg clk_tb;
reg n_reset_tb;
reg up_tb;
wire [N_BITS-1:0] count_tb;
/*
Esta es la declaracion original del counter
input wire clk,
 input wire n_reset,
 input wire up,
 output reg [N_BITS-1:0] count
*/

// Para simular, comenta solo una instanciaon del counter.
// Es decir, para simular la instanciacion tipo 1, comenta las lineas 46 a la 50
// Para simular la instanciacion tipo 2, comenta las lineas 38 a 43
// Ambas simulaciones te deben dar exactamente el mismo resultado

// Instanciacion Tipo 1 - Usar .IO(senal)
counter
dut_counter (.clk(clk_tb),
             .up(up_tb),
             .n_reset(n_reset_tb),
             .count(count_tb)
            );

// Instanciacion Tipo 2 - Posicion
counter
dut_counter (clk_tb,      //1ra pos
             n_reset_tb, //2da
             up_tb,      //3ra
             count_tb);  //4ta

always begin
  clk = 1'b0;
  #5;
  clk = 1'b1;
  #5;
end

initial begin
  n_reset = 1'b1;
  #25; // 25x1ns -> 25ns
  n_reset = 1'b0;
  #10; // 10x1ns -> 10ns
  n_reset = 1'b1;
end

initial begin
  up = 1'b1;
  #50; // 50 unidades -> 50x1ns -> 50ns
  up = 1'b0;
  #40;
  up = 1'b1;
  #0.2
  up = 1'b0;
  #0.04 // This delay can't be simulated
  up = 1'b1;
  $stop;
end

endmodule
