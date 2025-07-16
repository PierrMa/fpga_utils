library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nbits_ripple_adder is
generic(N : integer := 4);
Port ( 
    a,b : in std_logic_vector(N-1 downto 0);
    cin: in std_logic;
    s : out std_logic_vector(N-1 downto 0);
    cout: out std_logic
);
end nbits_ripple_adder;

architecture Behavioral of nbits_ripple_adder is
signal c_s : std_logic_vector(N downto 0);
begin
c_s(0) <= cin;
cout <= c_s(N);

generation_loop: for i in 0 to N-1 generate
 add_i : entity work.full_adder
 port map(a(i),b(i),c_s(i), s(i), c_s(i+1));
end generate generation_loop;

end Behavioral;
