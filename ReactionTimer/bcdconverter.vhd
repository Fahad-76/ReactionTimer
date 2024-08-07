
Library IEEE; 
Use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

Entity bcdconverter IS 
Port (
	D : in unsigned (1 downto 0); 
	Y : out std_logic_vector (6 downto 0)
); 

END ENTITY bcdconverter; 

Architecture Logic of bcdconverter IS 
Begin 

with D select 
	Y <= "1000000" when "00",
		  "1111001" when "01",
		  "0100100" when "10",
		  "0000000" when "11";
END Architecture Logic; 