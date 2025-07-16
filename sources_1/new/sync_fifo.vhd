library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync_fifo is
generic( 
    width : integer := 4;
    depth : integer := 10
);
Port ( 
    clk,rst : in std_logic;
    e : in std_logic_vector(width-1 downto 0);
    s : out std_logic_vector(width-1 downto 0);
    RdWrn : in std_logic
);
end sync_fifo;

architecture Behavioral of sync_fifo is
type fifo_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
signal data : fifo_type;
signal rd_idx : integer range 0 to depth-1;
signal wr_idx : integer range 0 to depth-1;
signal is_full : std_logic;
signal is_empty : std_logic;

begin

    process(clk,rst)
    variable nb_empty : integer range 0 to depth;
    begin
        if rst='1' then 
            s <= (others => '0');
            data <= (others => (others => '0'));
            rd_idx <= depth-1;
            wr_idx <= depth-1;
            is_full <= '0';
            is_empty <= '1';
            nb_empty := depth;
        elsif rising_edge(clk) then
            if RdWrn='1' and  is_empty = '0' then --lecture d'une fifo non vide
                --gestion de la fifo
                s <= data(rd_idx);
                
                --gestion de l'index
                if rd_idx = 0 then
                    rd_idx <= depth-1;
                else
                    rd_idx <= rd_idx - 1;
                end if;
                
                --gestion de nb_empty, is_full et is_empty
                nb_empty := nb_empty + 1;
                if nb_empty = depth then 
                    is_empty <= '1'; 
                    is_full <= '0';
                else 
                    is_empty <= '0';
                    is_full <= '0';
                end if;
                
            elsif RdWrn='0' and is_full = '0' then --écriture dans une fifo non pleine
                --gestion de la fifo
                data(wr_idx) <= e;
                
                --gestion de l'index
                if wr_idx = 0 then
                    wr_idx <= depth-1;
                else
                    wr_idx <= wr_idx - 1;
                end if;
                
                --gestion de nb_empty, is_full et is_empty
                nb_empty := nb_empty - 1;
                if nb_empty = 0 then 
                    is_full <= '1';
                    is_empty <= '0';
                else
                    is_full <= '0';
                    is_empty <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
