----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2025 14:59:16
-- Design Name: 
-- Module Name: i2c_slave - Behavioral
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

entity i2c_slave is
Port (
    clk,rst : std_logic;
    scl : in std_logic;
    sda : inout std_logic;
    sda_dir : in std_logic; --'1' for master output, '0' for master input
    data_in : in std_logic_vector (7 downto 0);
    data_out : out std_logic_vector (7 downto 0);
    stop_error : out std_logic
);
end i2c_slave;

architecture Behavioral of i2c_slave is
type fsm_t is (IDLE,START,READ_ADDR1,READ_ADDR2,ACK_ADDR1,ACK_ADDR2,READ_DATA1,READ_DATA2,WRITE1,WRITE2,ACK_DATA1,ACK_DATA2,STOP1,STOP2);
signal state : fsm_t;
signal sda_s : std_logic;
signal index : integer range 0 to 7;
signal data_s : std_logic_vector (7 downto 0);
signal rw : std_logic;

begin
    
    process(clk,rst,state)
    begin
        if rst = '1' then
            state <= IDLE;
            data_s <= (others=>'0');
            stop_error <= '0';
            index <= 7;
            rw <= 'Z';
            sda_s <= 'Z';
            data_out <= (others=>'0');
        elsif rising_edge(clk) then
            case(state) is
            when IDLE =>
                if scl = '1' and sda = '1' then
                    state <= START;
                else
                    state <= IDLE;
                end if;
                
                index <= 7;
                stop_error <= '0';
            when START =>
                if scl = '1' and sda = '0' then
                    state <= READ_ADDR1;
                elsif scl = '1' and sda = '1' then
                    state <= START;
                else
                    state <= IDLE;
                end if;
            when READ_ADDR1 =>
                if scl = '0' then state <= READ_ADDR2; end if;
            when READ_ADDR2 =>
                if scl = '1' then
                    data_s(index) <= sda;
                    if index = 0 then 
                        index <= 7;
                        rw <= sda;
                        state <= ACK_ADDR1;
                    elsif index > 0 then
                        index <= index-1;
                        state <= READ_ADDR1;
                    end if;
                end if;
            when ACK_ADDR1 =>
                if scl = '0' then
                    data_out <= data_s;
                    sda_s <= '0';
                    state <= ACK_ADDR2;
                end if;
            when ACK_ADDR2 =>
                if scl = '1' then 
                    if rw = '1' then -- master want to read so slave is writing
                        state <= WRITE1;
                    elsif rw = '0' then --master want to write so slave is reading
                        state <= READ_DATA1;
                    end if; 
                end if;
            when READ_DATA1 =>
                if scl = '0' then state <= READ_DATA2; end if;
            when READ_DATA2 =>
                if scl = '1' then
                    data_s(index) <= sda;
                    if index = 0 then 
                        index <= 7;
                        state <= ACK_DATA1;
                    elsif index > 0 then
                        index <= index-1;
                        state <= READ_DATA1;
                    end if;
                end if;
            when WRITE1 =>
                if scl = '0' then
                    sda_s <= data_in(index);
                    state <= WRITE2;
                end if;
            when WRITE2 =>
                if scl = '1' then 
                    if index = 0 then 
                        index <= 7;
                        state <= ACK_DATA1;
                    elsif index > 0 then
                        index <= index-1;
                        state <= WRITE1;
                    end if;
                end if;
            when ACK_DATA1 =>
                if scl = '0' then
                    if rw = '0' then --master write
                        data_out <= data_s;
                        sda_s <= '0'; -- slave ACK
                    end if;
                    state <= ACK_DATA2;
                end if;
            when ACK_DATA2 =>
                if scl = '1' then
                    if rw = '1' then --master read
                        --check if master want to read other data
                        if sda = '0' then --master ACK
                            state <= WRITE1;
                        elsif sda = '1' then --master NACK
                            state <= STOP1;
                        end if;
                    elsif rw = '0' then --master write
                        state <= STOP1; --master can only write 1 byte per transfer
                    end if;
                end if;
            when STOP1 =>
                if scl = '1' and sda = '0' then
                    state <= STOP2;
                else
                    state <= STOP1;
                end if;
            when STOP2 =>
                if scl = '1' and sda = '1' then
                    state <= IDLE;
                elsif scl = '1' and sda = '0' then
                    state <= STOP2;
                else
                    stop_error <= '1';
                    state <= IDLE;
                end if;
            end case;
        end if;
    end process;
    
    sda <= sda_s when sda_dir = '0' else 'Z';

end Behavioral;
