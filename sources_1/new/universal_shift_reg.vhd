library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_shift_reg is
generic(N: integer :=4);
Port (
    serial_left : in std_logic;
    serial_right : in std_logic;
    paralel : in std_logic_vector(N-1 downto 0);
    q: out std_logic_vector(N-1 downto 0);
    clk,rst: in std_logic;
    sel: in std_logic_vector(1 downto 0)
);
end universal_shift_reg;

architecture Behavioral of universal_shift_reg is
signal q_s : std_logic_vector(N-1 downto 0);
signal mux_o : std_logic_vector(N-1 downto 0);
begin
    FF_generator : for i in 0 to N-1 generate
        FF_i : entity work.d_flip_flop
        port map(D=>mux_o(i),Q=>q_s(i),clk=>clk,rst=>rst);
    end generate;
    
    mux_0 : entity work.muxNv1
        generic map(N)
        port map(E(0)=>q_s(0), E(1)=>serial_left, E(2)=>q_s(1), E(3)=>paralel(0),
                S=>mux_o(0),
                sel=>sel);
        
    mux_generator : for i in 1 to N-2 generate
        mux_i : entity work.muxNv1
        generic map(N)
        port map(E(0)=>q_s(i),E(1)=>q_s(i-1), E(2)=>q_s(i+1), E(3)=>paralel(i),
                S=>mux_o(i),
                sel=>sel);
    end generate;
    
    mux_N_1 : entity work.muxNv1
        generic map(N)
        port map(E(0)=>q_s(N-1), E(1)=>q_s(N-2), E(2)=>serial_right, E(3)=>paralel(N-1),
                S=>mux_o(N-1),
                sel=>sel);
    
    process(clk,rst)
    begin
        if rst = '1' then q_s <= (others => '0');
        elsif rising_edge(clk) then 
            q_s <= mux_o;
        end if;
    end process;
    
    q <= q_s;
end Behavioral;
