-----------------------------------------------------------------
-- test bench for HW2_top - for students - for Vivado
-- by Danny Seidner 08/05/15
-----------------------------------------------------------------

library	ieee;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use std.textio.all;
use IEEE.NUMERIC_STD.all;

use work.BYOC_filenames.all;

-----------------------------------------------------------------
  

entity BYOC_TB_for_students is
end BYOC_TB_for_students;

architecture Testing of BYOC_TB_for_students is

-- =========================================================================
 function to_std_logic_vector( s : string ; siz : integer ) -- s is the string to be converted, siz is the number of bits in the result r 
	return std_logic_vector 
	is
		variable r : std_logic_vector(siz-1 downto 0) ;
		variable nibble : std_logic_vector(3 downto 0); -- to here we write the hex value 
		variable k : integer; -- k=siz/4-i   (if siz=32, i= 1 to 8, k= 7 to 0)
	begin
		r := conv_std_logic_vector(0,siz);
		for i in 1 to siz/4 loop
		k := siz/4 - i;
		  case s(i) is
			when '1' => nibble := b"0001";
			when '2' => nibble := b"0010";
			when '3' => nibble := b"0011";
			when '4' => nibble := b"0100";
			when '5' => nibble := b"0101";
			when '6' => nibble := b"0110";
			when '7' => nibble := b"0111";
			when '8' => nibble := b"1000";
			when '9' => nibble := b"1001";
			when 'A' => nibble := b"1010";
			when 'B' => nibble := b"1011";
			when 'C' => nibble := b"1100";
			when 'D' => nibble := b"1101";
			when 'E' => nibble := b"1110";
			when 'F' => nibble := b"1111";
			when 'a' => nibble := b"1010";
			when 'b' => nibble := b"1011";
			when 'c' => nibble := b"1100";
			when 'd' => nibble := b"1101";
			when 'e' => nibble := b"1110";
			when 'f' => nibble := b"1111";
--			when '0' => nibble := b"0000";
			when others => nibble := b"0000";
		  end case;		
		r(k*4+3 downto k*4) := nibble ;
		end loop ;
		return r ;
	end function ;

-- =========================================================================

