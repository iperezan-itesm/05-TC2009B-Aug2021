--------------------------------------------------
--  The VHDL code example is from the book
--  Computer Principles and Design in Verilog HDL
--  by Yamin Li, published by A JOHN WILEY & SONS
--------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY time_counter_vhdl_tb IS
END    time_counter_vhdl_tb;
ARCHITECTURE behavior OF time_counter_vhdl_tb IS
  SIGNAL clk        : STD_LOGIC := '1';
  SIGNAL enable     : STD_LOGIC := '0';
  SIGNAL my_counter : STD_LOGIC_VECTOR (3 DOWNTO 0);
  COMPONENT time_counter_vhdl PORT (
    clk         : IN  STD_LOGIC;
    enable      : IN  STD_LOGIC;
    my_counter  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
  END COMPONENT;
BEGIN
  uut: time_counter_vhdl PORT MAP (
    clk        => clk,
    enable     => enable,
    my_counter => my_counter
  );
  clk_process: PROCESS BEGIN
    wait for 1 ns; clk <= '0';
    wait for 1 ns; clk <= '1';
  END PROCESS;
  stim_process: PROCESS BEGIN
    wait for 3 ns; enable <= '1';
    wait for 8 ns; enable <= '0';
    wait for 2 ns; enable <= '1';
    wait;
  END PROCESS;
END behavior;
