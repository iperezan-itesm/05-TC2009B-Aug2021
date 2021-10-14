LIBRARY IEEE;                                           -- frequency divider
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_div4 IS
  PORT (clk : IN  STD_LOGIC; -- input,  1 bit
          q : OUT STD_LOGIC  -- output, 1 bit
  );
END clk_div4;

ARCHITECTURE structural OF clk_div4 IS
  -- SIGNALS
  SIGNAL clk2 : STD_LOGIC;

  COMPONENT clk_div2
  PORT (clk : IN  STD_LOGIC; -- input,  1 bit
          q : OUT STD_LOGIC  -- output, 1 bit
  );
  END COMPONENT;

  BEGIN
    -- instance 0 of clk_div2
    u_clk_div2: clk_div2 PORT MAP (clk => clk,
                                   q   => clk2
                                  );
    -- instance 1 of clk_div2                              
    u_clk_div4: clk_div2 PORT MAP (clk => clk2,
                                   q   => q
                                  );

  END structural;
