library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GrayToBinaryConverter is
generic(N : integer :=4);
Port ( 
    e: in std_logic_vector(N-1 downto 0);
    s: out std_logic_vector(N-1 downto 0)
);
end GrayToBinaryConverter;

architecture Behavioral of GrayToBinaryConverter is
signal s_s : std_logic_vector(N-1 downto 0);
begin

    s_s(N-1) <= e(N-1);
    binary_generator : for i in N-2 downto 0 generate
        s_s(i) <= e(i) xor s_s(i+1);
    end generate binary_generator;
    
    s <= s_s;
end Behavioral;
