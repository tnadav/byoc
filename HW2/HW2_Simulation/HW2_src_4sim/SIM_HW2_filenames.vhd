--
-- 
-- This package includes definition of all filenames used in simulations

--
--
----------------------------------------------------------------------------------
library	ieee;


package BYOC_filenames is
	
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use std.textio.all;
use IEEE.NUMERIC_STD.all;

--for Nexys4 Synthesis
--constant	program_in_file_name 	: string := "..\..\..\..\HW2_src_4sim\SIM_HW2_program.dat";
--constant	data_in_file_name 		: string := "..\..\..\..\HW2_src_4sim\SIM_HW2_TB_data.dat";


--for Nexys4 Simulation
constant	program_in_file_name 	: string := "H:\Vivado_2024\tests\HW2_vivado\HW2_simulation\HW2_src_4sim\SIM_HW2_program.dat";
constant	data_in_file_name 		: string := "H:\Vivado_2024\tests\HW2_vivado\HW2_simulation\HW2_src_4sim\SIM_HW2_TB_data.dat";




signal 		no_hold					: STD_LOGIC := '0'; -- MUST be '0' for correct TB messages!!!

end BYOC_filenames;