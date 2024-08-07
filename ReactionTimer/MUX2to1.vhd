
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity MUX2to1 IS

PORT (
	w0,w1,s 	: IN STD_LOGIC; 
	f			:	OUT STD_LOGIC);
	
END MUX2to1; 

Architecture logic of MUX2to1 IS 
BEGIN 
	Process (w0,w1,s)
	BEGIN
		IF s = '0' THEN
			f <= w0; 
		ELSE 
			f <= w1; 
		END IF;
	END Process; 
End logic; 