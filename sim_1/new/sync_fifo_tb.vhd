library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync_fifo_tb is
end sync_fifo_tb;

architecture Behavioral of sync_fifo_tb is
constant width : integer := 4;
constant depth : integer := 10;
signal e,s : std_logic_vector(width-1 downto 0);
signal clk : std_logic := '1';
signal rst, RdWrn : std_logic;

begin

    dut : entity work.sync_fifo
    generic map(width,depth)
    port map(clk,rst,e,s,RdWrn);

    clk <= not(clk) after 5ns;
    rst <= '1' after 0ns, '0' after 10ns;
    e <= "1111" after 0ns, "1110" after 20ns, "1100" after 30ns, "1000" after 40ns, "0000" after 50ns, "0001" after 60ns, "0011" after 70ns, "0111" after 80ns, "1111" after 90ns, "1011" after 100ns, "1010" after 110ns,"0101" after 120ns, "1001" after 130ns;
    RdWrn <= '0' after 0ns, '1' after 110ns;
end Behavioral;
