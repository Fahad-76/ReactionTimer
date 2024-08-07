
LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

PACKAGE mux2to1_package is 

COMPONENT MUX2to1 

	PORT (
		w0,w1,s 	: IN STD_LOGIC; 
		f			:	OUT STD_LOGIC);
	END COMPONENT; 
END MUX2to1_package; 