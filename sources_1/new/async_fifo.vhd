library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

entity async_fifo is
generic(
    width : integer := 4;
    depth : integer := 8 --should be a power of 2
);
Port (
    w_data : in std_logic_vector(width-1 downto 0);
    w_rst,w_clk,w_en : in std_logic;
    r_data : out std_logic_vector(width-1 downto 0);
    r_rst,r_clk,r_en : in std_logic;
    full,empty : out std_logic
);
end async_fifo;

architecture Behavioral of async_fifo is
constant idx_width : integer := integer(ceil(log2(real(depth))));
type fifo_t is array(0 to depth-1) of std_logic_vector(width-1 downto 0);
signal data : fifo_t := (others => (others =>'0'));
signal w_index, r_index : std_logic_vector(idx_width downto 0);
signal gray_w_index, gray_r_index : std_logic_vector(idx_width downto 0);
signal buf1_gray_w_index, buf1_gray_r_index : std_logic_vector(idx_width downto 0);
signal buf2_gray_w_index, buf2_gray_r_index : std_logic_vector(idx_width downto 0);
signal full_s,empty_s : std_logic;
begin
    
    --combinatory logic
    full <= full_s;
    empty <= empty_s;
    
    --read and write operations
    process(w_clk)
    begin
        if rising_edge(w_clk) then
            if w_en='1' and full_s='0' then
                data(to_integer(unsigned(w_index(idx_width-1 downto 0)))) <= w_data;
            end if;
        end if;
    end process;
    
    process(r_clk,r_rst)
    begin
        if r_rst = '1' then r_data <= (others => '0');
        elsif rising_edge(r_clk) then
            if r_en = '1' and empty_s = '0' then
                r_data <= data(to_integer(unsigned(r_index(idx_width-1 downto 0))));
            end if;
        end if;
    end process;
    
    --binary to gray conversion
    wr_idx_converter : entity work.BinaryToGrayConverter
    generic map(idx_width+1)
    port map(E => w_index, S => gray_w_index);
    rd_idx_converter : entity work.BinaryToGrayConverter
    generic map(idx_width+1)
    port map(E => r_index, S => gray_r_index);
    
    --index handling
    process(w_clk,w_rst)
    begin
        if w_rst='1' then
            w_index <= (others => '0');
        elsif rising_edge(w_clk) then 
            if w_en='1' and full_s='0' then
                w_index <= std_logic_vector(unsigned(w_index)+1);
            end if;
        end if;
    end process;
    
    process(r_clk,r_rst)
    begin
        if r_rst='1' then
            r_index <= (others => '0');
        elsif rising_edge(r_clk) then 
            if r_en = '1' and empty_s = '0' then
                r_index <= std_logic_vector(unsigned(r_index)+1);
            end if;
        end if;
    end process;
    
    --double buffering of gray index
    process(r_clk,r_rst)
    begin
        if r_rst='1' then 
            buf1_gray_w_index <= (others => '0');
            buf2_gray_w_index <= (others => '0');
        elsif rising_edge(r_clk) then
            buf1_gray_w_index <= gray_w_index;
            buf2_gray_w_index <= buf1_gray_w_index;
        end if;
    end process;
    
    process(w_clk,w_rst)
    begin
        if w_rst='1' then 
            buf1_gray_r_index <= (others => '0');
            buf2_gray_r_index <= (others => '0');
        elsif rising_edge(w_clk) then
            buf1_gray_r_index <= gray_r_index;
            buf2_gray_r_index <= buf1_gray_r_index;
        end if;
    end process;
    
    --full/empty handling
    empty_s <= '1' when buf2_gray_w_index = gray_r_index else '0';
    full_s <= '1' when gray_w_index = not(buf2_gray_r_index(idx_width downto idx_width-1))& buf2_gray_r_index(idx_width-2 downto 0) else '0';
end Behavioral;
