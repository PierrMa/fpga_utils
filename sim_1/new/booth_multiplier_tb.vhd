library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_multiplier_tb is
end booth_multiplier_tb;

architecture Behavioral of booth_multiplier_tb is
constant N: integer := 4;
signal a,b: std_logic_vector(N-1 downto 0);
signal s: std_logic_vector(2*N-1 downto 0);
signal clk : std_logic :='1';
signal rst,start: std_logic;
begin

    my_multiplier: entity work.booth_multiplier
    generic map(N)
    port map(a=>a,
            b=>b,
            s=>s,
            clk=>clk,
            rst=>rst,
            start=>start);
    
    start <= '1' after 0ns;
    rst <= '1' after 0ns, '0' after 15ns;
    clk <= not(clk) after 5ns;
    a <= "1111" after 0ns, "0111" after 175ns, "0101" after 335ns, "1111" after 495ns, "0000" after 655ns;
    b <= "0001" after 0ns, "0101" after 175ns, "0101" after 335ns, "1111" after 495ns, "0000" after 655ns;
end Behavioral;
