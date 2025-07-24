----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.07.2025 15:37:55
-- Design Name: 
-- Module Name: i2c_master - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_master is
generic(
    BAUD : integer := 100000; --i2c standard frequency (100kbit/s)
    F_CLK : integer := 100000000
);
Port (
    clk,rst : in std_logic;
    data_in : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0);
    address : in std_logic_vector(6 downto 0);
    rw : in std_logic; -- '1' to read, '0' to write
    scl : out std_logic;
    sda : inout std_logic;
    sda_direction : out std_logic; --'1' for master output, '0' for master input
    go : in std_logic; --there is a data to write or to read
    done : out std_logic
);
end i2c_master;

architecture Behavioral of i2c_master is

function process_half_bit_rate(
    f : in integer; 
    i2c_rate : in integer
) return integer is variable half_bit_rate: integer;
begin
    return f/(2*i2c_rate);
end function;

constant HALF_PERIOD : integer := process_half_bit_rate(F_CLK,BAUD);

type fsm_t is (IDLE,START1,START2,ADDR1,ADDR2,ACK1,ACK2,READ1,READ2,NACK1,NACK2,WRITE1,WRITE2,ACK1B,ACK2B,STOP1,STOP2,CLEAN);
signal state : fsm_t;
signal data : std_logic_vector(7 downto 0);
signal addr_rw : std_logic_vector(7 downto 0);
signal clk_count : integer range 0 to HALF_PERIOD := 0;
signal index : integer range 0 to 7;
signal scl_tick : std_logic := '0';
signal sda_s : std_logic;
signal sda_dir_s : std_logic; --'1' for master output, '0' for master input

begin
    
    --generate a clk of period BAUD
    process(clk,rst)
    begin
        if rst='1' then 
            scl_tick <= '0';
            clk_count <= 0;
        elsif rising_edge(clk) then
            if clk_count = HALF_PERIOD then
                scl_tick <= '1';
                clk_count <= 0;
            elsif clk_count < HALF_PERIOD then
                scl_tick <= '0';
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;
    
    process(clk,rst,state,scl_tick)
    begin
        if rst = '1' then 
            state <= IDLE;
            data <= (others =>'0');
            addr_rw <= (others =>'0');
            index <= 7;
            sda_dir_s <= '0';
            data_out <= (others =>'0');
            sda_s <= '1';
            scl <= '1';
            done <= '0';
        elsif rising_edge(clk) then
            if scl_tick = '1' then
                case(state) is
                when IDLE =>
                    index <= 7;
                    sda_dir_s <= '0';
                    scl <= '1';
                    sda_s <= '1'; --the resting state of SDA is '1'
                    done <= '0';
                    
                    if go = '1' then
                        data <= data_in;
                        addr_rw <= address&rw;
                        state <= START1;
                    else 
                        state <= IDLE;
                    end if;
                
                when START1 =>
                    sda_dir_s <= '1';
                    scl <= '1';
                    sda_s <= '1';
                    state <= START2;
                
                when START2 =>
                    scl <= '1';
                    sda_s <= '0';
                    index <= 7;
                    state <= ADDR1;
                
                when ADDR1 =>
                    scl <= '0';
                    sda_s <= addr_rw(index);
                    state <= ADDR2;
                    
                when ADDR2 =>
                    scl <= '1';
                    if index = 0 then
                        index <= 7;
                        state <= ACK1;
                    elsif index > 0 then
                        index <= index - 1;
                        state <= ADDR1;
                    end if;
                
                when ACK1 =>
                    sda_dir_s <= '0';
                    scl <= '0';
                    state <= ACK2;
                    
                when ACK2 =>
                    scl <= '1';
                    if sda = '0' then --SLAVE ACK
                        index <= 7;
                        if rw = '1' then
                            state <= READ1;
                        else 
                            state <= WRITE1;
                        end if;
                    else --SLAVE NACK
                        state <= STOP1;
                    end if;
                    
                when READ1 =>
                    sda_dir_s <= '0';
                    scl <= '0';
                    state <= READ2;
                
                when READ2 =>
                    scl <= '1';
                    data(index) <= sda;
                    if index = 0 then
                        index <= 7;
                        state <= NACK1;
                    elsif index > 0 then
                        index <= index - 1;
                        state <= READ1;
                    end if;
                
                when NACK1 =>
                    data_out <= data;
                    sda_dir_s <= '1';
                    scl <= '0';
                    sda_s <= '1';
                    state <= NACK2;
                
                when NACK2 =>
                    scl <= '1';
                    state <= STOP1;
                        
                when WRITE1 =>
                    sda_dir_s <= '1';
                    scl <= '0';
                    sda_s <= data(index);
                    state <= WRITE2;
                
                when WRITE2 =>
                    scl <= '1';
                    if index = 0 then
                        index <= 7;
                        state <= ACK1B;
                    elsif index > 0 then
                        index <= index-1;
                        state <= WRITE1;
                    end if;
                
                when ACK1B =>
                    sda_dir_s <= '0';
                    scl <= '0';
                    state <= ACK2B;
                
                when ACK2B =>
                    scl <= '1';
                    state <= STOP1;
                    
                when STOP1 =>
                    sda_dir_s <= '1';
                    scl <= '1';
                    sda_s <= '0';
                    state <= STOP2;
                
                when STOP2 =>
                    scl <= '1';
                    sda_s <= '1';
                    state <= CLEAN;
                    
                when CLEAN =>
                    done <= '1';
                    state <= IDLE;
                    
                end case;
            end if;
        end if;
    end process;

    sda_direction <= sda_dir_s;
    sda <= sda_s when sda_dir_s = '1' else 'Z';
end Behavioral;
