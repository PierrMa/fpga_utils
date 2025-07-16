library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronous_DFF is
Port ( 
    D : in std_logic;
    Q : out std_logic;
    clk, rst: in std_logic
);
end synchronous_DFF;

architecture Behavioral of synchronous_DFF is
begin
    process (clk,rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then Q <= '0';
            else Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
