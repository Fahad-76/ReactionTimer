LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY debouncer_test IS
PORT (   
		CLOCK_50		:	IN STD_LOGIC; 
		KEY			:	IN STD_LOGIC_VECTOR (2 downto 0);
		LEDG			: 	OUT STD_LOGIC_VECTOR (2 downto 0);
		SW				: 	IN STD_LOGIC_VECTOR (1 downto 0)
		);

END debouncer_test;

ARCHITECTURE logic OF debouncer_test is 
-- -	-	-	-	-	-	SIGNALS	-	-	-	-	-	-	-	-

SIGNAL button : std_logic;


-- -	-	-	-	-	-	COMPONENTS	-	-	-	-	-	-	-	-
COMPONENT StateSelect is
    port (
        clock : in std_logic;
        LEDG : out std_logic_vector(2 downto 0)
    );
END COMPONENT;

COMPONENT Debouncer IS
PORT (   
		Clock		:	IN STD_LOGIC; 
		button 	:	IN STD_LOGIC;
		output 	: 	OUT STD_LOGIC
);

END COMPONENT;
-- -	-	-	-	-	-	COMPONENTS	-	-	-	-	-	-	-	-
BEGIN

U1: Debouncer PORT MAP (CLOCK_50, KEY(0), button); 
U2: StateSelect PORT MAP (button, LEDG (2 downto 0));

END logic;