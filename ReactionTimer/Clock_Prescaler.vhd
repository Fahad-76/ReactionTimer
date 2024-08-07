LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Clock_Prescaler IS
    PORT (
        Clkin   		: IN  STD_LOGIC; 
        Clkout 		: OUT UNSIGNED (25 DOWNTO 0); 
        reset   		: IN STD_LOGIC  -- Reset signal to initialize counter
    );
END Clock_Prescaler; 

ARCHITECTURE logic OF Clock_Prescaler IS 
    SIGNAL count : UNSIGNED (25 DOWNTO 0) := (OTHERS => '0');
   -- SIGNAL clk_temp : STD_LOGIC;  -- Temporary signal for intermediate value
BEGIN

    PROCESS (Clkin, reset)
    BEGIN
        IF reset = '1' THEN
            count <= (OTHERS => '0');  -- Reset counter
        ELSIF rising_edge(Clkin) THEN
            count <= count + 1;
        END IF;
    END PROCESS;    

    Clkout <= count;  -- Assign the temporary signal to output

END logic;
