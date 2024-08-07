LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Debouncer IS
PORT (   
		Clock		:	IN STD_LOGIC; 
		button 	:	IN STD_LOGIC;
		output 	: 	OUT STD_LOGIC
);

END Debouncer;


Architecture logic of Debouncer IS 

SIGNAL ff : STD_LOGIC_VECTOR (1 downto 0); 
SIGNAL counter_reset : std_logic ; 
SIGNAL count : INTEGER RANGE 0 to 50000000/100:= 0; 

Begin

counter_reset <= ff(0) XOR ff(1) ; 

 

Process (Clock)
BEGIN
	If (Clock' EVENT and Clock ='1') THEN 
		
		ff(0) <= button;
		ff(1) <= ff(0);
		
		if (counter_reset = '1') THEN 
			count <= 0;
				
		elsif (count < 50000000/100 - 1) THEN
			count <= count + 1; 
		else 
			output <= ff(1); 
		END IF; 
	END IF; 
				
			
		
END PROCESS;
		
END logic;