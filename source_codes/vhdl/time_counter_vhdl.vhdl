--------------------------------------------------
--  The VHDL code example is from the book
--  Computer Principles and Design in Verilog HDL
--  by Yamin Li, published by A JOHN WILEY & SONS
--------------------------------------------------
LIBRARY IEEE;                                           -- a counter example
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY time_counter_vhdl IS
  PORT (clk        : IN  STD_LOGIC;                     -- input,  1 bit
        enable     : IN  STD_LOGIC;                     -- input,  1 bit
        my_counter : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)  -- output, 4 bits
  );
END time_counter_vhdl;
ARCHITECTURE a_counter OF time_counter_vhdl IS
  SIGNAL cnt : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000"; -- initialize cnt
BEGIN
  my_counter <= cnt;                                    -- assign to output
  PROCESS (clk) BEGIN
    IF (clk'EVENT AND clk = '1') THEN                   -- positive edge
      IF (enable = '1') THEN                            -- if (enable == 1)
        cnt <= cnt + '1';                               --     cnt++
      END IF;
    END IF;
  END PROCESS;
END a_counter;
