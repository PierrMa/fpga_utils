----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.07.2025 17:56:40
-- Design Name: 
-- Module Name: async_fifo_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity async_fifo_tb is
end async_fifo_tb;

architecture Behavioral of async_fifo_tb is
constant width : integer := 4;
constant depth : integer := 8;
signal w_data :  std_logic_vector(width-1 downto 0);
signal w_rst,w_clk,w_en : std_logic := '1';
signal r_data : std_logic_vector(width-1 downto 0);
signal r_rst,r_clk : std_logic :='1';
signal r_en : std_logic;
signal full,empty : std_logic;

begin

    dut : entity work.async_fifo
    generic map(width=>width,depth=>depth)
    port map(
        w_data=>w_data,
        w_rst=>w_rst,
        w_clk=>w_clk,
        w_en=>w_en,
        r_data=>r_data,
        r_rst=>r_rst,
        r_clk=>r_clk,
        r_en=>r_en,
        full=>full,
        empty=>empty
    );
    
    w_clk <= not(w_clk) after 5ns;
    r_clk <= not(r_clk) after 2.5ns;
    r_rst <= '1' after 0ns, '0' after 10ns;
    w_rst <= '1' after 0ns, '0' after 10ns;
    w_data <= "1111" after 0ns, "1110" after 20ns, "1100" after 30ns, "1000" after 40ns, "0000" after 50ns, "0001" after 60ns, "0011" after 70ns, "0111" after 80ns, "1111" after 90ns, "1011" after 100ns, "1010" after 110ns,"0101" after 120ns, "1001" after 130ns;
    r_en <= '0' after 0ns, '1' after 20ns, '0' after 100ns, '1' after 200ns;
    w_en <= '0' after 30ns, '1' after 55ns;

end Behavioral;
