library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity StateSelect is
    port (
        level   : in std_logic;
		  game_start , reset : in std_logic;
		  state_seg7    : out std_logic_vector(6 downto 0);
		  speed   : out std_logic_vector(1 downto 0);
		  state_seg6    : out std_logic_vector(6 downto 0)
    );
end StateSelect;

architecture logic of StateSelect is
    type State_Type is (Choosing, Easy, Medium, Hard);
    signal current_state : State_Type;
    signal counter : std_logic_vector(1 downto 0) := "01"; 
	 
begin	 
    process (level)
    begin
	  if reset = '0' then
            counter <= "01";
        elsif rising_edge(level) then
            counter <= counter + 1;
        end if;
    end process;

    -- State determination based on counter value
    process (counter)
    begin
        case counter is
            when "01" =>
                current_state <= Easy;
					 
            when "10" =>
                current_state <= Medium;
					 
            when "11" =>
                current_state <= Hard;
				
            when others =>
                current_state <= Easy;
		  	
        end case;
    end process;

    -- State to output mapping and LED assignment
   process (current_state, game_start)
    begin
        if game_start = '0' then
            case current_state is
                when Easy =>
                    speed <= "01";
                    state_seg7 <= "1000111";  
                    state_seg6 <= "1111001";  
                when Medium =>
                    speed <= "10";
                    state_seg7 <= "1000111";  
                    state_seg6 <= "0100100";  
                when Hard =>
                    speed <= "11";
                    state_seg7 <= "1000111";  
                    state_seg6 <= "0110000";  	 
					 
            when others =>
					 state_seg7 <= "1000111";  
                state_seg6 <= "1111001";

	     end case;
        end if;
    end process;

end logic;
