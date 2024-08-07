library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity Declaration
entity gameplay is
    Port (
			 clock_50 : in std_logic;
			 SW       : in std_logic_vector(2 downto 2);
			 KEY      : in std_logic_vector(3 downto 0);
			 
			 HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0) ;
			 LEDG : out std_logic_vector(7 downto 0);
			 LEDR : out std_logic_vector(17 downto 0)
    );
end gameplay;



-- Architecture Declaration 
architecture Behavioral of gameplay is



-- COMPONENTS -- - - - - - - - - - -  - - - - - -  - -

COMPONENT gamerounds IS
port(
        CLOCK 			: in  std_logic;
		  play 			: in std_logic; 
        nextround 	: in std_logic;
        speed 			: in std_logic_vector(1 downto 0);
        softreset  	: in std_logic;
        hardreset 	: in std_logic;
        gamedisplay 	: out std_logic_vector(6 downto 0);
        results 		: out std_logic_vector(1 downto 0) := "00";
        gameoff 		: out std_logic := '0';
		  random_BCD 	: in std_logic_vector (3 downto 0); 
		  SEG7, SEG6, SEG5, SEG4, SEG3			: out std_logic_vector (6 downto 0)
		  
    );
END COMPONENT;

COMPONENT StateSelect is
    port (
        level   				: in std_logic;
		  game_start , reset : in std_logic;
		  state_seg7    			: out std_logic_vector(6 downto 0);
		  speed   				: out std_logic_vector(1 downto 0);
		  state_seg6		      : out std_logic_vector(6 downto 0)
    );
end COMPONENT;

COMPONENT winnerscreen is
port(
	CLOCK 	: in std_logic; 
	reset    : in std_logic;
	result 	: in std_logic_vector (1 downto 0); 
	Seg0 		: out std_logic_vector(6 downto 0);
	Seg1 		: out std_logic_vector(6 downto 0);
	Seg2 		: out std_logic_vector(6 downto 0);
	Seg3 		: out std_logic_vector(6 downto 0);
	Seg4 		: out std_logic_vector(6 downto 0);
	Seg5 		: out std_logic_vector(6 downto 0);
	Seg6 		: out std_logic_vector(6 downto 0);
	RedL     : out std_logic_vector(17 downto 0);
	GreenL   : out std_logic_vector(7 downto 0);
	Seg7 		: out std_logic_vector(6 downto 0)
	
 );
end COMPONENT;

COMPONENT Debouncer IS
PORT (   
		Clock		:	IN STD_LOGIC; 
		button 	:	IN STD_LOGIC;
		output 	: 	OUT STD_LOGIC
);
end component;

COMPONENT BCDCount IS
    PORT ( 
        clear   : IN STD_LOGIC; 
        enable  : IN STD_LOGIC;
        clock   : IN STD_LOGIC; 
        BCD0    : BUFFER  STD_LOGIC_VECTOR (3 downto 0)
    );
END COMPONENT;

-- - - - - - - - - - - - - - - - - - - - - - - - - -
    -- State type declaration
    type state_type is (Difficulty_Pick, Game_Rounds, Winner_Screen);
    
	 -- signal declarations 
	 
	 SIGNAL random_BCD	          : std_logic_vector(3 downto 0);
	 
	 -- DEFAULT SIGNALS----
	 SIGNAL default_hex            : std_logic_vector(6 downto 0);
	 SIGNAL DEFAULT_LEDR                   : std_logic_vector(17 downto 0);
	 SIGNAL DEFAULT_LEDG                   : std_logic_vector(7 downto 0);
	 
	 
	 signal k_trigger 	 	: std_logic; 
	 signal k_hardreset		: std_logic;
	-- signal SW_start	 		: std_logic;
	 signal k_softreset		: std_logic; 
	 signal k_nextround		: std_logic; 
	 
	 -- - - - - - - - - - - - -- - - - - - - - - - -
	 
	 signal current_state, next_state : state_type;
	 signal game_enable, game_off : std_logic; 
	 
	 
	 -- state select
	 SIGNAL level   						: std_logic;
	 SIGNAL game_start , reset 		: std_logic;
	 SIGNAL state_seg7    				: std_logic_vector(6 downto 0);
	 SIGNAL speed   						: std_logic_vector(1 downto 0);
	 SIGNAL state_seg6		      	: std_logic_vector(6 downto 0);
	 
	 -- gamerounds 
	 SIGNAL	CLOCK 		:  std_logic;
    SIGNAL 	nextround 	:  std_logic;
	 SIGNAL  play			:  std_logic; 
	 SIGNAL game_seg7		      	: std_logic_vector(6 downto 0);
	 SIGNAL game_seg6		      	: std_logic_vector(6 downto 0);
	 SIGNAL game_seg5		      	: std_logic_vector(6 downto 0);
	 SIGNAL game_seg4		      	: std_logic_vector(6 downto 0);
	 SIGNAL game_seg3		      	: std_logic_vector(6 downto 0);
    --SIGNAL  speed 		:  std_logic_vector(1 downto 0);
    SIGNAL 	softreset  	:  std_logic;
    SIGNAL 	hardreset 	:  std_logic;
    SIGNAL 	gamedisplay :  std_logic_vector(6 downto 0);
    SIGNAL 	results 		:  std_logic_vector(1 downto 0);
    SIGNAL 	gameoff 		:  std_logic ;

	 -- winnerscreen signals
	 SIGNAL winner_reset  	         : std_logic;
	 SIGNAL winners_seg7		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg6		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg5		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg4		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg3		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg2		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg1		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_seg0		      	: std_logic_vector(6 downto 0);
	 SIGNAL winners_redL             : std_logic_vector(17 downto 0);
	 SIGNAL winners_greenL           : std_logic_vector(7 downto 0);
	 SIGNAL winners_result           : std_logic_vector(1 downto 0);
	 
