library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR_tb is
end LFSR_tb;

architecture Behavioral of LFSR_tb is
constant N : integer := 4;
signal reg_val: std_logic_vector(N-1 downto 0);
signal s : std_logic;
signal clk : std_logic := '1';
signal rst : std_logic;

begin

    dut: entity work.LFSR
    port map(reg_val=>reg_val,s=>s,clk=>clk,rst=>rst);

    clk <= not(clk) after 5ns;
    rst <= '1' after 0ns, '0' after 10ns;
end Behavioral;
