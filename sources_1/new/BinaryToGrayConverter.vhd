library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BinaryToGrayConverter is
generic( n: integer := 4);
Port ( 
    E: in std_logic_vector(N-1 downto 0);
    S: out std_logic_vector(N-1 downto 0)
);
end BinatyToGrayConveter;

architecture Behavioral of BinaryToGrayConverter is

begin
output_generator: for i in 0 to N-2 generate
    S(i) <= E(i) xor E(i+1);
end generate output_generator;

S(N-1) <= E(N-1);
end Behavioral;
