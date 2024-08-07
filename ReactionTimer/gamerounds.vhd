library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gamerounds is
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
end gamerounds;

architecture logic of gamerounds is

 -- signal declarations 
    signal p1score : unsigned (1 downto 0) := (others => '0');
    signal p2score : unsigned (1 downto 0) := (others => '0'); 
    signal numberrounds : unsigned (2 downto 0) := (others => '0');
    signal win_state : UNSIGNED (0 downto 0);
    signal gamefinish : std_logic;
    signal roundsfinished: std_logic := '0'; -- Ensure proper initialization
	 
-- COMPONENTS  - - - - - - - - - - - - - - - - - - - - -  -
 

 component ReactionGame is
        PORT ( 
				 play        	: in std_logic;
				 soft_reset, next_round	: in std_logic;  
				 speed_select 	: in std_logic_vector (1 downto 0); 
				 CLOCK   		: in STD_LOGIC;
				 game_finish	: out std_logic; 
				 game_display	: out std_logic_vector (6 downto 0); 
				 win_state  	: out UNSIGNED (0 downto 0);
				 random_BCD 	: in std_logic_vector (3 downto 0)
);
    end component;

COMPONENT SegDecoder IS 
    PORT (
        D : in std_logic_vector (3 downto 0); 
        Y : out std_logic_vector (6 downto 0)
    ); 
END COMPONENT;


	 
	 
-- PORT MAPS - - - - - -
begin
  
    U1: ReactionGame 
        port map(
            play           => play,
            soft_reset     => softreset, 
            speed_select   => speed, 
				next_round     => nextround,
            CLOCK          => CLOCK,
            game_finish    => gamefinish,
            game_display   => gamedisplay,
            win_state      => win_state,
				random_BCD 	   => random_BCD 
        );
		  
	B1: SegDecoder 
		port map ( 
			D => random_BCD,
			Y => SEG3
			);
			
			
-- LOGIC 




process (CLOCK, hardreset)
begin
    if hardreset = '0' then
        -- Reset all relevant signals
        numberrounds <= (others => '0');
        p1score <= (others => '0');
        p2score <= (others => '0');
        roundsfinished <= '0';
        gameoff <= '0';
        results <= "00"; -- Initialize results to "00" when resetting
    elsif rising_edge(CLOCK) then
        if gamefinish = '1' then
            if nextround = '0' then
                -- Update number of rounds
                numberrounds <= numberrounds + 1;
                
                -- Determine which player's score to update based on numberrounds
                case numberrounds is
                    when "000" | "010" | "100" =>
                        p1score <= p1score + win_state;
                    when "001" | "011" |"101" =>
                        p2score <= p2score + win_state;
                    if numberrounds = "101" then
                        roundsfinished <= '1';
						  end if;
                    when others =>
                        roundsfinished <= '1';
                end case;
            end if;
        end if;

        -- Check if the game is finished and update results accordingly
        if roundsfinished = '1' then
            if p1score > p2score then
                results <= "01"; -- p1 wins
                gameoff <= '1';
            elsif p2score > p1score then
                results <= "10"; -- p2 wins
                gameoff <= '1';
            elsif p1score = p2score then
                results <= "11"; -- tie
                gameoff <= '1';
            end if;
        end if;
    end if;
end process;

	 
	 
	process (numberrounds) 
	begin 
		case numberrounds is 
			when "000" =>
				 SEG7 <= "0001100";
             SEG6 <= "1111001";
             SEG5 <= "1001110";
             SEG4 <= "1111001";
				 
					
			when "001" =>
			    SEG7 <= "0001100";
             SEG6 <= "0100100";
             SEG5 <= "1001110";
             SEG4 <= "1111001";
			when "010" =>
			    SEG7 <= "0001100";
             SEG6 <= "1111001";
             SEG5 <= "1001110";
             SEG4 <= "0100100";
			when "011" =>
			    SEG7 <= "0001100";
             SEG6 <= "0100100";
             SEG5 <= "1001110";
             SEG4 <= "0100100";
			when "100" =>
			    SEG7 <= "0001100";
             SEG6 <= "1111001";
             SEG5 <= "1001110";
             SEG4 <= "0110000";
			when "101" =>
			    SEG7 <= "0001100";
             SEG6 <= "0100100";
             SEG5 <= "1001110";
             SEG4 <= "0110000";
		   when others =>
			    SEG7 <= "1111111";
             SEG6 <= "1111111";
             SEG5 <= "1111111";
             SEG4 <= "1111111"; 
	      end case;
end process;			
end logic;
