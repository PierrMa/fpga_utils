----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.07.2025 16:26:23
-- Design Name: 
-- Module Name: full_adder - Behavioral
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

entity full_adder is
Port ( 
    a,b,cin: in std_logic;
    s,cout: out std_logic
);
end full_adder;

architecture Behavioral of full_adder is

begin
    s <= a xor b xor cin;
    cout <= (a and b) or ((a xor b) and cin);

end Behavioral;
