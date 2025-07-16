library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flip_flop_tb is
end d_flip_flop_tb;

architecture Behavioral of d_flip_flop_tb is
signal D,Q,rst: std_logic;
signal clk: std_logic := '1';
begin

    my_FF : entity work.d_flip_flop
    --my_FF : entity work.synchronous_DFF
        port map(D,Q,clk,rst);

    clk <= not(clk) after 5ns;
    rst <= '0' after 0ns, '1' after 15ns, '0' after 30ns;
    D <= '1' after 0ns, '0' after 30ns, '1' after 40ns, '0' after 50ns;
end Behavioral;
