library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

entity muxNv1_tb is
end muxNv1_tb;

architecture Behavioral of muxNv1_tb is
constant N : integer := 4;
signal E : std_logic_vector(N-1 downto 0);
signal S : std_logic;
signal sel : std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
begin

    dut : entity work.muxNv1
    generic map(N)
    port map(E,S,sel);
    
    E <= "1010";
    sel <= "00" after 0ns, "01" after 10ns, "10" after 20ns, "11" after 30ns;
    
end Behavioral;
