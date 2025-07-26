----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.07.2025 11:37:51
-- Design Name: 
-- Module Name: i2c_tb - Behavioral
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

entity i2c_tb is
end i2c_tb;

architecture Behavioral of i2c_tb is
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
    done : out std_logic;
    last_byte : in std_logic
);
end component;

component i2c_slave
Port (
    clk,rst : std_logic;
    scl : in std_logic;
    sda : inout std_logic;
    sda_dir : in std_logic; --'1' for master output, '0' for master input
    data_in : in std_logic_vector (7 downto 0);
    data_out : out std_logic_vector (7 downto 0);
    stop_error : out std_logic
);
end component;

constant BAUD : integer := 2;
constant F_CLK : integer := 4;
constant CLK_PERIOD : time := 10ns;
constant SCL_PERIOD : time := 20ns; --(F_CLK/BAUD) * CLK_PERIOD
signal clk : std_logic := '1';
signal rst : std_logic := '1';
signal data_in_m, data_out_m : std_logic_vector(7 downto 0);
signal address : std_logic_vector(6 downto 0);
signal rw : std_logic;
signal scl : std_logic;
signal sda : std_logic; --sda bidirectionnal
signal go : std_logic := '0';
signal done : std_logic;
signal sda_dir : std_logic;
signal data_in_s, data_out_s : std_logic_vector(7 downto 0);
signal stop_error : std_logic;
signal last_byte : std_logic := '0';

procedure write(
    constant data : in std_logic_vector(7 downto 0);
    constant addr : in std_logic_vector(6 downto 0);
    signal done : in std_logic;
    signal rw : out std_logic;
    signal go : out std_logic;
    signal data_in_m : out std_logic_vector(7 downto 0);
    signal address : out std_logic_vector(6 downto 0)
)is
begin
    rw <= '0';
    go <= '0';
    wait for CLK_PERIOD;
    --IDLE
    go <= '1';
    data_in_m <= data;
    address <= addr;
    wait for SCL_PERIOD;
    --START1
    go <= '0';
    wait until done = '1';
end procedure;

begin

    master : i2c_master
    generic map(BAUD, F_CLK)
    port map(clk=>clk,rst=>rst,data_in=>data_in_m,data_out=>data_out_m,address=>address,rw=>rw,scl=>scl,sda=>sda,sda_direction=>sda_dir,go=>go,done=>done,last_byte=>last_byte);
    
    slave : i2c_slave
    port map(clk=>clk,rst=>rst,scl=>scl,sda=>sda,sda_dir=>sda_dir,data_in=>data_in_s,data_out=>data_out_s,stop_error=>stop_error);
    
    clk <= not(clk) after 5ns;
    rst <= '0' after 10ns;
    
    process
    begin
        --write operation
        write(
            data => "01010101",
            addr => "1111111",
            done => done,
            rw => rw,
            go => go,
            data_in_m => data_in_m,
            address => address
        );
        
        --read operation
        --read 1 byte
        rw <= '1';
        go <= '1';
        data_in_s <= x"aa";
        wait for SCL_PERIOD;
        go <= '0';
        wait for SCL_PERIOD*36;
        last_byte <= '1';
        wait for SCL_PERIOD*2;
        last_byte <= '0';
        wait until done = '1';
        assert data_out_m = data_in_s report "Error : data read is different of data sent by the slave" severity error;
        
        --read 3 bytes
        for i in 0 to 2 loop
            rw <= '1';
            go <= '1';
            data_in_s <= data_in_s(6 downto 0)&'0';
            wait for SCL_PERIOD;
            if i = 2 then last_byte <= '1'; else last_byte <= '0'; end if;
            wait for SCL_PERIOD*2;
            go <= '0';
            wait until sda_dir = '1';
            assert data_out_m = data_in_s report "Error : data read is different of data sent by the slave" severity error;
        end loop;
        
        report "Test completed" severity note;
        wait;
    end process;
end Behavioral;