function  to_hex_string(std_vec: in std_logic_vector) return string is
   
    variable vecopy: std_logic_vector(std_vec'length-1 downto 0) := std_vec;-- copy of the input value
    variable nibble : std_logic_vector(3 downto 0); -- to here we copy 4 bits and check the hex value 
	variable hex_string: string (std_vec'length/4 downto 1); -- string index starts from 1
    
  begin
    assert (std_vec'length mod 4)=0   report "Not a multiple of 4 bits!!, Aborting."   severity FAILURE;
    for i in hex_string'range loop
		nibble :=  vecopy(i*4-1 downto (i-1)*4);
		case nibble is
			when "0000" => hex_string(i) := '0';
			when "0001" => hex_string(i) := '1';
			when "0010" => hex_string(i) := '2';
			when "0011" => hex_string(i) := '3';
			when "0100" => hex_string(i) := '4';
			when "0101" => hex_string(i) := '5';
			when "0110" => hex_string(i) := '6';
			when "0111" => hex_string(i) := '7';
			when "1000" => hex_string(i) := '8';
			when "1001" => hex_string(i) := '9';
			when "1010" => hex_string(i) := 'A';
			when "1011" => hex_string(i) := 'B';
			when "1100" => hex_string(i) := 'C';
			when "1101" => hex_string(i) := 'D';
			when "1110" => hex_string(i) := 'E';
			when "1111" => hex_string(i) := 'F';
			when others => hex_string(i) := 'x';
		end case;
    end loop;
    return hex_string;
 end function;

-- =========================================================================

-- the component under test
component  HW2_top is
port
 (
-- Infrastructure signals [To be used by PC via RS232 or from Nexys2 board switches & pushbuttons, and VGA signals to the screen],
-- Host intf signals
RS232_Rx		: in STD_LOGIC;
RS232_Tx		: out STD_LOGIC;
-- VGA signals
VGA_h_sync		: 	out  	STD_LOGIC;
VGA_v_sync		: 	out  	STD_LOGIC;
VGA_red0		: 	out  	STD_LOGIC;
VGA_red1		: 	out  	STD_LOGIC;
VGA_red2		: 	out  	STD_LOGIC;
VGA_red3		: 	out  	STD_LOGIC;
VGA_grn0		: 	out  	STD_LOGIC;
VGA_grn1		: 	out  	STD_LOGIC;
VGA_grn2		: 	out  	STD_LOGIC;
VGA_grn3		: 	out  	STD_LOGIC;
VGA_blu0		: 	out  	STD_LOGIC;
VGA_blu1		: 	out  	STD_LOGIC;
VGA_blu2		: 	out  	STD_LOGIC;
VGA_blu3		: 	out  	STD_LOGIC;
--KBD signals
PS2C			: 	in  	STD_LOGIC;-- PS2 keyboard clock
PS2D			: 	in  	STD_LOGIC;-- PS2 keyboard data
--general signals
leds_out		:	out		STD_LOGIC_VECTOR (7 downto 0);-- 7-0=Host_intf version
CK_100MHz 		:	in		STD_LOGIC;
buttons_in		:	in		STD_LOGIC_vector(3 downto 0);--  btn0 is single clock (manual clock), btn3 is manual reset
switches_in 	:	in		STD_LOGIC_VECTOR (7 downto 0);-- 4-0 to select which part to be displayed on the 7Segnets LEDs
sevenseg_out	:	out		STD_LOGIC_VECTOR (6 downto 0);-- to the 7 seg LEDs
anodes_out		:	out		STD_LOGIC_VECTOR (7 downto 0);-- to the 7 seg LEDs
-- signals to be tested by the TB
CK_out_to_TB			:	out STD_LOGIC; 
RESET_out_to_TB			:	out STD_LOGIC; 
HOLD_out_to_TB			:	out STD_LOGIC; 
rdbk0_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk1_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk2_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk3_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk4_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk5_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk6_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk7_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk8_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk9_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk10_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk11_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk12_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk13_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk14_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0); 
rdbk15_out_to_TB 		:	out STD_LOGIC_VECTOR (31 downto 0) 
		);
end component;


-- signals to be issued and tested by the TB
-- inputs to the tested MIPS ALU component
signal TB_CK		: STD_LOGIC; -- simulating CK
-- outputs to be used
signal TB_CK_out		: STD_LOGIC;
signal TB_RESET_out		: STD_LOGIC;
signal TB_HOLD_out		: STD_LOGIC;
signal TB_RS232_Tx		: STD_LOGIC; -- only for connection - will not be used
-- data output to be used checked
signal TB_rdbk0			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk1			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk2			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk3			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk4			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk5			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk6			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk7			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk8			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk9			: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk10		: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk11		: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk12		: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk13		: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk14		: STD_LOGIC_VECTOR(31 downto 0);
signal TB_rdbk15		: STD_LOGIC_VECTOR(31 downto 0);
--
-- Testing mechanism signals
signal i 			: integer :=0;-- for counting TB_CK_out cycles
signal ck_no_expected_val	: 	integer;

signal temp			: STD_LOGIC_VECTOR (1 downto 0);

signal expected_value0 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value1 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value2 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value3 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value4 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value5 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value6 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value7 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value8 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value9 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value10 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value11 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value12 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value13 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value14 : STD_LOGIC_VECTOR (31 downto 0);
signal expected_value15 : STD_LOGIC_VECTOR (31 downto 0);

signal err_cntr		: integer :=0;

	
FILE data_in_file : text open read_mode is data_in_file_name;


-- =========================================================================



begin
    	
-- connecting the unit under test to TB signals	
Testing_BYOC_top: HW2_top
Port map	(	
-- Host intf signals
RS232_Rx		=>		'1',
RS232_Tx		=>		open, 
-- VGA signals
VGA_h_sync		=>		open,
VGA_v_sync		=>		open,
VGA_red0		=>		open,
VGA_red1		=>		open,
VGA_red2		=>		open,
VGA_red3		=>		open,
VGA_grn0		=>		open,
VGA_grn1		=>		open,
VGA_grn2		=>		open,
VGA_grn3		=>		open,
VGA_blu0		=>		open,
VGA_blu1		=>		open,
VGA_blu2		=>		open,
VGA_blu3		=>		open,
--KBD signals
PS2C			=>		'1',
PS2D			=>		'1',
--general signals
leds_out		=>		open,
CK_100MHz 		=>		TB_CK,
buttons_in		=>		"0000",
switches_in 	=>		"00000000",
sevenseg_out	=>		open,
anodes_out		=>		open,
-- signals to be tested by the TB
CK_out_to_TB			=>		TB_CK_out, 
RESET_out_to_TB			=>		TB_RESET_out,
HOLD_out_to_TB			=>		TB_HOLD_out,
rdbk0_out_to_TB 		=>		TB_rdbk0,	
rdbk1_out_to_TB 		=>		TB_rdbk1,
rdbk2_out_to_TB 		=>		TB_rdbk2,
rdbk3_out_to_TB 		=>		TB_rdbk3,
rdbk4_out_to_TB 		=>		TB_rdbk4,
rdbk5_out_to_TB 		=>		TB_rdbk5,
rdbk6_out_to_TB 		=>		TB_rdbk6,
rdbk7_out_to_TB 		=>		TB_rdbk7,
rdbk8_out_to_TB 		=>		TB_rdbk8,
rdbk9_out_to_TB 		=>		TB_rdbk9,
rdbk10_out_to_TB 		=>		TB_rdbk10,
rdbk11_out_to_TB 		=>		TB_rdbk11,
rdbk12_out_to_TB 		=>		TB_rdbk12,
rdbk13_out_to_TB 		=>		TB_rdbk13,
rdbk14_out_to_TB 		=>		TB_rdbk14,
rdbk15_out_to_TB 		=>		TB_rdbk15
);


-- creating the TB signals		

	-- External CK, 100 MHz CK
	 process  
		begin
			TB_CK <= '1';			-- clock cycle 10 ns
			wait for 5 ns;
			TB_CK <= '0';
			wait for 5 ns;
		end process;
	

  


-- Checking the design and issuing error messages 
verify: process

VARIABLE vectorline 			: line;
VARIABLE ck_no_from_file		: integer;
--
VARIABLE space0  				: string (1 to 4);
VARIABLE val0_from_file			: string (1 to 8);
VARIABLE space1  				: string (1 to 4);
VARIABLE val1_from_file			: string (1 to 8);
VARIABLE space2  				: string (1 to 4);
VARIABLE val2_from_file			: string (1 to 8);
VARIABLE space3  				: string (1 to 4);
VARIABLE val3_from_file			: string (1 to 8);
--
--
VARIABLE space4 				: string (1 to 8);
VARIABLE val4_from_file			: string (1 to 8);
VARIABLE space5 				: string (1 to 4);
VARIABLE val5_from_file			: string (1 to 8);
VARIABLE space6 				: string (1 to 4);
VARIABLE val6_from_file			: string (1 to 8);
VARIABLE space7 				: string (1 to 4);
VARIABLE val7_from_file			: string (1 to 8);
--
--
VARIABLE space8 				: string (1 to 8);
VARIABLE val8_from_file			: string (1 to 8);
VARIABLE space9 				: string (1 to 4);
VARIABLE val9_from_file			: string (1 to 8);
VARIABLE space10 				: string (1 to 4);
VARIABLE val10_from_file		: string (1 to 8);
VARIABLE space11				: string (1 to 4);
VARIABLE val11_from_file		: string (1 to 8);
--
--
VARIABLE space12				: string (1 to 8);
VARIABLE val12_from_file		: string (1 to 8);
VARIABLE space13				: string (1 to 4);
VARIABLE val13_from_file		: string (1 to 8);
VARIABLE space14				: string (1 to 4);
VARIABLE val14_from_file		: string (1 to 8);
VARIABLE space15				: string (1 to 4);
VARIABLE val15_from_file		: string (1 to 8);
--


VARIABLE vectorline2 			: line;-- output line
VARIABLE ck_no_to_file			: integer;
--



begin
	
  i <= 0;
  err_cntr <=0;
  wait for 1 ns; -- wait so that we first load the program memory
  
  report "================== Start checking signals ======================================";
--  
   wait until TB_RESET_out='1';-- wait till beginning of reset pulse
   wait until TB_RESET_out='0';-- wait till reset pulse ends

	-- read the headline
    READLINE (data_in_file,vectorline);-- first headline
	
    READLINE (data_in_file,vectorline);-- 2nd headline

	--
  while not ENDFILE(data_in_file) loop  
    READLINE (data_in_file,vectorline);
--
    READ ( vectorline,ck_no_from_file);
 --
	READ ( vectorline,space0);
    READ ( vectorline,val0_from_file);
	READ ( vectorline,space1);
    READ ( vectorline,val1_from_file);
	READ ( vectorline,space2);
    READ ( vectorline,val2_from_file);
	READ ( vectorline,space3);
    READ ( vectorline,val3_from_file);
--
	READ ( vectorline,space4);
    READ ( vectorline,val4_from_file);
	READ ( vectorline,space5);
    READ ( vectorline,val5_from_file);
	READ ( vectorline,space6);
    READ ( vectorline,val6_from_file);
	READ ( vectorline,space7);
    READ ( vectorline,val7_from_file);
--
	READ ( vectorline,space8);
    READ ( vectorline,val8_from_file);
	READ ( vectorline,space9);
    READ ( vectorline,val9_from_file);
	READ ( vectorline,space10);
    READ ( vectorline,val10_from_file);
	READ ( vectorline,space11);
    READ ( vectorline,val11_from_file);
--
	READ ( vectorline,space12);
    READ ( vectorline,val12_from_file);
	READ ( vectorline,space13);
    READ ( vectorline,val13_from_file);
	READ ( vectorline,space14);
    READ ( vectorline,val14_from_file);
	READ ( vectorline,space15);
    READ ( vectorline,val15_from_file);
--
--
--
--
	ck_no_expected_val <= ck_no_from_file;
--
	expected_value0		<= to_std_logic_vector(val0_from_file,32);
	expected_value1		<= to_std_logic_vector(val1_from_file,32);
	expected_value2		<= to_std_logic_vector(val2_from_file,32);
	expected_value3		<= to_std_logic_vector(val3_from_file,32);
--
	expected_value4		<= to_std_logic_vector(val4_from_file,32);
	expected_value5		<= to_std_logic_vector(val5_from_file,32);
	expected_value6		<= to_std_logic_vector(val6_from_file,32);
	expected_value7		<= to_std_logic_vector(val7_from_file,32);
--
	expected_value8		<= to_std_logic_vector(val8_from_file,32);
	expected_value9		<= to_std_logic_vector(val9_from_file,32);
	expected_value10	<= to_std_logic_vector(val10_from_file,32);
	expected_value11	<= to_std_logic_vector(val11_from_file,32);
--
	expected_value12	<= to_std_logic_vector(val12_from_file,32);
	expected_value13	<= to_std_logic_vector(val13_from_file,32);
	expected_value14	<= to_std_logic_vector(val14_from_file,32);
	expected_value15	<= to_std_logic_vector(val15_from_file,32);
--
--
    wait until TB_CK_out='1';
	i <= i+1;
--
-- check CK serial no.
	assert ck_no_expected_val = i report "Error in counting CKs. CK no is " &  integer'image(i) & ", expected " & integer'image(ck_no_expected_val) severity ERROR;
	if ck_no_expected_val /= i then err_cntr <= err_cntr + 1; end if;

-- check expected_value0    
	assert TB_rdbk0 = expected_value0 report "Error in value0 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk0) & " instead of " & to_hex_string(expected_value0) severity error;
    if TB_rdbk0 /= expected_value0 then err_cntr <= err_cntr + 1; end if;

-- check expected_value1    
	assert TB_rdbk1 = expected_value1 report "Error in value1 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk1) & " instead of " & to_hex_string(expected_value1) severity error;
    if TB_rdbk1 /= expected_value1 then err_cntr <= err_cntr + 1; end if;

-- check expected_value2   
	assert TB_rdbk2 = expected_value2 report "Error in value2 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk2) & " instead of " & to_hex_string(expected_value2) severity error;
    if TB_rdbk2 /= expected_value2 then err_cntr <= err_cntr + 1; end if;

-- check expected_value3   
	assert TB_rdbk3 = expected_value3 report "Error in value3 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk3) & " instead of " & to_hex_string(expected_value3) severity error;
    if TB_rdbk3 /= expected_value3 then err_cntr <= err_cntr + 1; end if;

-- check expected_value4    
	assert TB_rdbk4 = expected_value4 report "Error in value4 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk4) & " instead of " & to_hex_string(expected_value4) severity error;
    if TB_rdbk4 /= expected_value4 then err_cntr <= err_cntr + 1; end if;

-- check expected_value5    
	assert TB_rdbk5 = expected_value5 report "Error in value5 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk5) & " instead of " & to_hex_string(expected_value5) severity error;
    if TB_rdbk5 /= expected_value5 then err_cntr <= err_cntr + 1; end if;

-- check expected_value6    
	assert TB_rdbk6 = expected_value6 report "Error in value6 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk6) & " instead of " & to_hex_string(expected_value6) severity error;
    if TB_rdbk6 /= expected_value6 then err_cntr <= err_cntr + 1; end if;

-- check expected_value7    
	assert TB_rdbk7 = expected_value7 report "Error in value7 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk7) & " instead of " & to_hex_string(expected_value7) severity error;
    if TB_rdbk7 /= expected_value7 then err_cntr <= err_cntr + 1; end if;

-- check expected_value8    
	assert TB_rdbk8 = expected_value8 report "Error in value8 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk8) & " instead of " & to_hex_string(expected_value8) severity error;
    if TB_rdbk8 /= expected_value8 then err_cntr <= err_cntr + 1; end if;

-- check expected_value9    
	assert TB_rdbk9 = expected_value9 report "Error in value9 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk9) & " instead of " & to_hex_string(expected_value9) severity error;
    if TB_rdbk9 /= expected_value9 then err_cntr <= err_cntr + 1; end if;

-- check expected_value10    
	assert TB_rdbk10 = expected_value10 report "Error in value10 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk10) & " instead of " & to_hex_string(expected_value10) severity error;
    if TB_rdbk10 /= expected_value10 then err_cntr <= err_cntr + 1; end if;

-- check expected_value11    
	assert TB_rdbk11 = expected_value11 report "Error in value11 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk11) & " instead of " & to_hex_string(expected_value11) severity error;
    if TB_rdbk11 /= expected_value11 then err_cntr <= err_cntr + 1; end if;

-- check expected_value12    
	assert TB_rdbk12 = expected_value12 report "Error in value12 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk12) & " instead of " & to_hex_string(expected_value12) severity error;
    if TB_rdbk12 /= expected_value12 then err_cntr <= err_cntr + 1; end if;

-- check expected_value13    
	assert TB_rdbk13 = expected_value13 report "Error in value13 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk13) & " instead of " & to_hex_string(expected_value13) severity error;
    if TB_rdbk13 /= expected_value13 then err_cntr <= err_cntr + 1; end if;

-- check expected_value14    
	assert TB_rdbk14 = expected_value14 report "Error in value14 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk14) & " instead of " & to_hex_string(expected_value14) severity error;
    if TB_rdbk14 /= expected_value14 then err_cntr <= err_cntr + 1; end if;

-- check expected_value15    
	assert TB_rdbk15 = expected_value15 report "Error in value15 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rdbk15) & " instead of " & to_hex_string(expected_value15) severity error;
    if TB_rdbk15 /= expected_value15 then err_cntr <= err_cntr + 1; end if;

--
  end loop;
 
  wait until TB_CK_out='1';
    i <= i+1;
	
  if err_cntr > 0 then
	report "========== no of errors is: " & integer'image(err_cntr) & ", ================ test FAILED!! =================" severity ERROR; 
  else
	report "============ Test pass!! ===============";
  end if;
	

 
   -- continue counting the clocks also after reaching end of file 
   while i < 1000 loop  

      wait until TB_CK_out='1';-- wait till beginning of clock  
	  i <= i+1;									 
   end loop;
 
	wait;
end process verify;


	
	
end Testing;



