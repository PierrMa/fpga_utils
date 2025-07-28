----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.07.2025 15:45:49
-- Design Name: 
-- Module Name: top_i2c_multi_master_tb - Behavioral
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

entity top_i2c_multi_master_tb is
end top_i2c_multi_master_tb;

architecture Behavioral of top_i2c_multi_master_tb is
--------------------------------------------
--
--          COMPONENTS
--
--------------------------------------------
component top_i2c_multi_master is
generic(
    BAUD1, BAUD2 : integer; --i2c standard frequency (100kbit/s)
    F_CLK1, F_CLK2 : integer
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
end component;
--------------------------------------------
--
--          CONSTANTS
--
--------------------------------------------
constant BAUD1, BAUD2 : integer := 2; --i2c standard frequency (100kbit/s)
constant F_CLK1, F_CLK2 : integer := 4;
constant SCL_PERIOD : time := 20ns;
--------------------------------------------
--
--          SIGNALS
--
--------------------------------------------
--------------master1-----------------
signal clk_m1,rst_m1 : std_logic := '1';
signal data_in_m1 : std_logic_vector(7 downto 0);
signal data_out_m1 : std_logic_vector(7 downto 0);
signal address_m1 : std_logic_vector(6 downto 0);
signal rw_m1 : std_logic; -- '1' to read, '0' to write
signal go_m1 : std_logic := '0'; --there is a data to write or to read
signal done_m1 : std_logic := '0';
signal last_byte_m1 : std_logic := '1';
signal slave_nack_m1 : std_logic;
signal lost_arbitration_m1 : std_logic;
--------------master2-----------------
signal clk_m2,rst_m2 : std_logic := '1';
signal data_in_m2 : std_logic_vector(7 downto 0);
signal data_out_m2 : std_logic_vector(7 downto 0);
signal address_m2 : std_logic_vector(6 downto 0);
signal rw_m2 : std_logic; -- '1' to read, '0' to write
signal go_m2 : std_logic := '0'; --there is a data to write or to read
signal done_m2 : std_logic := '0';
signal last_byte_m2 : std_logic := '1';
signal slave_nack_m2 : std_logic;
signal lost_arbitration_m2 : std_logic;
--------------slave-----------------
signal clk_s,rst_s : std_logic  := '1';
signal data_in_s : std_logic_vector (7 downto 0);
signal data_out_s : std_logic_vector (7 downto 0);
signal stop_error_s : std_logic;

begin

    i2c_itf : top_i2c_multi_master
    generic map(BAUD1=>BAUD1,BAUD2=>BAUD2,F_CLK1=>F_CLK1,F_CLK2=>F_CLK2)
    port map(
        clk_m1 => clk_m1,
        rst_m1 => rst_m1,
        data_in_m1 => data_in_m1,
        data_out_m1 => data_out_m1,
        address_m1 => address_m1,
        rw_m1 => rw_m1,
        go_m1 => go_m1,
        done_m1 => done_m1,
        last_byte_m1 => last_byte_m1,
        slave_nack_m1 => slave_nack_m1,
        lost_arbitration_m1 => lost_arbitration_m1,
        clk_m2 => clk_m2,
        rst_m2 => rst_m2,
        data_in_m2 => data_in_m2,
        data_out_m2 => data_out_m2,
        address_m2 => address_m2,
        rw_m2 => rw_m2,
        go_m2 => go_m2,
        done_m2 => done_m2,
        last_byte_m2 => last_byte_m2,
        slave_nack_m2 => slave_nack_m2,
        lost_arbitration_m2 => lost_arbitration_m2,
        clk_s => clk_s,
        rst_s => rst_s,
        data_in_s => data_in_s,
        data_out_s => data_out_s,
        stop_error_s => stop_error_s
    );
    
    --masters with different clocks
    clk_m1 <= not clk_m1 after 5ns;
    clk_m2 <= not clk_m2 after 5ns;
    clk_s <= not clk_s after 5ns;
    
    rst_m1 <= '0' after 10ns;
    rst_m2 <= '0' after 10ns;
    rst_s <= '0' after 15ns;
    
    process
    begin
        -----------------------------
        --       master write      --
        -----------------------------
        --masters with same data
        data_in_m1 <= x"aa";
        data_in_m2 <= x"aa";
        address_m1 <= "1111111";
        address_m2 <= "1111111";
        rw_m1 <= '0';
        rw_m2 <= '0';
        go_m1 <= '1';
        go_m2 <= '1';
        
        wait for SCL_PERIOD*2;
        
        go_m1 <= '0';
        go_m2 <= '0';
        
        wait until done_m1 = '1' or done_m2 = '1';
        
        --masters with different data
        --here master 1 should take the lead because is address MSB is '0'
        data_in_m1 <= x"aa";
        data_in_m2 <= x"55";
        address_m1 <= "0111111";
        address_m2 <= "1111111";
        rw_m1 <= '0';
        rw_m2 <= '0';
        go_m1 <= '1';
        go_m2 <= '1';
        
        wait for SCL_PERIOD*2;
        
        go_m1 <= '0';
        go_m2 <= '0';
        
        wait until done_m1 = '1' or done_m2 = '1';
        
        -----------------------------
        --       master read      --
        -----------------------------
        --single read
        data_in_s <= x"55";
        address_m1 <= "1111111";
        address_m2 <= "1111111";
        rw_m1 <= '1';
        rw_m2 <= '1';
        go_m1 <= '1';
        go_m2 <= '1';
        last_byte_m1 <= '1';
        last_byte_m2 <= '1';
        
        wait for SCL_PERIOD*2;
        
        go_m1 <= '0';
        go_m2 <= '0';
        
        wait until done_m1 = '1' or done_m2 = '1';
        
        --read 3 bytes
        for i in 0 to 2 loop
            rw_m1 <= '1';
            rw_m2 <= '1';
            go_m1 <= '1';
            go_m2 <= '1';
            data_in_s <= data_in_s(6 downto 0)&'0';
            wait for SCL_PERIOD;
            if i = 2 then last_byte_m1 <= '1'; last_byte_m2 <= '1'; else last_byte_m1 <= '0'; last_byte_m2 <= '0'; end if;
            wait for SCL_PERIOD*2;
            go_m1 <= '0';
            go_m2 <= '0';
            wait on data_out_m1;
        end loop;
        report "Test completed" severity note;
        wait;
    end process;
    
end Behavioral;
