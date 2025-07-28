----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.07.2025 14:16:30
-- Design Name: 
-- Module Name: top_i2c_multi_master - Behavioral
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

entity top_i2c_multi_master is
generic(
    BAUD1, BAUD2 : integer := 2; --i2c standard frequency (100kbit/s)
    F_CLK1, F_CLK2 : integer := 4
);
Port ( 
    --------------master1-----------------
    clk_m1,rst_m1 : in std_logic;
    data_in_m1 : in std_logic_vector(7 downto 0);
    data_out_m1 : out std_logic_vector(7 downto 0);
    address_m1 : in std_logic_vector(6 downto 0);
    rw_m1 : in std_logic; -- '1' to read, '0' to write
    go_m1 : in std_logic; --there is a data to write or to read
    done_m1 : out std_logic;
    last_byte_m1 : in std_logic;
    slave_nack_m1 : out std_logic;
    lost_arbitration_m1 : out std_logic;
    --------------master2-----------------
    clk_m2,rst_m2 : in std_logic;
    data_in_m2 : in std_logic_vector(7 downto 0);
    data_out_m2 : out std_logic_vector(7 downto 0);
    address_m2 : in std_logic_vector(6 downto 0);
    rw_m2 : in std_logic; -- '1' to read, '0' to write
    go_m2 : in std_logic; --there is a data to write or to read
    done_m2 : out std_logic;
    last_byte_m2 : in std_logic;
    slave_nack_m2 : out std_logic;
    lost_arbitration_m2 : out std_logic;
    --------------slave-----------------
    clk_s,rst_s : in std_logic;
    data_in_s : in std_logic_vector (7 downto 0);
    data_out_s : out std_logic_vector (7 downto 0);
    stop_error_s : out std_logic
);
end top_i2c_multi_master;

architecture Behavioral of top_i2c_multi_master is
--------------------------------------------
--
--          COMPONENTS
--
--------------------------------------------
component i2c_multi_master is
generic(
    BAUD : integer := 100000; --i2c standard frequency (100kbit/s)
    F_CLK : integer := 100000000 --system clock
);
Port (
    clk,rst : in std_logic;
    data_in : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0);
    address : in std_logic_vector(6 downto 0);
    rw : in std_logic; -- '1' to read, '0' to write
    scl_in : in std_logic;
    scl_out : out std_logic;
    sda_in : in std_logic;
    sda_out : out std_logic;
    sda_dir : out std_logic; --'1' for master output, '0' for master input
    go : in std_logic; --there is a data to write or to read
    done : out std_logic;
    last_byte : in std_logic;
    slave_nack : out std_logic;
    lost_arbitration : out std_logic
);
end component;

component i2c_slave
Port (
    clk,rst : in std_logic;
    scl : in std_logic;
    sda : inout std_logic;
    sda_dir : in std_logic; --'1' for master output, '0' for master input
    data_in : in std_logic_vector (7 downto 0);
    data_out : out std_logic_vector (7 downto 0);
    stop_error : out std_logic
);
end component;

--------------------------------------------
--
--          SIGNALS
--
--------------------------------------------
--------------master1-----------------
signal scl_in_m1 : std_logic;
signal scl_out_m1 : std_logic;
signal sda_in_m1 : std_logic;
signal sda_out_m1 : std_logic;
signal sda_dir_m1 : std_logic; --'1' for master output, '0' for master input
signal s_lost_arbitration_m1 : std_logic;
--------------master2-----------------
signal scl_in_m2 : std_logic;
signal scl_out_m2 : std_logic;
signal sda_in_m2 : std_logic;
signal sda_out_m2 : std_logic;
signal sda_dir_m2 : std_logic; --'1' for master output, '0' for master input
signal s_lost_arbitration_m2 : std_logic;
--------------slave-----------------
signal scl_s : std_logic;
signal sda_s : std_logic;
signal sda_dir_s : std_logic; --'1' for master output, '0' for master input
----------------others--------------
signal scl_com : std_logic;

begin

    master1 : i2c_multi_master
    generic map(BAUD=>BAUD1,F_CLK=>F_CLK1)
    port map(
        clk => clk_m1,
        rst => rst_m1,
        data_in => data_in_m1,
        data_out => data_out_m1,
        address => address_m1,
        rw => rw_m1,
        scl_in => scl_in_m1,
        scl_out => scl_out_m1,
        sda_in => sda_in_m1,
        sda_out => sda_out_m1,
        sda_dir => sda_dir_m1,
        go => go_m1,
        done => done_m1,
        last_byte => last_byte_m1,
        slave_nack => slave_nack_m1,
        lost_arbitration => s_lost_arbitration_m1
    );
    
    master2 : i2c_multi_master
    generic map(BAUD=>BAUD2,F_CLK=>F_CLK2)
    port map(
        clk => clk_m2,
        rst => rst_m2,
        data_in => data_in_m2,
        data_out => data_out_m2,
        address => address_m2,
        rw => rw_m2,
        scl_in => scl_in_m2,
        scl_out => scl_out_m2,
        sda_in => sda_in_m2,
        sda_out => sda_out_m2,
        sda_dir => sda_dir_m2,
        go => go_m2,
        done => done_m2,
        last_byte => last_byte_m2,
        slave_nack => slave_nack_m2,
        lost_arbitration => s_lost_arbitration_m2
    );
    
    slave : i2c_slave
    port map(
        clk => clk_s,
        rst => rst_s,
        scl => scl_s,
        sda => sda_s,
        sda_dir => sda_dir_s,
        data_in => data_in_s,
        data_out => data_out_s,
        stop_error => stop_error_s
    );
    
    lost_arbitration_m1 <= s_lost_arbitration_m1;
    lost_arbitration_m2 <= s_lost_arbitration_m2;
    
    scl_com <= scl_out_m1 when s_lost_arbitration_m1='0' and s_lost_arbitration_m2='1' else
             scl_out_m2 when s_lost_arbitration_m1='1' and s_lost_arbitration_m2='0' else
             scl_out_m1 and scl_out_m2 when s_lost_arbitration_m1='0' and s_lost_arbitration_m2='0' else
             '1';
    scl_s <= scl_com;
    scl_in_m1 <= scl_com;
    scl_in_m2 <= scl_com;
    
    sda_in_m1 <= sda_s when sda_dir_m1 = '0' else sda_out_m2;
    sda_in_m2 <= sda_s when sda_dir_m2 = '0' else sda_out_m1;
    sda_s <= 'Z' when sda_dir_m1 = '0' and sda_dir_m2 = '0' else
             sda_out_m1 when s_lost_arbitration_m1='0' and s_lost_arbitration_m2='1' and sda_dir_m1 = '1' else
             sda_out_m2 when s_lost_arbitration_m1='1' and s_lost_arbitration_m2='0' and sda_dir_m2 = '1' else
             sda_out_m1 when s_lost_arbitration_m1='0' and s_lost_arbitration_m2='0' and sda_dir_m1 = '1' and sda_dir_m2 = '1'else
             'Z';
    
    sda_dir_s <= sda_dir_m1 when s_lost_arbitration_m1='0' else
                 sda_dir_m2 when s_lost_arbitration_m2='0' else
                 '0';

end Behavioral;
