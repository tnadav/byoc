--
-- 
-- This module "imitates" the regular BYOC_Host_intf. (For simulation only. It has a preloaded IMem)
--
-- It has the same i/o pins as the real BYOC_Host_Intf.
-- Therefore, similarly to the real BYOC_Host_intf it is "connected" to the VGA screen,
-- to the KBD, to the 7 segments, to the RS232 signals, to the Switches and buttons and 
-- has a preloaded Instruction memory inside and a few DMem addresses
-- It also has the rdbk0-15 signals - to be read & displayed on the PC screen by the real BYOC_Host_Intf
--
--
--     The MIPS memory map is as follows:
--        00400000h - 00400FFCh : IMem   (1Kx32) 
--        10000000h - 10000004h : DMem   (4x32) -- only 4+1 addresses for simulation 
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use std.textio.all;
use IEEE.NUMERIC_STD.all;

use work.BYOC_filenames.all;

-- ***************************************************************************************************
-- ***************************************************************************************************

entity BYOC_Host_Intf is
Port	(	
--=========================The student's part=================================
-- MIPS signals    [to be used by students]
MIPS_reset		: 	out  	STD_LOGIC; -- output to the Student's design
MIPS_hold		: 	out  	STD_LOGIC; -- output to the Student's design
-- MIPS IMem signals
MIPS_IMem_adrs 	: 	in  	STD_LOGIC_VECTOR (31 downto 0);-- MIPS IMem read address  
MIPS_IMem_rd_data :	out		STD_LOGIC_VECTOR (31 downto 0);-- read data (sync read -  at the rising edge of MIPS_ck,  all the time)	
-- MIPS DMem signals
MIPS_DMem_we	:	in		STD_LOGIC;-- '1' when the CPU writes to MIPD_DMem (MIPS_Dmem_wr_data is written to MIPS_DMem_adrs at the rising edge of MIPS_ck), '0' when we do not write
MIPS_DMem_adrs 	: 	in  	STD_LOGIC_VECTOR (31 downto 0);-- MIPS DMem read/write address
MIPS_DMem_wr_data :	in		STD_LOGIC_VECTOR (31 downto 0);-- write data  (sync write - at the rising edge of MIPS_ck, if MIPS_DMem_we='1')		
MIPS_DMem_rd_data :	out		STD_LOGIC_VECTOR (31 downto 0);-- read data (sync read -  at the rising edge of MIPS_ck,  all the time)	
--
--============================Other signals to be directed to i/o pins==============================
--
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
--PS2 kbd signals
PS2_kbd_ck		:	in  	STD_LOGIC;
PS2_kbd_data	:	in  	STD_LOGIC;
--
--general signals
CK_25MHz 			: in STD_LOGIC; -- main clock input to the Host interface. From this clock we create all other clock signals in the design
buttons_in	: in STD_LOGIC_vector(3 downto 0);--  btn0 is single clock (manual clock), btn3 is manual reset
switches_in : in STD_LOGIC_VECTOR (7 downto 0);-- 4-0 to select which part to be displayed on the 7Segnets LEDs
sevenseg_out : out STD_LOGIC_VECTOR (6 downto 0);-- to the 7 seg LEDs
anodes_out 	: out STD_LOGIC_VECTOR (7 downto 0);-- to the 7 seg LEDs
leds_out 	: out STD_LOGIC_VECTOR (7 downto 0);-- to 8 LEDs (= BYOC_Host_Intf version number)
--
--=========================additional part for the student=================================
-- RDBK signals
rdbk0 	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk1 	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk2	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk3 	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk4 	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk5	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk6	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk7	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk8	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk9	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk10	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk11	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk12	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk13	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk14	:	in	STD_LOGIC_VECTOR (31 downto 0);
rdbk15	:	in	STD_LOGIC_VECTOR (31 downto 0)
);
end BYOC_Host_Intf; 


architecture Behavioral of BYOC_Host_Intf is
		   
-- ***************************************************************************************************
-- ***************************************************************************************************


-- signals connecting the components & inputs
-- ==============================================

--signal IMem_adrs 	: 	STD_LOGIC_VECTOR (31 downto 0);-- MIPS read/write address
--signal IMem_rd_data :	STD_LOGIC_VECTOR (31 downto 0);-- read data (sync read -  at the rising edge of MIPS_ck,  all the time)	

signal DMem_adrs 	: 	STD_LOGIC_VECTOR (31 downto 0);-- MIPS read/write address
signal DMem_rd_data_mux :	STD_LOGIC_VECTOR (31 downto 0);-- read data (async read all the time)	
signal DMem_rd_data :	STD_LOGIC_VECTOR (31 downto 0);-- read data (sync read -  at the rising edge of MIPS_ck,  all the time)	-- i.e., the MDR_reg
signal DMem_wr_data :	STD_LOGIC_VECTOR (31 downto 0);-- write data 
signal DMem_we 		:	STD_LOGIC;-- '1' for we
signal DMem_reg0 	: 	STD_LOGIC_VECTOR (31 downto 0);-- one of the four DMem addresses memory
signal DMem_reg1 	: 	STD_LOGIC_VECTOR (31 downto 0);-- one of the four DMem addresses memory
signal DMem_reg2 	: 	STD_LOGIC_VECTOR (31 downto 0);-- one of the four DMem addresses memory
signal DMem_reg3 	: 	STD_LOGIC_VECTOR (31 downto 0);-- one of the four DMem addresses memory
signal DMem_reg4 	: 	STD_LOGIC_VECTOR (31 downto 0);-- a reg for all other DMem addresses

