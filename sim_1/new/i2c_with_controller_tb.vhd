----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2025 00:28:40
-- Design Name: 
-- Module Name: i2c_with_controller_tb - Behavioral
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

entity i2c_with_controller_tb is
end i2c_with_controller_tb;

architecture Behavioral of i2c_with_controller_tb is
--------------------------------------------
--
--          COMPONENTS
--
--------------------------------------------
component i2c_multi_master_with_controller is
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
    scl_out : out std_logic;
    sda : inout std_logic;
    sda_direction : out std_logic; --'1' for master output, '0' for master input
    go : in std_logic; --there is a data to write or to read
    done : out std_logic;
    last_byte : in std_logic;
    conflict: in std_logic;
    scl_in : in std_logic;
    aborted : out std_logic
);
end component;

component i2c_master_controller is
generic( NB_MASTER : integer := 4);
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
--          CONSTANTS
--
--------------------------------------------
constant BAUD : integer := 2; --i2c standard frequency (100kbit/s)
constant F_CLK : integer := 4;
constant CLK_PERIOD : time := 10ns;
constant SCL_PERIOD : time := 20ns; --(F_CLK/BAUD) * CLK_PERIOD
constant NB_MASTER : integer := 2;
--------------------------------------------
--
--          SIGNALS
--
--------------------------------------------
---------------i2c_master-------------------
signal clk1,clk2 : std_logic :='1';
signal rst1,rst2 : std_logic :='1';
signal data_in1,data_in2 : std_logic_vector(7 downto 0);
signal data_out1,data_out2 : std_logic_vector(7 downto 0);
signal address1,address2: std_logic_vector(6 downto 0);
signal rw1,rw2 : std_logic;
signal go1,go2 : std_logic;
signal done1,done2 : std_logic;
signal last_byte1,last_byte2 : std_logic := '1';
signal aborted1, aborted2 : std_logic;
---------------controller-------------------
signal sda_in : std_logic_vector(NB_MASTER-1 downto 0);
signal sda_dir : std_logic_vector(NB_MASTER-1 downto 0);
signal sda_dir_com : std_logic;
signal conflict : std_logic_vector(NB_MASTER-1 downto 0);
signal sda_com : std_logic;
signal scl_in_control : std_logic_vector(NB_MASTER-1 downto 0);
signal scl_out_control : std_logic_vector(NB_MASTER-1 downto 0);
signal scl_com : std_logic;
---------------i2c_slave-------------------
signal clk_s : std_logic :='1';
signal rst_s : std_logic :='1';
signal data_in_s : std_logic_vector(7 downto 0);
signal data_out_s : std_logic_vector(7 downto 0);
signal stop_error : std_logic;
---------------for simulation--------------
--signal done_com : std_logic_vector(NB_MASTER-1 downto 0);
--signal rw_com : std_logic_vector(NB_MASTER-1 downto 0);
--signal go_com : std_logic_vector(NB_MASTER-1 downto 0);
--signal data_in_m_com : std_logic_vector(NB_MASTER*8-1 downto 0);
--signal address_com : std_logic_vector(NB_MASTER*7-1 downto 0);
--------------------------------------------
--
--          PROCEDURES
--
--------------------------------------------
procedure write(
    constant data : in std_logic_vector(NB_MASTER*8-1 downto 0);
    constant addr : in std_logic_vector(NB_MASTER*7-1 downto 0);
    signal done : in std_logic_vector(NB_MASTER-1 downto 0);
    signal rw : out std_logic_vector(NB_MASTER-1 downto 0);
    signal go : out std_logic_vector(NB_MASTER-1 downto 0);
    signal data_in_m : out std_logic_vector(NB_MASTER*8-1 downto 0);
    signal address : out std_logic_vector(NB_MASTER*7-1 downto 0)
)is
    variable done_com : std_logic:='1';
begin
    rw <= (others => '0');
    go <= (others => '0');
    wait for CLK_PERIOD;
    --IDLE
    go <= (others => '1');
    data_in_m <= data;
    address <= addr;
    wait for SCL_PERIOD;
    --START1
    go <= (others => '0');
    
    for i in 0 to NB_MASTER-1 loop
        done_com := done_com and done(i);
    end loop;
    wait until done_com = '1';
