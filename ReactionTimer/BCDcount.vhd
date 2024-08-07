
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY BCDCount is 

Port ( 
	clear 	: IN STD_LOGIC; 
	enable	: IN STD_LOGIC;
	clock		: IN STD_LOGIC; 
	BCD0		: BUFFER  STD_LOGIC_VECTOR (3 downto 0)
	);
	
END BCDCount;

ARCHITECTURE logic of BCDCount is
		signal L : STD_LOGIC_VECTOR (1 downto 0);
		signal S : STD_LOGIC_VECTOR (1 downto 0);

	
COMPONENT Count4 IS 
	
	PORT ( 
    load    : IN     STD_LOGIC; 
    D       : IN     STD_LOGIC_VECTOR (3 downto 0); 
    enable  : IN     STD_LOGIC;
    clock   : IN     STD_LOGIC; 
    Q       : BUFFER  STD_LOGIC_VECTOR (3 downto 0) ); 

	END COMPONENT; 
	
	BEGIN 
	L(0) <= clear or S(0); 
	S(0) <= BCD0(0) AND BCD0(3); 
	
	
	BCD_0: Count4 PORT MAP (L(0),"0000",enable, clock, BCD0);

	END logic ;