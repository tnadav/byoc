-----------------------------------------------------------------
-- test bench for GPR_File
-- by Danny Seidner 5/12/14
-----------------------------------------------------------------

library	ieee;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use std.textio.all;
use IEEE.NUMERIC_STD.all;

use work.BYOC_filenames.all;

-----------------------------------------------------------------
  

entity GPR_TB is
end GPR_TB;

architecture Testing of GPR_TB is

-- the component under test
component  GPR is
Port( 	
--RST			:	in		STD_LOGIC;
CK			: 	in  	STD_LOGIC;
rd_reg1 	: 	in  	STD_LOGIC_VECTOR (4 downto 0);-- Rs
rd_reg2 	: 	in  	STD_LOGIC_VECTOR (4 downto 0);-- Rt
wr_reg	 	: 	in  	STD_LOGIC_VECTOR (4 downto 0);-- Rd (in R-Type instruction, Rt in LW)
rd_data1 	: 	out 	STD_LOGIC_VECTOR (31 downto 0);-- Rs contents
rd_data2 	: 	out 	STD_LOGIC_VECTOR (31 downto 0);-- Rt contents
wr_data 	: 	in	 	STD_LOGIC_VECTOR (31 downto 0);-- contents to be written into Rd (or Rt)
Reg_Write 	: 	in  	STD_LOGIC;-- "0" means no register is written into
GPR_hold	: 	in  	STD_LOGIC-- "1" means no register is written into
	);
end component;

-- signals to be issued and tested by the TB
-- inputs to the tested GPR File component
signal TB_CK		: 	STD_LOGIC; 
signal TB_rd_reg1	: 	STD_LOGIC_VECTOR (4 downto 0);
signal TB_rd_reg2	: 	STD_LOGIC_VECTOR (4 downto 0);
signal TB_wr_reg	: 	STD_LOGIC_VECTOR (4 downto 0);
signal TB_wr_data	: 	STD_LOGIC_VECTOR (31 downto 0);
signal TB_Reg_Write	: 	STD_LOGIC; 
signal TB_GPR_hold	: 	STD_LOGIC; 
-- outputs from the tested GPR File component
signal TB_rd_data1	: 	STD_LOGIC_VECTOR (31 downto 0);
signal TB_rd_data2	: 	STD_LOGIC_VECTOR (31 downto 0);
--
-- Testing mechanism signals
signal i : integer :=0;-- for counting TB CK cycles
signal err_cntr: integer :=0;
signal ck_no_expected_val	: 	integer;
signal expected_rd_data1	: 	STD_LOGIC_VECTOR (31 downto 0);
signal expected_rd_data2	: 	STD_LOGIC_VECTOR (31 downto 0);
signal temp	: 	STD_LOGIC_VECTOR (1 downto 0);

	
FILE data_in_file : text open read_mode is GPR_data_in_file_name;


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



begin
    	
-- connecting the unit under test to TB signals
GPR_under_test : GPR 
	Port map	(	
CK			=>		TB_CK,
rd_reg1 	=>		TB_rd_reg1,
rd_reg2 	=>		TB_rd_reg2,
wr_reg	 	=>		TB_wr_reg,
rd_data1 	=>		TB_rd_data1,
rd_data2 	=>		TB_rd_data2,
wr_data 	=>		TB_wr_data,
Reg_Write 	=>		TB_Reg_Write,
GPR_hold	=>		TB_GPR_hold
);
	

-- External CK, 50 MHz CK
	 process  
		begin
			TB_CK <= '1';			-- clock cycle 20 ns
			wait for 10 ns;
			TB_CK <= '0';
			wait for 10 ns;
		end process;
	

  


-- Checking the design and issuing error messages 
verify: process

