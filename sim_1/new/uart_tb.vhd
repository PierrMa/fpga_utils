----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2025 17:20:27
-- Design Name: 
-- Module Name: uart_tb - Behavioral
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

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is
constant N : integer :=8;
constant DATA_RATE : integer := 2;
constant CLK_FREQUENCE : integer := 8;
signal data_in,data_out_r : std_logic_vector(N-1 downto 0);
signal data_out : std_logic;
signal clk : std_logic := '1';
signal rst : std_logic := '1';
signal go : std_logic := '1';
signal done,done_r : std_logic;
signal data_valid : std_logic;
begin

    transmitter : entity work.uart_transmitter
    generic map(N => N, DATA_RATE => DATA_RATE, CLK_FREQUENCE => CLK_FREQUENCE)
    port map(
        data_in => data_in,
        data_out => data_out,
        clk => clk,
        rst => rst,
        go => go,
        done => done
    );
    
    receiver : entity work.uart_receiver
    generic map(N => N, DATA_RATE => DATA_RATE, CLK_FREQUENCE => CLK_FREQUENCE)
    port map(
        data_in => data_out,
        data_out => data_out_r,
        clk => clk,
        rst => rst,
        data_valid => data_valid,
        done => done_r
    );
    
    clk <= not(clk) after 5ns;
    rst <= '0' after 5ns;
    go <= '0' after 25ns, '1' after 120ns, '0' after 500ns;
    data_in <= "10100101" after 0ns, "10100111" after 80ns;
    
    
end Behavioral;
