library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nbits_ripple_adder_tb is
--  Port ( );
end nbits_ripple_adder_tb;

architecture Behavioral of nbits_ripple_adder_tb is
signal a,b: std_logic_vector(3 downto 0);
signal cin: std_logic := '0';
signal s: std_logic_vector(3 downto 0);
signal cout: std_logic;
begin
    --ripple_adder: entity work.nbits_ripple_adder
    cla_adder: entity work.carry_look_ahead_adder
    generic map(N=>4)
    port map(a,b,cin,s,cout);
    
    a <= "1111" after 0ns, "0000" after 10ns, "0010" after 20ns, "0100" after 30ns, "1000" after 40ns;
    b <= "0000" after 0ns, "1111" after 10ns;
    cin <= not(cin) after 10ns;

end Behavioral;
