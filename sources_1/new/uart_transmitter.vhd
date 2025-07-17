----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2025 16:01:58
-- Design Name: 
-- Module Name: uart - Behavioral
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

entity uart_transmitter is
generic(
    N : integer :=8; -- data size
    DATA_RATE : integer := 115200;
    CLK_FREQUENCE : integer := 100000000;
    NB_CLK_TO_SYNC : integer := 868 -- =CLK_FREQUENCE/DATA_RATE
);
Port (
    data_in : in std_logic_vector(N-1 downto 0);
    data_out : out std_logic;
    clk,rst: in std_logic;
    go : in std_logic; --signal to start the transfer
    done : out std_logic --a new data has been transfered successfully
);
end uart_transmitter;

architecture Behavioral of uart_transmitter is
constant DATA_SIZE_WITH_HEADER : integer := N+3;
type fsm_t is (IDLE, TRANSFER, WAIT_CLK);
signal state : fsm_t;
signal clk_count : integer range 0 to NB_CLK_TO_SYNC-1;
signal index : integer range 0  to DATA_SIZE_WITH_HEADER;
signal data : std_logic_vector(N-1 downto 0);
signal parity_bit : std_logic;
signal ready : std_logic;

begin    
    
    process(clk,rst,state,go,index,ready)
        variable temp : std_logic;
    begin
        if rst = '1' then 
            state <= IDLE;
        elsif rising_edge(clk) then
            case(state)is
            when IDLE => 
                --output assignment
                data_out <= '1';
                done <= '0';
                clk_count <= 0;
                index <= 0;
                --state assignment
                if go = '1' then
                    state <= TRANSFER;
                    ready <= '0';
                    data <= data_in;
                    --process parity bit
                    temp := data_in(0);
                    for i in 1 to N-1 loop
                        temp := data_in(i) xor temp;
                    end loop;
                    parity_bit <= temp;
                else
                    state <= IDLE;
                    ready <= '1';
                    data <= (others => '0');
                end if;
            when TRANSFER =>
                if index = 0 then
                    data_out <= '0'; --start bit
                elsif index = DATA_SIZE_WITH_HEADER-2 then
                    data_out <= parity_bit; 
                elsif index = DATA_SIZE_WITH_HEADER-1 then
                    data_out <= '1'; --stop bit
                else --data
                    data_out <= data(0);
                    data <= '0'&data(N-1 downto 1);
                end if;
                
                clk_count <= clk_count+1;
                index <= index +1;
                
                state <= WAIT_CLK;
            when WAIT_CLK =>
                if clk_count = NB_CLK_TO_SYNC-1 then
                    clk_count <= 0;
                    if index < DATA_SIZE_WITH_HEADER then
                        state <= TRANSFER;
                    elsif index = DATA_SIZE_WITH_HEADER then
                        ready <= '1';
                        done <= '1';
                        state <= IDLE;
                    end if;
                elsif clk_count < NB_CLK_TO_SYNC-1 then
                    clk_count <= clk_count+1;
                    state <= WAIT_CLK;
                end if;
            end case;
        end if;
    end process;
end Behavioral;
