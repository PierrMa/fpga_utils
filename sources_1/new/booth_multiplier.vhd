library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_multiplier is
  generic(N : integer := 4);  -- N-bit multiplicand and multiplier
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    start : in  std_logic;
    a     : in  std_logic_vector(N-1 downto 0);  -- Multiplicand
    b     : in  std_logic_vector(N-1 downto 0);  -- Multiplier
    s     : out std_logic_vector(2*N-1 downto 0);-- Product
    ready : out std_logic
  );
end booth_multiplier;

architecture Behavioral of booth_multiplier is

  type state_type is (IDLE, INIT, ANALYZE, ADD, SUB, SHIFT, CHECK, DONE);
  signal state : state_type := IDLE;

  signal M : std_logic_vector(N-1 downto 0);  -- Multiplicand
  signal Q     : std_logic_vector(N-1 downto 0);  -- Multiplier
  signal Acc     : std_logic_vector(N-1 downto 0) := (others => '0');  -- Accumulator (N+1 bits)
  signal Q_1   : std_logic := '0';  -- Q-1 (Booth algorithm)
  signal count : integer range 0 to N := 0;
  
begin

  process(clk, rst)
  begin
    if rst = '1' then
      state  <= IDLE;
      Acc      <= (others => '0');
      Q      <= (others => '0');
      M      <= (others => '0');
      Q_1    <= '0';
      count  <= 0;
      ready  <= '0';
      s      <= (others => '0');

    elsif rising_edge(clk) then
      case state is
        when IDLE =>
          ready <= '1';
          if start = '1' then
            state <= INIT;
            ready <= '0';
          end if;

        when INIT =>
          M     <= a;
          Q     <= b;
          Acc     <= (others => '0');
          Q_1   <= '0';
          count <= N;
          state <= ANALYZE;

        when ANALYZE =>
          if (Q(0) = '1' and Q_1 = '0') then
            state <= SUB;
          elsif (Q(0) = '0' and Q_1 = '1') then
            state <= ADD;
          else
            state <= SHIFT;
          end if;

        when ADD =>
          Acc <= std_logic_vector(signed(Acc) + signed(M));
          state <= SHIFT;

        when SUB =>
          Acc <= std_logic_vector(signed(Acc) - signed(M));
          state <= SHIFT;

        when SHIFT =>
          Q_1 <= Q(0);
          Q   <= Acc(0) & Q(N-1 downto 1);  -- Shift right Q with Acc(0)
          Acc   <= Acc(N-1) & Acc(N-1 downto 1);  -- Arithmetic shift right A
          count <= count - 1;
          state <= CHECK;

        when CHECK =>
          if count = 0 then
            state <= DONE;
          else
            state <= ANALYZE;
          end if;

        when DONE =>
          s <= Acc & Q; -- Concatenate final Acc and Q
          ready <= '1';
          state <= IDLE;

        when others =>
          state <= IDLE;

      end case;
    end if;
  end process;

end Behavioral;
