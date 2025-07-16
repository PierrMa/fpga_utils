library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity binaryToGrayConverter_tb is
end binaryToGrayConverter_tb;

architecture Behavioral of binaryToGrayConverter_tb is
signal E: std_logic_vector(3 downto 0):="0000";
signal S: std_logic_vector(3 downto 0);
begin

    --btg_converter: entity work.BinatyToGrayConveter
    gtb_converter: entity work.GrayToBinaryConverter
        port map(E,S);
    
    process
    begin
        for i in 0 to 15 loop
            E <= std_logic_vector(unsigned(E)+1);
            wait for 10ns;
        end loop;
    end process;
end Behavioral;
