library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SR_FF_tb is
end SR_FF_tb;

architecture Behavioral of SR_FF_tb is
signal s,r,rst,q,qb: std_logic;
signal clk : std_logic := '1';
begin
    dut: entity work.SR_FF
    port map(s,r,clk,rst,q,qb);
    
    clk <= not(clk) after 5ns;
    rst <= '1' after 0ns, '0' after 20ns;
    s <= '1' after 0ns, '0' after 10ns, '1' after 20ns, '0' after 30ns, '1' after 40ns, '0' after 50ns;
    r <= '0' after 0ns, '1' after 10ns, '0' after 20ns, '1' after 30ns, '1' after 40ns, '0' after 50ns;
end Behavioral;
