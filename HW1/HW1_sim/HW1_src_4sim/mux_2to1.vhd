----------------------------------------------------------------------------------
-- This is a 2->1 multiplexor
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


	
entity mux_2to1 is
    Port ( in0 	 		: in   STD_LOGIC;
		   in1 	 		: in   STD_LOGIC;
		   sel 	 		: in   STD_LOGIC;
           out_y			: out  STD_LOGIC);
end mux_2to1;

architecture Behavioral of mux_2to1 is

begin
	with sel  select 
		out_y  <=
		in0 when '0',
		in1 when others;

end Behavioral;