end procedure;
--------------------------------------------
--
--          ARCHITECTURE BODY
--
--------------------------------------------
begin
    
    master_1 : i2c_multi_master_with_controller
    generic map(BAUD=>BAUD, F_CLK=>F_CLK)
    port map(
        clk => clk1,
        rst => rst1,
        data_in => data_in1,
        data_out => data_out1,
        address => address1,
        rw => rw1,
        scl_out => scl_in_control(0),
        sda => sda_in(0),
        sda_direction => sda_dir(0),
        go => go1,
        done => done1,
        last_byte => last_byte1,
        conflict => conflict(0),
        scl_in => scl_out_control(0),
        aborted => aborted1
    );
    
    master_2 : i2c_multi_master_with_controller
    generic map(BAUD=>BAUD, F_CLK=>F_CLK)
    port map(
        clk => clk2,
        rst => rst2,
        data_in => data_in2,
        data_out => data_out2,
        address => address2,
        rw => rw2,
        scl_out => scl_in_control(1),
        sda => sda_in(1),
        sda_direction => sda_dir(1),
        go => go2,
        done => done2,
        last_byte => last_byte2,
        conflict => conflict(1),
        scl_in => scl_out_control(1),
        aborted => aborted2
    );
    
    controller : i2c_master_controller
    generic map(NB_MASTER=>NB_MASTER)
    port map(
        sda => sda_in,
        sda_dir_in => sda_dir,
        sda_dir_com => sda_dir_com,
        conflict => conflict,
        sda_com => sda_com,
        scl_in => scl_in_control,
        scl_out => scl_out_control,
        scl_com => scl_com
    );
    
    slave : i2c_slave
    port map(
        clk => clk_s,
        rst => rst_s,
        scl => scl_com,
        sda => sda_com,
        sda_dir => sda_dir_com,
        data_in => data_in_s,
        data_out => data_out_s,
        stop_error => stop_error
    );
    
    --masters with different clocks
    clk1 <= not clk1 after 5ns;
    clk2 <= not clk2 after 5ns;
    clk_s <= not clk_s after 7.5ns;
    
    rst1 <= '0' after 10ns;
    rst2 <= '0' after 10ns;
    rst_s <= '0' after 15ns;
    
    process
    begin
        -----------------------------
        --       master write      --
        -----------------------------
        --masters with same data
        data_in1 <= x"aa";
        data_in2 <= x"aa";
        address1 <= "1111111";
        address2 <= "1111111";
        rw1 <= '0';
        rw2 <= '0';
        go1 <= '1';
        go2 <= '1';
        
        wait for SCL_PERIOD*2;
        
        go1 <= '0';
        go2 <= '0';
        
        wait until done1 = '1' or done2 = '1';
        
        --masters with different data
        --here master 1 should take the lead because is address MSB is '0'
        data_in1 <= x"aa";
        data_in2 <= x"55";
        address1 <= "0111111";
        address2 <= "1111111";
        rw1 <= '0';
        rw2 <= '0';
        go1 <= '1';
        go2 <= '1';
        
        wait for SCL_PERIOD*2;
        
        go1 <= '0';
        go2 <= '0';
        
        wait until done1 = '1' or done2 = '1';
        
        -----------------------------
        --       master read      --
        -----------------------------
        --single read
        data_in_s <= x"55";
        address1 <= "1111111";
        address2 <= "1111111";
        rw1 <= '1';
        rw2 <= '1';
        go1 <= '1';
        go2 <= '1';
        last_byte1 <= '1';
        last_byte2 <= '1';
        
        wait for SCL_PERIOD*2;
        
        go1 <= '0';
        go2 <= '0';
        
        wait until done1 = '1' or done2 = '1';
        
        --read 3 bytes
        for i in 0 to 2 loop
            rw1 <= '1';
            rw2 <= '1';
            go1 <= '1';
            go2 <= '1';
            data_in_s <= data_in_s(6 downto 0)&'0';
            wait for SCL_PERIOD;
            if i = 2 then last_byte1 <= '1'; last_byte2 <= '1'; else last_byte1 <= '0'; last_byte2 <= '0'; end if;
            wait for SCL_PERIOD*2;
            go1 <= '0';
            go2 <= '0';
            wait until sda_dir_com = '1';
        end loop;
        report "Test completed" severity note;
        wait;
    end process;
    
end Behavioral;
