library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity winnerscreen is
    port(
        CLOCK   : in std_logic; 
        reset   : in std_logic;
        result  : in std_logic_vector(1 downto 0); 
        Seg0    : out std_logic_vector(6 downto 0);
        Seg1    : out std_logic_vector(6 downto 0);
        Seg2    : out std_logic_vector(6 downto 0);
        Seg3    : out std_logic_vector(6 downto 0);
        Seg4    : out std_logic_vector(6 downto 0);
        Seg5    : out std_logic_vector(6 downto 0);
        Seg6    : out std_logic_vector(6 downto 0);
        RedL    : out std_logic_vector(17 downto 0);
        GreenL  : out std_logic_vector(7 downto 0);
        Seg7    : out std_logic_vector(6 downto 0)
    );
end winnerscreen;

architecture logic of winnerscreen is

    -- Define states
    type State_Type is (Default, P1win, P2win, TIE);
    signal current_state : State_Type;

begin

    -- State transition logic
    process(CLOCK, reset)
    begin
        if reset = '0' then
            current_state <= Default; -- Reset to Default state
        elsif rising_edge(CLOCK) then
            case result is
                when "00" =>
                    current_state <= Default;
                when "01" =>
                    current_state <= P1win;
                when "10" =>
                    current_state <= P2win;
                when "11" =>
                    current_state <= TIE;
                when others =>
                    current_state <= Default;
            end case;
        end if;
    end process;

    -- Display logic based on the current state
    process(current_state)
    begin
        case current_state is
            when Default =>
                Seg7 <= "1111111";
                Seg6 <= "1111111"; 
                Seg5 <= "1111111";
                Seg4 <= "1111111";
                Seg3 <= "1111111";
                Seg2 <= "1111111";
                Seg1 <= "1111111";
                Seg0 <= "1111111"; 
                RedL <= (others => '0');
                GreenL <= (others => '0');

            when P1win =>
                Seg7 <= "1111111";
                Seg6 <= "1111111"; 
                Seg5 <= "0001100"; -- Custom pattern for P1win
                Seg4 <= "1111001";
                Seg3 <= "1000001";
                Seg2 <= "1000001";
                Seg1 <= "1111001";
                Seg0 <= "1001000";
                RedL <= (others => '1');
                GreenL <= (others => '1');

            when P2win =>
                Seg7 <= "1111111";
                Seg6 <= "1111111"; 
                Seg5 <= "0001100"; -- Custom pattern for P2win
                Seg4 <= "0100100";
                Seg3 <= "1000001";
                Seg2 <= "1000001";
                Seg1 <= "1111001";
                Seg0 <= "1001000";
                RedL <= (others => '1');
                GreenL <= (others => '1');

            when TIE =>
                Seg7 <= "1111111";
                Seg6 <= "1111111"; 
                Seg5 <= "1111111";
                Seg4 <= "1111111";
                Seg3 <= "1111111";
                Seg2 <= "0000111"; -- Custom pattern for TIE
                Seg1 <= "1001111";
                Seg0 <= "0000110"; 
                RedL <= (others => '1');
                GreenL <= (others => '1');

            when others =>
                Seg7 <= "1111111";
                Seg6 <= "1111111";  
                Seg5 <= "1111111";
                Seg4 <= "1111111";
                Seg3 <= "1111111";
                Seg2 <= "1111111";
                Seg1 <= "1111111";
                Seg0 <= "1111111"; 
                RedL <= (others => '0');
                GreenL <= (others => '0');
        end case;
    end process;

end logic;
