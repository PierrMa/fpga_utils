library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_look_ahead_adder is
generic(N: integer :=4);
Port ( 
    A,B: in std_logic_vector(N-1 downto 0);
    Cin: in std_logic;
    S: out std_logic_vector(N-1 downto 0);
    Cout: out std_logic
);
end carry_look_ahead_adder;

architecture Behavioral of carry_look_ahead_adder is
    signal c_s: std_logic_vector(N downto 0);
begin
    c_s(0) <= Cin;
    cout <= c_s(N);
    
    carry_generator: for i in 1 to N generate
        c_s(i) <= (A(i-1)and B(i-1)) or ((A(i-1)xor B(i-1))and c_s(i-1));
    end generate carry_generator;
    
    adder_generator: for i in 0 to N-1 generate
        full_adder_i: entity work.full_adder
            port map(A(i),B(i),c_s(i),S(i),c_s(i+1));
    end generate adder_generator;

end Behavioral;
