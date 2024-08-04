---------------------------------------------------------------------------------
-- This is a seven segments decoder
-- 
-- It gets a 4 bit digit and determine which of the 7 segnments will be lit.
-- segment i is lit when  sevensed(i) is "0". It is off when sevensed(i) is "1".
-- Here is the segments arrangement:
--
--                 --0--
--                /    /
--               5    1
--              /    /
--             --6--
--            /    /
--           4    2
--          /    /
--          --3--
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity decoder_7seg is
    Port ( digit_data : in  STD_LOGIC_VECTOR (3 downto 0);
           sevenseg : out  STD_LOGIC_VECTOR (6 downto 0));
end decoder_7seg;

architecture Behavioral of decoder_7seg is

begin
	with digit_data  select 
		sevenseg  <=
		"1000000" when b"0000",
		"1111001" when b"0001",
		"0100100" when b"0010",
		"0110000" when b"0011",
		"0011001" when b"0100",
		"0010010" when b"0101",
		"0000010" when b"0110",
		"1111000" when b"0111",
		"0000000" when b"1000",
		"0010000" when b"1001",
		"0001000" when b"1010",
		"0000011" when b"1011",
		"1000110" when b"1100",
		"0100001" when b"1101",
		"0000110" when b"1110",
		"0001110" when others;

end Behavioral;

