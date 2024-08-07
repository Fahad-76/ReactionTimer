
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.mux2to1_package.all; 
USE work.Dflipflop_package.all; 

Entity Count4 IS 
PORT ( 
    load    : IN     STD_LOGIC; 
    D       : IN     STD_LOGIC_VECTOR (3 downto 0); 
    enable  : IN     STD_LOGIC;
    clock   : IN     STD_LOGIC; 
    Q       : BUFFER  STD_LOGIC_VECTOR (3 downto 0)
); 
END Count4;

ARCHITECTURE logic OF Count4 IS 

    SIGNAL E : std_logic_vector (2 downto 0); 
    SIGNAL S : std_logic_vector (3 downto 0); 
    SIGNAL M : std_logic_vector (3 downto 0); 

BEGIN 

  
    E(0) <= enable AND Q(0);
	 S(0) <= Q(0) XOR enable;

	 
	 gen_E: FOR i IN 1 TO 2 GENERATE
        E(i) <= Q(i) AND E(i-1) ;
    END GENERATE gen_E;
    
	 
    gen_S: FOR i IN 1 TO 3 GENERATE
        S(i) <= Q(i) XOR E(i-1) ;
    END GENERATE gen_S;

    
    gen_MUX: FOR i IN 0 TO 3 GENERATE
        MUX2to1_inst: MUX2to1 PORT MAP (S(i), D(i), load, M(i));
    END GENERATE gen_MUX;

    
    gen_FF: FOR i IN 0 TO 3 GENERATE
        D_flipflop_inst: D_flipflop PORT MAP (M(i), clock, Q(i));
    END GENERATE gen_FF;

END logic; 