begin
	

-- Default HEX displays - - - - - - - - -

default_hex <= "1111111" ;	 
DEFAULT_LEDG<= "00000000";
DEFAULT_LEDR<= "000000000000000000";
-- -- - - - - - - - - - - - - - - - - - - -
    
	 game_start 			<= SW(2);  -- acts as a hard reset
	 winners_result      <= results;

-- PORT MAPS -- - - - - - - - - - - - - - - - - - -

-- random generator 

B1: BCDcount PORT MAP ('0', NOT game_Start, CLOCK_50, random_BCD);



-- debouncer - - - - - - - - - - - - - - -

D1: Debouncer PORT MAP (CLOCK_50, KEY(0), k_trigger); 
D2: Debouncer PORT MAP (CLOCK_50, KEY(1), k_softreset); 
D3: Debouncer PORT MAP (CLOCK_50, KEY(2), k_nextround); 


	 U1: StateSelect 
        port map(
            level           		=> level,
            game_start     		=> game_start, 
            reset			   		=> reset, 
            state_seg7         	=> state_seg7,
            speed		    			=> speed,
            state_seg6		   	=> state_seg6		
        );
		  
	 U2: gamerounds
			port map (
				CLOCK 			=> CLOCK_50 ,
				nextround 		=> k_nextround, 
				speed 			=> speed ,
				softreset 	   => softreset, 
				hardreset 	   => hardreset,
				gamedisplay    => gamedisplay,
				results 			=> results,
				gameoff 			=> gameoff, 
				play				=> play,
				SEG7           => game_seg7,
				SEG6           => game_seg6,
				SEG5           => game_seg5,
				SEG4           => game_seg4,
				SEG3           => game_seg3,
				random_BCD 	   => random_BCD
	  ); 
	  
	  U3: winnerscreen 
	       port map (
			    CLOCK        => CLOCK_50,
				 reset        => winner_reset,
				 result       => winners_result,
				 Seg0 		  => winners_seg0,
	          Seg1 	     => winners_seg1,
	          Seg2 		  => winners_seg2,
	          Seg3 		  => winners_seg3,
	          Seg4 		  => winners_seg4,
	          Seg5 	     => winners_seg5,
				 Seg6 		  => winners_seg6,
	          Seg7 	     => winners_seg7,
				 RedL         => winners_redL,
				 GreenL       => winners_greenL
				 );
				 

	 
    -- State Register
    process(CLOCK_50, game_enable)
    begin
        if game_start  = '0'  then
            current_state <= Difficulty_Pick; -- Initial state on game_enable 
        elsif rising_edge(CLOCK_50) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State Logic
    process(current_state,game_enable, game_off, next_state)
    begin
        case current_state is
            when Difficulty_Pick =>
					level 		<= k_trigger;   
					reset 		<= '1';
					HEX7 			<=state_seg7;
					HEX6 			<=state_seg6;
					HEX5        <=default_hex;
					HEX5        <=default_hex;
					HEX4        <=default_hex;
					HEX3        <=default_hex;
					HEX2        <=default_hex;
					HEX1        <=default_hex;
					HEX0        <=default_hex;
					LEDR        <=DEFAULT_LEDR;
					LEDG        <=DEFAULT_LEDG;
					winner_reset <= '0'; -- winner screen reset
					hardreset <= '0';--game rounds reset
					
					
					
                if game_start = '1' then
                    next_state <= Game_Rounds; -- Move to game rounds after difficulty selection
                else
                    next_state <= Difficulty_Pick;
                end if;

            when Game_Rounds =>
						
					 play <= k_trigger; 
					 softreset <= k_softreset;
					 hardreset <= '1';
					 HEX0	     <= gamedisplay;
					 HEX7 	  <= game_seg7;
					 HEX6 	  <= game_seg6;
					 HEX5 	  <= game_seg5;
					 HEX4 	  <= game_seg4;
					 HEX3 	  <= game_seg3; 
						
                if gameoff = '1' then
                    next_state <= Winner_Screen; -- Transition to winner screen if win condition met
						  
					 else
                    next_state <= Game_Rounds;
                end if;

            when Winner_Screen =>
                if game_start  = '0' then
                    next_state <= Difficulty_Pick; -- Return to difficulty pick on game_enable 
                else
                    next_state <= Winner_Screen;
						  winner_reset <= '1';
						  HEX7	     <= winners_seg5;
					     HEX6 	     <= winners_seg4;
						  HEX5 	     <= winners_seg7;
					     HEX4 	     <= winners_seg6;
					     HEX3 	     <= winners_seg3;
					     HEX2 	     <= winners_seg2;
					     HEX1 	     <= winners_seg1;
						  HEX0 	     <= winners_seg0;
						  LEDR        <= winners_redL;
						  LEDG        <= winners_greenL;
                end if;
        end case;
    end process;
	 

end Behavioral;
