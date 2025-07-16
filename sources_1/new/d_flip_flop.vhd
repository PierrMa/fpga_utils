library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flip_flop is
Port ( 
    D : in std_logic;
    Q : out std_logic;
    clk, rst: in std_logic
);
end d_flip_flop;

architecture Behavioral of d_flip_flop is

begin

    process (clk,rst)
    begin
        if rst = '1' then Q <= '0';
        elsif rising_edge(clk) then Q <= D;
        end if;
    end process;
end Behavioral;