VARIABLE vectorline 			: line;
VARIABLE ck_no_from_file		: integer;
VARIABLE space0 				: string (1 to 6);
VARIABLE GPR_hold_from_file		: integer;
VARIABLE space1  				: string (1 to 8);
VARIABLE WE_from_file			: integer;
VARIABLE space2  				: string (1 to 6);
VARIABLE wr_reg_from_file		: integer;
VARIABLE space3  				: string (1 to 8);
VARIABLE wr_data_from_file 		: string (1 to 8);
VARIABLE space4  				: string (1 to 6);
VARIABLE rd_reg1_from_file		: integer;
VARIABLE space5  				: string (1 to 8);
VARIABLE rd_data1_from_file 	: string (1 to 8);
VARIABLE space6  				: string (1 to 7);
VARIABLE rd_reg2_from_file		: integer;
VARIABLE space7  				: string (1 to 8);
VARIABLE rd_data2_from_file 	: string (1 to 8);



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
    READ ( vectorline,ck_no_from_file);
    READ ( vectorline,space0);
    READ ( vectorline,GPR_hold_from_file);
    READ ( vectorline,space1);
    READ ( vectorline,WE_from_file);
    READ ( vectorline,space2);
    READ ( vectorline,wr_reg_from_file);
    READ ( vectorline,space3);
    READ ( vectorline,wr_data_from_file);
    READ ( vectorline,space4);
    READ ( vectorline,rd_reg1_from_file);
    READ ( vectorline,space5);
    READ ( vectorline,rd_data1_from_file);
    READ ( vectorline,space6);
    READ ( vectorline,rd_reg2_from_file);
    READ ( vectorline,space7);
    READ ( vectorline,rd_data2_from_file);
--	
	ck_no_expected_val <= ck_no_from_file;
	TB_rd_reg1	<= conv_std_logic_vector(rd_reg1_from_file,5);
	TB_rd_reg2	<= conv_std_logic_vector(rd_reg2_from_file,5);
	TB_wr_reg	<= conv_std_logic_vector(wr_reg_from_file,5);
	--TB_Reg_Write	<= '1' when WE_from_file = 1 else '0';
	temp	<= conv_std_logic_vector(WE_from_file,2);
    wait for 1 ns;-- required only for updating TB_Reg_Write in simulation
	TB_Reg_Write	<= temp(0);
	temp	<= conv_std_logic_vector(GPR_hold_from_file,2);
    wait for 1 ns;-- required only for updating TB_GPR_hold_Write in simulation
	TB_GPR_hold	<= temp(0);
	TB_wr_data  <= to_std_logic_vector(wr_data_from_file,32);
	expected_rd_data1  <= to_std_logic_vector(rd_data1_from_file,32);
	expected_rd_data2  <= to_std_logic_vector(rd_data2_from_file,32);
--
    wait until TB_CK='1';
	i <= i+1;
--
-- check CK serial no.
	assert ck_no_expected_val = i report "Error in counting CKs. CK no is " &  integer'image(i) & ", expected " & integer'image(ck_no_expected_val) severity ERROR;
	if ck_no_expected_val /= i then err_cntr <= err_cntr + 1; end if;

-- check read data1 value    
	assert TB_rd_data1 = expected_rd_data1 report "Error in read reg1 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rd_data1) & " instead of " & to_hex_string(expected_rd_data1) severity error;
    if TB_rd_data1 /= expected_rd_data1 then err_cntr <= err_cntr + 1; end if;

-- check read data2 value    
	assert TB_rd_data2 = expected_rd_data2 report "Error in read reg2 in CK cycle " & integer'image(i) &"!!! " & " was " & to_hex_string(TB_rd_data2) & " instead of " & to_hex_string(expected_rd_data2) severity error;
    if TB_rd_data2 /= expected_rd_data2 then err_cntr <= err_cntr + 1; end if;

--
  end loop;
 
  wait until TB_CK='1';
	
  if err_cntr > 0 then
	report "========== no of errors is: " & integer'image(err_cntr) & ", ================ test FAILED!! =================" severity ERROR; 
  else
	report "============ Test pass!! ===============";
  end if;
	
	wait;
end process verify;


	
	
end Testing;



