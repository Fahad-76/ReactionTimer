
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity D_flipflop IS

PORT (D, clk 	:	IN STD_LOGIC;
		Q			:	OUT STD_LOGIC);
	
END D_flipflop;

ARCHITECTURE logic of D_flipflop IS	

BEGIN
	PROCESS (clk)
	BEGIN 
		IF clk 'EVENT and clk = '1'
		THEN Q <= D;
	END IF; 
	END PROCESS; 	
	
END logic; 
