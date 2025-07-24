----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2025 12:06:26
-- Design Name: 
-- Module Name: i2c_master_tb - Behavioral
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


entity i2c_master_tb is
end i2c_master_tb;

architecture Behavioral of i2c_master_tb is

component i2c_master
generic(
    BAUD : integer;
    F_CLK : integer
);
port (
    clk,rst : in std_logic;
    data_in : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0);
    address : in std_logic_vector(6 downto 0);
    rw : in std_logic; -- '1' to read, '0' to write
    scl : out std_logic;
    sda : inout std_logic;
    sda_direction : out std_logic; --'1' for master output, '0' for master input
    go : in std_logic; --there is a data to write or to read
    done : out std_logic
);
end component;

constant BAUD : integer := 2;
constant F_CLK : integer := 4;
constant CLK_PERIOD : time := 10ns;
constant SCL_PERIOD : time := 20ns; --(F_CLK/BAUD) * CLK_PERIOD
signal clk : std_logic := '1';
signal rst : std_logic := '1';
signal data_in, data_out : std_logic_vector(7 downto 0);
signal address : std_logic_vector(6 downto 0);
signal rw : std_logic;
signal scl : std_logic;
signal sda : std_logic; --sda bidirectionnal
signal sda_s : std_logic :='Z'; -- sda from testbench driven by the slave i2c
signal go : std_logic := '0';
signal done : std_logic;
signal sda_dir : std_logic;
begin

    master : i2c_master
    generic map(BAUD, F_CLK)
    port map(clk=>clk,rst=>rst,data_in=>data_in,data_out=>data_out,address=>address,rw=>rw,scl=>scl,sda=>sda,sda_direction=>sda_dir,go=>go,done=>done);
    
    clk <= not(clk) after 5ns;
    rst <= '0' after 10ns;
    
    process
    begin
        --write operation
        rw <= '0';
        go <= '0';
        wait for CLK_PERIOD;
        --IDLE
        go <= '1';
        data_in <= "01010101";
        address <= "1111111";
        wait for SCL_PERIOD;
        --START1
        go <= '0';
        wait for SCL_PERIOD;
        --START2
        wait for SCL_PERIOD;
        --ADDR1 & ADDR2
        wait for SCL_PERIOD*16;
        --ACK1
        sda_s <= '0'; --Slave ACK
        wait for SCL_PERIOD;
        --ACK2
        wait for SCL_PERIOD;
        --WRITE1 & WRITE2
        wait for SCL_PERIOD*16;
        --ACK1B
        sda_s <= '0'; --Slave ACK
        wait for SCL_PERIOD;
        --ACK2B
        wait for SCL_PERIOD;
        --STOP1
        wait for SCL_PERIOD;
        --STOP2
        wait for SCL_PERIOD;
        --CLEAN
        wait for SCL_PERIOD;
        --IDLE
        
        --read operation
        rw <= '1';
        go <= '1';
        wait for SCL_PERIOD;
        --START1
        go <= '0';
        wait for SCL_PERIOD*18;
        --START2 => ADDR1 & ADDR2 => ACK1
        sda_s <= '0'; --Slave ACK
        wait for SCL_PERIOD*2;
        --ACK2 => READ1
        --Simulate slave sending "10101010" starting from MSB
        sda_s <= '1';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '0';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '1';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '0';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '1';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '0';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '1';
        wait for SCL_PERIOD*2;
        --READ2 => READ1
        sda_s <= '0';
        wait for SCL_PERIOD*4;
        --READ2 => NACK1 => NACK2 => STOP1
        assert data_out = "10101010" report "Error : data read is different of data sent by the slave" severity error;
        wait for SCL_PERIOD*3;
        --STOP2 => CLEAN => IDLE        
    end process;
    sda <= sda_s when sda_dir = '0' else 'Z';
end Behavioral;
