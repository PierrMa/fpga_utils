----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2025 12:57:19
-- Design Name: 
-- Module Name: i2c_master_controller - Behavioral
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

entity i2c_master_controller is
generic( NB_MASTER : integer := 4);
Port (
    sda : inout std_logic_vector(NB_MASTER-1 downto 0); --sda line from master
    sda_dir_in: in std_logic_vector(NB_MASTER-1 downto 0); --sda_dir from master
    sda_dir_com: out std_logic; --sda dir to slave
    conflict: out std_logic_vector(NB_MASTER-1 downto 0);   --lost arbitration signal
    sda_com: inout std_logic; --sda signal to/from slave
    scl_in : in std_logic_vector(NB_MASTER-1 downto 0); --scl from masters to controller
    scl_out: out std_logic_vector(NB_MASTER-1 downto 0); --scl from controller to master
    scl_com : out std_logic --scl from controller to slave
);
end i2c_master_controller;

architecture Behavioral of i2c_master_controller is

signal sda_com_s : std_logic:='1';
signal sda_dir_s : std_logic:='0';
signal scl_com_s : std_logic:='1';
begin
    sda_from_slave : for i in 0 to NB_MASTER-1 generate
        sda(i) <= sda_com when sda_dir_in(i)='0' else 'Z';
    end generate;
    
    or_sda_dir : process(sda_dir_in)
        variable sda_dir_v : std_logic := '0';
    begin
        for i in 0 to NB_MASTER-1 loop
            sda_dir_v := sda_dir_v or sda_dir_in(i);
        end loop;
        sda_dir_s <= sda_dir_v;
    end process;
    sda_dir_com <= sda_dir_s;
    
    conflict_gen : for i in 0 to NB_MASTER-1 generate
        conflict(i) <= not(sda(i) xnor sda_com) and sda_dir_in(i);
    end generate;
    
    and_sda : process(sda_dir_in,sda)
        variable sda_com_v : std_logic := '1';
    begin
        for i in 0 to NB_MASTER-1 loop
            sda_com_v := sda_com_v and (sda(i) and sda_dir_in(i));
        end loop;
        sda_com_s <= sda_com_v;
    end process;
    sda_com <= sda_com_s when sda_dir_s = '1' else 'Z';
    
    and_scl : process(scl_in)
        variable scl_com_v : std_logic := '1';
    begin
        for i in 0 to NB_MASTER-1 loop
            scl_com_v := scl_com_v and scl_in(i);
        end loop;
        scl_com_s <= scl_com_v;
    end process;
    scl_com <= scl_com_s;
    
    scl_gen : for i in 0 to NB_MASTER-1 generate
        scl_out(i) <= scl_com_s;
    end generate;
end Behavioral;
