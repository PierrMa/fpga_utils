library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
-- Port ( );
end full_adder_tb;

architecture Behavioral of full_adder_tb is
signal a,b,cin,s,cout: std_logic;
begin
    full_adder_rtl: entity work.full_adder
    port map(a,b,cin,s,cout);
    
    b   <= '0' after 0ns, '1' after 10ns, '0' after 20ns, '1' after 30ns, '0' after 40ns, '1' after 50ns, '0' after 60ns, '1' after 70ns;
    a   <= '0' after 0ns, '0' after 10ns, '1' after 20ns, '1' after 30ns, '0' after 40ns, '0' after 50ns, '1' after 60ns, '1' after 70ns;
    cin <= '0' after 0ns, '0' after 10ns, '0' after 20ns, '0' after 30ns, '1' after 40ns, '1' after 50ns, '1' after 60ns, '1' after 70ns;
end Behavioral;
