----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2025 13:06:56
-- Design Name: 
-- Module Name: uart_receiver - Behavioral
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

entity uart_receiver is
generic(
    N : integer :=8; -- data size
    DATA_RATE : integer := 115200;
    CLK_FREQUENCE : integer := 100000000;
    NB_CLK_TO_SYNC : integer := 868 -- =CLK_FREQUENCE/DATA_RATE
);
Port (
    data_in : in std_logic;
    data_out : out std_logic_vector(N-1 downto 0);
    clk,rst : in std_logic;
    data_valid : out std_logic; --result for parity bit is expected
    done : out std_logic --stop bit received
);
end uart_receiver;

architecture Behavioral of uart_receiver is
type fsm_t is (IDLE, MIDDLE, RECEPTION, WAIT_CLK);
signal state : fsm_t;
signal index : integer range 0 to N+1; --allow to count data bits but also parity and stop bits
signal clk_count : integer range 0 to NB_CLK_TO_SYNC-1;
signal ready : std_logic;
signal parity_r: std_logic; --parity-bit received
signal parity_c: std_logic; --parity-bit calculated
signal data_s : std_logic_vector(N-1 downto 0);
begin

    process(clk,rst)
     variable temp : std_logic := '0';
    begin
        if rst='1' then
            done <= '0';
            index <= 0;
            clk_count <= 0;
            ready <= '1';
            data_s <= (others => '0');
            state <= IDLE;
        elsif rising_edge(clk) then
            case(state) is
            when IDLE =>
                if data_in = '0' then --START bit
                    clk_count <= clk_count+1;
                    ready <= '0';
                    state <= MIDDLE;
                else 
                    clk_count <= 0;
                    ready <= '1';
                    state <= IDLE;
                end if;
            when MIDDLE => --find de middle of the bit
                if clk_count = (NB_CLK_TO_SYNC-1)/2 then
                    clk_count <= 0;
                    if data_in = '0' then
                        state <= WAIT_CLK;
                    else
                        state <= IDLE;
                    end if;
                else
                    clk_count <= clk_count+1;
                    state <= MIDDLE;
                end if;
            when WAIT_CLK =>
                if clk_count = NB_CLK_TO_SYNC-1 then
                    clk_count <= 0;
                    if index < N then --reception of data
                        data_s(index) <= data_in;
                        state <= RECEPTION;
                    elsif index = N then --reception of parity bit
                        --process parity bit
                        for i in 0 to N-1 loop
                            temp := temp xor data_s(i);
                        end loop;
                        parity_c <= temp;
                        parity_r <= data_in;
                        state <= RECEPTION;
                    elsif index = N+1 then
                        data_valid <= not(parity_c xor parity_r);
                        done <= data_in;
                        state <= RECEPTION;
                    end if;
                elsif clk_count < NB_CLK_TO_SYNC-1 then
                    clk_count <= clk_count+1;
                    state <= WAIT_CLK;
                end if;
            when RECEPTION =>
                clk_count <= clk_count+1;
                if index < N + 1 then
                    index <= index+1;
                    state <= WAIT_CLK; 
                elsif index = N+1 then
                    index <= 0;
                    clk_count <= 0;
                    done <= '0';
                    ready <= '1';
                    state <= IDLE;
                end if;
            end case;
        end if;
    end process;
    data_out <= data_s;
end Behavioral;
