-- This is a 7 bit binary counter  
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity counter_7bits is
		Port 		( 	CK_in	:	in		STD_LOGIC;
						clr		: 	in  	STD_LOGIC;
						cntr_out	: 	out  	STD_LOGIC_VECTOR (6 downto 0));
end counter_7bits;

-- signal cntr: STD_LOGIC_VECTOR(31 downto 0);

architecture counter of counter_7bits is
signal cntr: STD_LOGIC_VECTOR(6 downto 0);
	begin
		process(CK_in, clr)
		begin
			if clr = "1" then
				cntr <= b"000000";
			elsif CK_in 'event and CK_in = '1' then
				cntr <= cntr + 1;
			end if;
		end process;
		
		cntr_out <=cntr(6 downto 0);
		
end counter;