-- RDBK signals    [to be used by students in real implementation debug]
signal HI_rdbk0 	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk1 	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk2		:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk3 	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk4 	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk5		:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk6		:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk7		:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk8		:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk9		:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk10	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk11	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk12	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk13	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk14	:	STD_LOGIC_VECTOR (31 downto 0);
signal HI_rdbk15	:	STD_LOGIC_VECTOR (31 downto 0);
--
signal HI_RS232_Rx		: STD_LOGIC;




-- ***************************************************************************************************
-- To create a reset signal at startup
signal  reset_cntr	: STD_LOGIC_VECTOR  (3 downto 0) := x"0";
signal	powerup_reset :STD_LOGIC :='0';

-- Reset and CK signals
signal  RESET :STD_LOGIC :='0';
signal  CK :STD_LOGIC :='0';

signal  hold_cntr	: STD_LOGIC_VECTOR  (7 downto 0) := x"00";
signal  HOLD :STD_LOGIC :='0';




-- ***************************************************************************************************


-- =============== all IMem write & read related signals ===================

	
FILE program_in_file : text open read_mode is  program_in_file_name;

-- =========================================================================


-- Defining IMem with 1024 addresses of 32 bit each
type Memory_Type is array (1023 downto 0) of std_logic_vector(31 downto 0);   
shared variable  IMem_memory_array : Memory_Type := (others => (others =>'0')); -- reset initial value to be 0

-- adrs variables (variable value is updated immediately)
shared variable  IMem_wr_adrs	:	INTEGER range 0 to 1023 :=0;
shared variable  IMem_rd_adrs	:	INTEGER range 0 to 1023 :=0;

-- data signals
signal IMem_rd_data	:	STD_LOGIC_VECTOR (31 downto 0);
signal IMem_wr_data	:	STD_LOGIC_VECTOR (31 downto 0);

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


fill_up_prog_mem : process -- filling up the program memory with data 

VARIABLE vectorline 			: line;
--
VARIABLE space0  				: string (1 to 2);
VARIABLE IMem_adrs_from_file	: string (1 to 8);
VARIABLE space1  				: string (1 to 7);
VARIABLE IMem_data_from_file	: string (1 to 8);
--
  
begin

report "================== Start filling IMem from file ======================================";
  
 -- read the headline
 READLINE (program_in_file,vectorline);-- first headline	
 READLINE (program_in_file,vectorline);-- 2nd headline

 -- read the entire file
 while not ENDFILE(program_in_file) loop  

    READLINE (program_in_file,vectorline);

	READ ( vectorline,space0);
    READ ( vectorline,IMem_adrs_from_file);	
	IMem_wr_adrs := conv_integer(to_std_logic_vector(IMem_adrs_from_file,32) - x"00400000")/4;-- not updated properly!!! so it is not used - bypassed

	READ ( vectorline,space1);
    READ ( vectorline,IMem_data_from_file);	
	IMem_memory_array(IMem_wr_adrs) := to_std_logic_vector(IMem_data_from_file,32);	

    --report "adrs= " & IMem_adrs_from_file & ", data= " & IMem_data_from_file;

 end loop;
 -- end of read file loop
 
report "================== Filling IMem from file done! ======================================";

wait;

end process fill_up_prog_mem;
	
	
	


-- =============================== CKs & Rest signals ==============================
-- CKs
CK <= CK_25MHz;


--power up reset counter & signal
process(CK) 
	begin
		if CK'event and CK='1' then
			if reset_cntr < x"F" then
				reset_cntr <= reset_cntr+1;
			end if;
		end if;
end process;

process(CK) 
	begin
		if CK'event and CK='1' then
--			if reset_cntr = x"E" or reset_cntr = x"D" then  -- older versions did not held the RESET in '1' from the beginning of simulation. 
                                                            -- This cause writing into the GPR and errors in BYOCIntf SW
--			if reset_cntr = x"1" or  then
--				powerup_reset <= '0';
--			elsif reset_cntr < x"F" then
			if reset_cntr >= x"0" and reset_cntr < x"F" then
--			if reset_cntr < x"F" then
				powerup_reset <= '1';
			else
				powerup_reset <= '0';
			end if;
		end if;
end process;

-- RESET
RESET <= switches_in(6) or powerup_reset;
MIPS_reset <= RESET;


-- HOLD signal creation
process(CK, RESET) 
	begin
		if RESET = '1' then
		hold_cntr <= b"00000000";
		elsif CK'event and CK='1' then
			hold_cntr <= hold_cntr + 1;
		end if;
end process;


