library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_shift_reg_tb is
end universal_shift_reg_tb;

architecture Behavioral of universal_shift_reg_tb is
constant N : integer :=4;
signal serial_left : std_logic;
signal serial_right :  std_logic;
signal paralel : std_logic_vector(N-1 downto 0);
signal q: std_logic_vector(N-1 downto 0);
signal clk,rst: std_logic :='1';
signal sel: std_logic_vector(1 downto 0);

begin

    dut : entity work.universal_shift_reg
    generic map(N)
    port map(
        serial_left => serial_left,
        serial_right =>serial_right,
        paralel => paralel,
        q => q,
        clk =>clk,
        rst =>rst,
        sel => sel);
        
   clk <= not(clk) after 5ns;
   rst <= '0' after 10ns;
   sel <= "00" after 0ns, "01" after 10ns, "10" after 50ns, "11" after 90ns, "01" after 100ns, "00" after 110ns;
   serial_left <= '1' after 0ns;
   serial_right <= '0' after 0ns;
   paralel <= "1010";
            
end Behavioral;
