----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.07.2025 10:07:03
-- Design Name: 
-- Module Name: half_adder_tb - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity half_adder_tb is
--  Port ( );
end half_adder_tb;

architecture Behavioral of half_adder_tb is
signal a_s,b_s,s_s,c_s,rst_s,clk_s: std_logic;
begin

    my_adder: entity work.half_adder
    port map(
        a => a_s,
        b => b_s,
        c => c_s,
        s => s_s,
        clk => clk_s,
        rst => rst_s
    );
    
    rst_s <= '1' after 0ns, '0' after 10ns, '1' after 50ns;
    a_s <= '0' after 0ns, '1' after 20ns, '0' after 30ns, '1' after 40ns;
    b_s <= '0' after 0ns, '1' after 30ns;
    clk_s <= '1' after 0ns, '0' after 5ns, '1' after 10ns, '0' after 15ns, '1' after 20ns, '0' after 25ns, '1' after 30ns, '0' after 35ns, '1' after 40ns, '0' after 45ns, '1' after 50ns, '0' after 55ns;
end Behavioral;
