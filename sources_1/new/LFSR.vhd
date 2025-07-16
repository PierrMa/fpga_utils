library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR is
generic( 
    N: integer :=4
);
Port ( 
    reg_val: out std_logic_vector(N-1 downto 0);
    s: out std_logic;
    clk,rst: in std_logic
);
end LFSR;

architecture Behavioral of LFSR is
constant init : std_logic_vector(N-1 downto 0) := "1010";
signal reg_tamp: std_logic_vector(N-1 downto 0);
begin

    process(clk,rst)
    begin
        if rst='1' then reg_tamp <= init;
        elsif rising_edge(clk) then
            reg_tamp <= reg_tamp(N-2 downto 0)&(reg_tamp(3) xor reg_tamp(2));
            s <= reg_tamp(N-1);
        end if;
    end process;
    
    reg_val <= reg_tamp;
end Behavioral;
