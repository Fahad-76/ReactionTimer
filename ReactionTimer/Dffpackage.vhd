
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

PACKAGE Dflipflop_package is 

COMPONENT D_flipflop 

	PORT (D, clk 	:	IN STD_LOGIC;
		Q			:	OUT STD_LOGIC);
	
END component;
END Dflipflop_package;