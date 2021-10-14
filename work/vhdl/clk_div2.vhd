LIBRARY IEEE;                                           -- frequency divider
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_div2 IS
  PORT (clk : IN  STD_LOGIC; -- input,  1 bit
          q : OUT STD_LOGIC  -- output, 1 bit
  );
END clk_div2;

ARCHITECTURE behavioural OF clk_div2 IS
  -- SIGNALS
    SIGNAL qn : STD_LOGIC := '0';
BEGIN
  q <= qn;
  PROCESS (clk) BEGIN
    IF (clk'EVENT AND clk = '1') THEN  -- positive edge
        qn <= not qn;                    -- toggle q
    END IF;
  END PROCESS;
END behavioural;