HOLD <= '1' when (hold_cntr=b"01101000" or hold_cntr=b"01101001" or hold_cntr=b"01110010")and no_hold='0' else '0';-- HOLD depends on hold_cntr used
MIPS_hold <= HOLD;-- HOLD depends on hold_cntr used




-- MIPS IMem 
-- connecting IMem signals to BYOC_Host_intf pins


-- this process calculated IMem_rd_adrs (It also limits IMem_rd_adrs to 0-1023)
process(MIPS_IMem_adrs) 
begin
--IMem_rd_adrs := conv_integer(MIPS_IMem_adrs - x"00400000")/4; -- will not work if address is outside 400000-400FFC since IMem_rd_adrs will be out of the 0-1023 range
--end process;
	if conv_integer(MIPS_IMem_adrs - x"00400000")/4  < 0 or conv_integer(MIPS_IMem_adrs - x"00400000")/4 > 1023 then
		IMem_rd_adrs := 1023;-- put the last address so that data is 0 (all memeory is initialized to 0-s)
	else
		IMem_rd_adrs := conv_integer(MIPS_IMem_adrs - x"00400000")/4;
	end if; 
end process;

-- connect MIPS_IMem_rd_data
MIPS_IMem_rd_data <= IMem_rd_data;

-- "actual" IMem process
read_from_IMem: process (CK)
begin
if RESET='1' then
		IMem_rd_data <= x"00000000";
elsif CK'event and CK='1' then
--if CK'event and CK='1' then
	if HOLD = '0' then
		IMem_rd_data <= IMem_memory_array(IMem_rd_adrs);
	end if;
end if;
end process;


-- MIPS DMem 
-- connecting DMem signals to BYOC_Host_intf pins
DMem_adrs <= MIPS_DMem_adrs;
MIPS_DMem_rd_data <= DMem_rd_data;
DMem_wr_data <= MIPS_DMem_wr_data;
DMem_we <=  MIPS_DMem_we;
-- actual DMem
DMem_write: process (CK,DMem_adrs,MIPS_DMem_wr_data,DMem_we)
begin
if RESET='1' then
	DMem_reg0	<= 	x"00000000";
	DMem_reg1	<= 	x"00000000";
	DMem_reg2	<= 	x"00000000";
	DMem_reg3	<= 	x"00000000";
	DMem_reg4	<= 	x"00000000";
elsif CK'event and CK='1' then
	if DMem_we ='1' and HOLD='0' then
		case DMem_adrs is
			when x"10000000" =>     
				DMem_reg0	<= 	DMem_wr_data;
			when x"10000004" =>     
				DMem_reg1	<= 	DMem_wr_data;
			when x"10000008" =>     
				DMem_reg2	<= 	DMem_wr_data;
			when x"1000000C" =>     
				DMem_reg3	<= 	DMem_wr_data;
--
			when others =>     
				DMem_reg4  <= DMem_wr_data;
		end case;
	end if;
end if;
end process;


DMem_read_mux: process (DMem_adrs,DMem_reg0,DMem_reg1,DMem_reg2,DMem_reg3,DMem_reg4,CK)
begin
	case DMem_adrs is
		when x"10000000" =>     
            DMem_rd_data_mux  <= DMem_reg0;
		when x"10000004" =>     
            DMem_rd_data_mux  <= DMem_reg1;
		when x"10000008" =>     
            DMem_rd_data_mux  <= DMem_reg2;
		when x"1000000C" =>     
            DMem_rd_data_mux  <= DMem_reg3;
--
		when others =>     
            DMem_rd_data_mux  <= DMem_reg4;
	end case;
end process;


DMem_read_reg: process (RESET,CK)  -- The MDR reg
begin
	if RESET ='1' then
		DMem_rd_data <= x"00000000";
	elsif CK'event and CK='1' and HOLD='0' then
		DMem_rd_data <= DMem_rd_data_mux;
	end if;
end process;



--Not used signals
-- RDBK signals  - connected to not used signals
HI_rdbk0	<=	rdbk0 ;
HI_rdbk1	<=	rdbk1 ;
HI_rdbk2	<=	rdbk2 ;
HI_rdbk3	<=	rdbk3 ;
HI_rdbk4	<=	rdbk4 ;
HI_rdbk5	<=	rdbk5 ;
HI_rdbk6	<=	rdbk6 ;
HI_rdbk7	<=	rdbk7 ;
HI_rdbk8	<=	rdbk8 ;
HI_rdbk9	<=	rdbk9 ;
HI_rdbk10	<=	rdbk10 ;
HI_rdbk11	<=	rdbk11 ;
HI_rdbk12	<=	rdbk12 ;
HI_rdbk13	<=	rdbk13 ;
HI_rdbk14	<=	rdbk14 ;
HI_rdbk15	<=	rdbk15 ;

-- RS232 signal (output is '1', input connected to a not used signal)
RS232_Tx	<= '1';
HI_RS232_Rx	<= RS232_Rx;

leds_out <= b"00000100";


end Behavioral;

-- ***************************************************************************************************
-- ***************************************************************************************************

