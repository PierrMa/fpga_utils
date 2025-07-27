----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2025 18:47:49
-- Design Name: 
-- Module Name: i2c_master_controller_tb - Behavioral
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

entity i2c_master_controller_tb is
end i2c_master_controller_tb;

architecture Behavioral of i2c_master_controller_tb is
--------------------------------------------
--
--          COMPONENTS
--
--------------------------------------------
component i2c_master_controller is
generic( NB_MASTER : integer);
Port (
    sda : inout std_logic_vector(NB_MASTER-1 downto 0); --sda ligne from master
    sda_dir_in: in std_logic_vector(NB_MASTER-1 downto 0); --sda_dir from master
    sda_dir_com: out std_logic; --sda dir to slave
    conflict: out std_logic_vector(NB_MASTER-1 downto 0);   --lost arbitration signal
    sda_com: inout std_logic; --sda signal to/from slave
    scl_in : in std_logic_vector(NB_MASTER-1 downto 0); --scl from masters to controller
    scl_out: out std_logic_vector(NB_MASTER-1 downto 0); --scl from controller to master
    scl_com : out std_logic --scl from controller to slave
);
end component;
--------------------------------------------
--
--          CONSTANTS
--
--------------------------------------------
constant NB_MASTER : integer := 3;
--------------------------------------------
--
--          SIGNALS
--
--------------------------------------------
---------------controller-------------------
signal sda : std_logic_vector(NB_MASTER-1 downto 0) := (others => '1'); --inout
signal sda_dir : std_logic_vector(NB_MASTER-1 downto 0);
signal sda_dir_com : std_logic;
signal conflict : std_logic_vector(NB_MASTER-1 downto 0);
signal sda_com : std_logic;
signal scl_in : std_logic_vector(NB_MASTER-1 downto 0) := (others => '1');
signal scl_out : std_logic_vector(NB_MASTER-1 downto 0);
signal scl_com : std_logic;
signal sda_s : std_logic; --sda frome slave
signal sda_m : std_logic_vector(NB_MASTER-1 downto 0) := (others => '1'); --sda from master
--------------------------------------------
--
--          ARCHITECTURE BODY
--
--------------------------------------------
begin
    
    controller : i2c_master_controller
    generic map(NB_MASTER=>NB_MASTER)
    port map(
        sda => sda,
        sda_dir_in => sda_dir,
        sda_dir_com => sda_dir_com,
        conflict => conflict,
        sda_com => sda_com,
        scl_in => scl_in,
        scl_out => scl_out,
        scl_com => scl_com
    );
    
    -- master scl are sync from 0 to 80ns and async from 80ns
    scl_in(0) <= not(scl_in(0)) after 5ns;
    scl_in(1) <= '0' after 5ns, '1' after 10ns, '0' after 15ns, '1' after 20ns, '0' after 25ns, '1' after 30ns, '0' after 35ns, '1' after 40ns, '0' after 45ns, '1' after 50ns, '0' after 55ns, '1' after 60ns, '0' after 65ns, '1' after 70ns, '0' after 75ns, '1' after 80ns,
                '0' after 85.2ns, '1' after 90.4ns, '0' after 95.6ns, '1' after 100.8ns, '0' after 106ns, '1' after 111.2ns, '0' after 116.4ns, '1' after 121.6ns, '0' after 126.8ns, '1' after 132ns, '0' after 137.2ns, '1' after 142.4ns, '0' after 147.6ns, '1' after 152.8ns, '0' after 158ns, '1' after 163.2ns;
    scl_in(2) <= not(scl_in(0)) after 5ns;
    
    process
        variable expected : std_logic;
    begin
        -----------------------------------
        --masters write
        -----------------------------------
        sda_dir <= (others => '1');
        
        -- data from the masters is the same
        sda_m(2) <= '1';
        sda_m(1) <= '1';
        sda_m(0) <= '1';
        wait for 20ns;
        expected := '1';
        assert expected = sda_com report "Error: wrong value for sda_com. Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda_com) severity error;
        
        sda_m(2) <= '0';
        sda_m(1) <= '0';
        sda_m(0) <= '0';
        wait for 20ns;
        expected := '0';
        assert expected = sda_com report "Error: wrong value for sda_com. Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda_com) severity error;
        
        -- data from the master is different
        sda_m(2) <= '0';
        sda_m(1) <= '1';
        sda_m(0) <= '1';
        wait for 20ns;
        expected := '0';
        assert expected = sda_com report "Error: wrong value for sda_com. Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda_com) severity error;
        
        sda_m(2) <= '1';
        sda_m(1) <= '0';
        sda_m(0) <= '0';
        wait for 20ns;
        expected := '0';
        assert expected = sda_com report "Error: wrong value for sda_com. Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda_com) severity error;
        
        -----------------------------------
        --slave write
        -----------------------------------
        sda_dir <= (others => '0');
        sda_s <= '1';
        wait for 10ns;
        expected := '1';
        for i in 0 to NB_MASTER-1 loop
            assert expected = sda(i) report "Error: wrong value for sda from master" & integer'image(i) &". Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda(i)) severity error;
        end loop;
        
        sda_s <= '0';
        wait for 10ns;
        expected := '0';
        for i in 0 to NB_MASTER-1 loop
            assert expected = sda(i) report "Error: wrong value for sda from master" & integer'image(i) &". Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda(i)) severity error;
        end loop;
        
        -----------------------------------
        --only master0 write
        -----------------------------------
        sda_dir(0) <= '1';
        sda_dir(2 downto 1)  <= (others => '0');
        sda_m(2) <= '0';
        sda_m(1) <= '1';
        sda_m(0) <= '1'; --this value should output through sda_com
        wait for 20ns;
        expected := '1';
        assert expected = sda_com report "Error: wrong value for sda_com. Expected : " & std_logic'image(expected) & ", receive : "&std_logic'image(sda_com) severity error;
        
        wait;
    end process;
    
    sda_com <= sda_s when sda_dir_com = '0' else 'Z';
    sda <= sda_m when sda_dir_com = '1' else (others => 'Z');
    
end Behavioral;
