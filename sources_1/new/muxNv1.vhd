library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity muxNv1 is
generic (N : integer := 4);
Port ( 
    E : in std_logic_vector(N-1 downto 0);
    S : out std_logic;
    sel: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0)
);
end muxNv1;

architecture Behavioral of muxNv1 is
begin
S <= E(to_integer(unsigned(sel)));
end Behavioral;
