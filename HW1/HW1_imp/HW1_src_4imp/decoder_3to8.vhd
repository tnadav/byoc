---------------------------------------------------------------------
-- This is a 3->8 binary decoder
-- 
--
---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


	
entity decoder_3to8 is
    Port (  in_no 	 : in   STD_LOGIC_VECTOR (2 downto 0);
            out_lines : out  STD_LOGIC_VECTOR (7 downto 0));
end  decoder_3to8;

architecture Behavioral of decoder_3to8 is

begin
	with in_no  select 
		out_lines  <=
		"11111110"  when  b"000",
		"11111101"  when  b"001",
		"11111011"  when  b"010",
		"11110111"  when  b"011",
		"11101111"  when  b"100",
		"11011111"  when  b"101",
		"10111111"  when  b"110",
		"01111111"  when  others;

end  Behavioral;



