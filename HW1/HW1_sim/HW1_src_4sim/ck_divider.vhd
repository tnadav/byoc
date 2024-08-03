-- This module divide the input clock using a 26 bit counter  
--  CK_out freq = CK_in freq / 2^26
--  2^26 = 32M = 67,108,864
--
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity  ck_divider is
		Port 		( 	CK_in	:	in		STD_LOGIC;
						clr		: 	in  	STD_LOGIC;
						CK_out	: 	out  	STD_LOGIC);
end  ck_divider;

-- signal cntr: STD_LOGIC_VECTOR(31 downto 0);

architecture divider of  ck_divider  is
signal cntr : STD_LOGIC_VECTOR(25 downto 0);
	begin
		process(CK_in, clr)
		begin
			if clr = '1' then
				cntr <= b"00" & X"000000";
			elsif CK_in 'event and CK_in = '1' then
				cntr <= cntr + 1;
			end if;
		end process;
		
		CK_out <=cntr(24) ;
		
end divider ;
