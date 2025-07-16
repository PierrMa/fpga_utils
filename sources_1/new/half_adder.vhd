----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.06.2025 16:20:30
-- Design Name: 
-- Module Name: half_adder - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity half_adder is
Port (
    a,b: in std_logic;
    s,c: out std_logic;
    clk,rst : in std_logic
);
end half_adder;

architecture Behavioral of half_adder is
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            s <= '0'; c <= '0';
        elsif rising_edge(clk) then
            s <= a xor b;
            c <= a and b;
        end if;
    end process;
end Behavioral;
