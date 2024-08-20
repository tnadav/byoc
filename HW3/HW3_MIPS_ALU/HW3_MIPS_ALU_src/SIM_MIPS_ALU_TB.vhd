----------------------------------------------------------------
-- Test Bench for MIPS_ALU File
-- Written by Danny Seidner 12/12/14
----------------------------------------------------------------

library	 ieee;
use  ieee.std_logic_arith.all;  
use  ieee.std_logic_unsigned.all;
use  ieee.std_logic_1164.all;
use  std.textio.all;
use  IEEE.NUMERIC_STD.all;

use  work.BYOC_filenames.all;

----------------------------------------------------------------
  

entity  MIPS_ALU_TB  is
end     MIPS_ALU_TB;

architecture Testing of MIPS_ALU_TB is

-- The component under test is
component  MIPS_ALU is
Port( 	
--  control inputs (determin ALU operation||)
ALUOP		: in  STD_LOGIC_VECTOR(1 downto 0); -- 00=add, 01=sub, 10=by Function
Funct		: in  STD_LOGIC_VECTOR(5 downto 0); -- 32=ADD, 34=sub, 36=AND, 37=OR, 38=XOR, 42=SLT
-- data inputs & data control inputs
A_in		: in  STD_LOGIC_VECTOR(31 downto 0);
B_in		: in  STD_LOGIC_VECTOR(31 downto 0);
sext_imm	: in  STD_LOGIC_VECTOR(31 downto 0);
ALUsrcB		: in  STD_LOGIC;
-- data output
ALU_out		: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

-- signals to be issued and tested by the TB
-- inputs to the tested MIPS ALU component:
signal TB_ALUOP		:  STD_LOGIC_VECTOR(1 downto 0);
signal TB_Funct		:  STD_LOGIC_VECTOR(5 downto 0);
-- data inputs & data control inputs:
signal TB_A_in		:  STD_LOGIC_VECTOR(31 downto 0);
signal TB_B_in		:  STD_LOGIC_VECTOR(31 downto 0);
signal TB_sext_imm	:  STD_LOGIC_VECTOR(31 downto 0);
signal TB_ALUsrcB	:  STD_LOGIC;
-- data output to be checked by the TB:
signal TB_ALU_out	:  STD_LOGIC_VECTOR(31 downto 0);
--
-- Testing mechanism signals:
signal TB_CK		:  STD_LOGIC; -- simulating CK
signal i 			:  integer :=0; -- for counting TB CK cycles
signal err_cntr		:  integer :=0;
signal expected_ALU_out_value : STD_LOGIC_VECTOR (31 downto 0);
signal temp			:  STD_LOGIC_VECTOR (1 downto 0);
signal ck_no_expected_val	: 	integer;

	
FILE data_in_file : text  open read_mode is ALU_data_in_file_name;


-- ==========================================================================
-- This function converts STD_LOGIC_VECTOR to Hex string 
function  to_hex_string(std_vec: in std_logic_vector) return string is
   
    variable vecopy : std_logic_vector(std_vec'length-1 downto 0) := std_vec;-- copy of the input value
    variable nibble : std_logic_vector(3 downto 0); -- to here we copy 4 bits and check the hex value 
	variable hex_string: string (std_vec'length/4 downto 1);-- string index starts from 1
    
  begin
    assert (std_vec'length mod 4)=0   report "Not a multiple of 4 bits!!, Aborting."   severity FAILURE;
    for i in hex_string'range loop
		nibble :=  vecopy(i*4-1 downto (i-1)*4);
		case nibble is
			when  "0000" => hex_string(i) := '0';
			when  "0001" => hex_string(i) := '1';
			when  "0010" => hex_string(i) := '2';
			when  "0011" => hex_string(i) := '3';
			when  "0100" => hex_string(i) := '4';
			when  "0101" => hex_string(i) := '5';
			when  "0110" => hex_string(i) := '6';
			when  "0111" => hex_string(i) := '7';
			when  "1000" => hex_string(i) := '8';
			when  "1001" => hex_string(i) := '9';
			when  "1010" => hex_string(i) := 'A';
			when  "1011" => hex_string(i) := 'B';
			when  "1100" => hex_string(i) := 'C';
			when  "1101" => hex_string(i) := 'D';
			when  "1110" => hex_string(i) := 'E';
			when  "1111" => hex_string(i) := 'F';
			when  others => hex_string(i) := 'x';
		end case;
    end loop;
    return hex_string;
end function;

-- ==========================================================================
-- This function converts Hex string to STD_LOGIC_VECTOR (siz-1 downto 0)
-- s is the string to be converted, siz is the number of bits in the result r 
 function to_std_logic_vector( s : string ; siz : integer ) 
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
			when  '1' => nibble := b"0001";
			when  '2' => nibble := b"0010";
			when  '3' => nibble := b"0011";
			when  '4' => nibble := b"0100";
			when  '5' => nibble := b"0101";
			when  '6' => nibble := b"0110";
			when  '7' => nibble := b"0111";
			when  '8' => nibble := b"1000";
			when  '9' => nibble := b"1001";
			when  'A' => nibble := b"1010";
			when  'B' => nibble := b"1011";
			when  'C' => nibble := b"1100";
			when  'D' => nibble := b"1101";
			when  'E' => nibble := b"1110";
			when  'F' => nibble := b"1111";
			when  'a' => nibble := b"1010";
			when  'b' => nibble := b"1011";
			when  'c' => nibble := b"1100";
			when  'd' => nibble := b"1101";
			when  'e' => nibble := b"1110";
			when  'f' => nibble := b"1111";
--			when  '0' => nibble := b"0000";
			when  others => nibble := b"0000";
		  end case;		
		r(k*4+3 downto k*4) := nibble;
		end loop;
	return r;
end function;

-- ==========================================================================



begin
    	
-- connecting the unit under test to TB signals	
Testing_MIPS_ALU : MIPS_ALU 
	Port map (	
ALUOP		=>	TB_ALUOP,
Funct		=>	TB_Funct,
-- data inputs & data control inputs
A_in		=>	TB_A_in,
B_in		=>	TB_B_in,
sext_imm	=>	TB_sext_imm,
ALUsrcB		=>	TB_ALUsrcB,
-- data output
ALU_out		=>	TB_ALU_out
);
	

-- External CK (25 MHz CK)
	 process  
		begin
			TB_CK <= '1';		 -- clock cycle 40 ns
			wait for 20 ns;
			TB_CK <= '0';
			wait for 20 ns;
	end process;
	

  


-- Checking the design and issuing error messages if err 
verify: process

VARIABLE  vectorline 			: line;
VARIABLE  ck_no_from_file		: integer;
VARIABLE  space1  				: string (1 to 8);
VARIABLE  ALUOP_from_file		: integer;
VARIABLE  space2  				: string (1 to 6);
VARIABLE  Funct_from_file		: integer;
VARIABLE  space3  				: string (1 to 8);
VARIABLE  A_in_from_file 		: string (1 to 8);
VARIABLE  space4  				: string (1 to 6);
VARIABLE  ALUsrcB_from_file		: integer;
VARIABLE  space5  				: string (1 to 8);
VARIABLE  B_in_from_file 		: string (1 to 8);
VARIABLE  space6  				: string (1 to 9);
VARIABLE  sext_imm_from_file 	: string (1 to 8);
VARIABLE  space7  				: string (1 to 9);
VARIABLE  ALU_out_from_file 	: string (1 to 8);
 


begin
  i <= 0;
  err_cntr <=0;
  
  report "================== Start checking signals ======================================";
--  
   wait until TB_CK='1';
	i <= i+1;
---
-- read the headline
    READLINE (data_in_file,vectorline);
--
  while not ENDFILE(data_in_file) loop  
    READLINE (data_in_file,vectorline);
--
    READ  ( vectorline,ck_no_from_file);
    READ  ( vectorline,space1);
    READ  ( vectorline,ALUOP_from_file);
    READ  ( vectorline,space2);
    READ  ( vectorline,Funct_from_file);
    READ  ( vectorline,space3);
    READ  ( vectorline,A_in_from_file);
    READ  ( vectorline,space4);
    READ  ( vectorline,ALUsrcB_from_file);
    READ  ( vectorline,space5);
    READ  ( vectorline,B_in_from_file);
    READ  ( vectorline,space6);
    READ  ( vectorline,sext_imm_from_file);
    READ  ( vectorline,space7);
    READ  ( vectorline,ALU_out_from_file);
--	
	ck_no_expected_val <= ck_no_from_file;
	TB_ALUOP		<=  conv_std_logic_vector(ALUOP_from_file,2);
	TB_Funct		<=  conv_std_logic_vector(Funct_from_file,6);
	TB_A_in  		<=  to_std_logic_vector(A_in_from_file,32);
	temp			<=  conv_std_logic_vector(ALUsrcB_from_file,2);
    wait for 1 ns;-- required only for updating TB_Reg_Write in simulation
	TB_ALUsrcB		<=  temp(0);
	TB_B_in  		<=  to_std_logic_vector(B_in_from_file,32);
	TB_sext_imm		<=  to_std_logic_vector(sext_imm_from_file,32);
	expected_ALU_out_value		<=  to_std_logic_vector(ALU_out_from_file,32);
--
    wait until TB_CK='1';
	i <= i+1;
--
-- check CK serial no.
	assert ck_no_expected_val = i report "Error in counting CKs. CK no is " &  integer'image(i) & ", expected " & integer'image(ck_no_expected_val) severity ERROR;
	if ck_no_expected_val /= i then err_cntr  <= err_cntr + 1; end if;

-- check ALU_out value    
	assert TB_ALU_out = expected_ALU_out_value report "Error in ALU_out value in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_ALU_out) & " instead of " & to_hex_string(expected_ALU_out_value) severity error;
    if TB_ALU_out /= expected_ALU_out_value then err_cntr  <= err_cntr + 1; end if;

--
  end loop;
 
  wait until TB_CK='1';
	
  if err_cntr > 0 then
	report "======== no of errors is: " & integer'image(err_cntr) & ", =============== test FAILED!! =================" severity ERROR; 
  else
	report "========== Test passed!! ==============";
  end if;
	
  wait;

end process verify;


	
	
end Testing;



