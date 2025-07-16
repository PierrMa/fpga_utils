library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SR_FF is
Port (
    S,R : in std_logic;
    clk,rst: in std_logic;
    Q,Q_barre : out std_logic
 );
end SR_FF;

architecture Behavioral of SR_FF is

begin

    process(clk,rst)
    begin
        if rst = '1' then Q <= '0'; Q_barre <= '1';
        elsif rising_edge(clk) then 
            if S = '1' and R = '0' then Q <= S; Q_barre <= not(S);
            elsif R = '1' and S = '0' then Q <= not(R); Q_barre <= R;
            elsif R = '1' and S = '1' then Q <= 'X'; Q_barre <= 'X';
            end if;
        end if;
    end process;
end Behavioral;
