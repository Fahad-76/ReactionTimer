LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--declare a testbench. Testbench Entity is always empty
ENTITY TB_ReactionGame IS
END TB_ReactionGame;

ARCHITECTURE Behaviour of TB_ReactionGame IS
	COMPONENT ReactionGame IS --the component or DEVICE UNDER TEST (DUT) we would like to verify
	Port ( 
		KEY 	: in std_logic_vector (1 downto 0); 
		LEDR 	:OUT std_logic_vector (0 downto 0); 
		SW	:	in std_logic_vector (0 downto 0) ;
		HEX0: out std_logic_vector (6 downto 0);
		CLOCK_50: IN STD_LOGIC
	);
	END COMPONENT;
	--for clock generation
	constant clk_hz : integer := 50e6; --f = 50 Mhz clock
	constant clk_period : time := 1 sec / clk_hz; --1/f = T = 20 ns period

	--DUT signals required
	SIGNAL tb_clock : std_logic := '1'; --DUT's clock input. Assign the clock a starting value for Modelsim
	SIGNAL tb_KEY0, tb_KEY1, tb_SW, tb_LEDR : STD_LOGIC;
	SIGNAL tb_HEX : STD_LOGIC_VECTOR(6 downto 0);
	
	BEGIN
	
	DUT : ReactionGame --declare the device under test (DUT) to be ReactionGame
	PORT MAP(KEY(0) => tb_KEY0, KEY(1) => tb_KEY1, SW(0) => tb_SW, LEDR(0) => tb_LEDR, HEX0 => tb_HEX, CLOCK_50 =>tb_clock); --map test signals to DUT
	
	stimulus : process
	BEGIN
	
	-- Inverts clock
	tb_clock <= NOT tb_clock after clk_period / 2;  
	-- -- -- -- -- -- -- 
	
	tb_SW <= '0' ;
	wait for 60 ns;

	
	tb_SW <= '1';
	wait for 100 ns; 
	
	tb_KEY0 <= '0';
	wait for 60 ns; 
	
	tb_KEY0 <= '1'; 
	wait for 60 ns; 
	
	assert false; 
	
		
	END process;
END Behaviour;
