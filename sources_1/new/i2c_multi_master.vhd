----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2025 16:05:42
-- Design Name: 
-- Module Name: i2c_multi_master - Behavioral
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

entity i2c_multi_master is
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
end i2c_multi_master;

architecture Behavioral of i2c_multi_master is

function process_half_bit_rate(
    f : in integer; 
    i2c_rate : in integer
) return integer is variable half_bit_rate: integer;
begin
    return f/(2*i2c_rate);
end function;

constant HALF_PERIOD : integer := process_half_bit_rate(F_CLK,BAUD);

type fsm_t is (IDLE,START1,START2,ADDR1,ADDR2,ACK_ADDR1,ACK_ADDR2,READ1,READ2,ACK_R1,ACK_R2,WRITE1,WRITE2,ACK_W1,ACK_W2,STOP1,STOP2,CLEAN,LOST_ARB);
signal state : fsm_t;
signal data : std_logic_vector(7 downto 0);
signal addr_rw : std_logic_vector(7 downto 0);
signal clk_count : integer range 0 to HALF_PERIOD := 0;
signal index : integer range 0 to 7;
signal scl_tick : std_logic := '0';
signal sda_buf : std_logic :='1';
signal prev_sda : std_logic := '1';
signal prev_scl : std_logic;

begin
    
    --generate a clk of period BAUD
    process(clk,rst)
    begin
        if rst='1' then 
            scl_tick <= '0';
            clk_count <= 0;
        elsif rising_edge(clk) then
            if clk_count = HALF_PERIOD then
                scl_tick <= '1';
                clk_count <= 0;
            elsif clk_count < HALF_PERIOD then
                scl_tick <= '0';
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;
    
    process(clk,rst,state,scl_tick,last_byte)
    begin
        if rst = '1' then 
            state <= IDLE;
            data <= (others =>'0');
            addr_rw <= (others =>'0');
            index <= 7;
            sda_dir <= '0';
            data_out <= (others =>'0');
            sda_buf <= '1';
            scl_out <= '1';
            done <= '0';
            lost_arbitration <= '0';
            slave_nack <= '0';
            
        elsif rising_edge(clk) then
            if scl_tick = '1' then
                case(state) is
                when IDLE =>
                    index <= 7;
                    sda_dir <= '0';
                    scl_out <= '1';
                    sda_buf <= '1'; --the resting state of SDA is '1'
                    done <= '0';
                    lost_arbitration <= '0';
                    
                    if go = '1' then
                        data <= data_in;
                        addr_rw <= address&rw;
                        state <= START1;
                    else 
                        state <= IDLE;
                    end if;
                
                when START1 =>
                    sda_dir <= '1';
                    scl_out <= '1';
                    sda_buf <= '1';
                    state <= START2;
                    
                when START2 =>
                    if sda_in = '0' then --another master is using the line
                        prev_scl <= scl_in;
                        lost_arbitration <= '1';
                        state <= LOST_ARB;
                    else 
                        scl_out <= '1';
                        sda_buf <= '0';
                        index <= 7;
                        state <= ADDR1;
                    end if;
                    
                when ADDR1 =>
                    scl_out <= '0';
                    sda_buf <= addr_rw(index);
                    state <= ADDR2;
                    
                when ADDR2 =>
                    if sda_in = '0' and sda_buf = '1' then --another master is using the line
                        prev_scl <= scl_in;
                        lost_arbitration <= '1';
                        state <= LOST_ARB;
                    else
                        scl_out <= '1';
                        if index = 0 then
                            index <= 7;
                            state <= ACK_ADDR1;
                        elsif index > 0 then
                            index <= index - 1;
                            state <= ADDR1;
                        end if;
                    end if;
                
                when ACK_ADDR1 =>
                    sda_dir <= '0';
                    scl_out <= '0';
                    state <= ACK_ADDR2;
                    
                when ACK_ADDR2 =>
                    scl_out <= '1';
                    if sda_in = '0' then --SLAVE ACK
                        index <= 7;
                        if rw = '1' then
                            state <= READ1;
                        else 
                            state <= WRITE1;
                        end if;
                    else --SLAVE NACK
                        state <= STOP1;
                    end if;
                    
                when READ1 =>
                    sda_dir <= '0';
                    scl_out <= '0';
                    state <= READ2;
                
                when READ2 =>
                    scl_out <= '1';
                    data(index) <= sda_in;
                    if index = 0 then
                        index <= 7;
                        state <= ACK_R1;
                    elsif index > 0 then
                        index <= index - 1;
                        state <= READ1;
                    end if;
                
                when ACK_R1 =>
                    data_out <= data;
                    sda_dir <= '1';
                    scl_out <= '0';
                    state <= ACK_R2;
                    if last_byte = '1' then
                        sda_buf <= '1'; --master NACK
                    else
                        sda_buf <= '0'; --master ACK
                    end if;
                
                when ACK_R2 =>
                    if sda_in = '0' and sda_buf = '1' then --another master is using the line
                        prev_scl <= scl_in;
                        lost_arbitration <= '1';
                        state <= LOST_ARB;
                    else
                        scl_out <= '1';
                        if last_byte = '1' then
                            state <= STOP1;
                        else
                            sda_dir <= '0';
                            state <= READ1;
                        end if;
                    end if;
                
                when WRITE1 =>
                    sda_dir <= '1';
                    scl_out <= '0';
                    sda_buf <= data(index);
                    state <= WRITE2;
                
                when WRITE2 =>
                    if sda_in = '0' and sda_buf = '1' then --another master is using the line
                        prev_scl <= scl_in;
                        lost_arbitration <= '1';
                        state <= LOST_ARB;
                    else
                        scl_out <= '1';
                        if index = 0 then
                            index <= 7;
                            state <= ACK_W1;
                        elsif index > 0 then
                            index <= index-1;
                            state <= WRITE1;
                        end if;
                    end if;
                    
                when ACK_W1 =>
                    sda_dir <= '0';
                    scl_out <= '0';
                    state <= ACK_W2;
                
                when ACK_W2 =>
                    scl_out <= '1';
                    state <= STOP1;
                    if sda_in = '1' then
                        slave_nack <= '1';
                    else
                        slave_nack <= '0';
                    end if;
                    
                when STOP1 =>
                    sda_dir <= '1';
                    scl_out <= '1';
                    sda_buf <= '0';
                    slave_nack <= '0';
                    state <= STOP2;
                
                when STOP2 =>
                    scl_out <= '1';
                    sda_buf <= '1';
                    state <= CLEAN;
                    
                when CLEAN =>
                    if sda_in = '0' then --another master is using the line
                        prev_scl <= scl_in;
                        lost_arbitration <= '1';
                        state <= LOST_ARB;
                    else
                        done <= '1';
                        state <= IDLE;
                    end if;
                
                when LOST_ARB =>
                    sda_buf <= '1';
                    scl_out <= '1';
                    prev_scl <= scl_in;
                    prev_sda <= sda_in;
                    if scl_in = '1' and sda_in = '1' and prev_scl = '1' and prev_sda = '0' then
                        state <= IDLE;
                    end if;
                end case;
            end if;
        end if;
    end process;

    sda_out <= sda_buf;
end Behavioral;
