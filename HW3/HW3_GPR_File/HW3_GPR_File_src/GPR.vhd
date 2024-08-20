
-- This module is the MIPS General Purpose Register (GPR) file implementation.
--
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GPR is
Port( 	
--RST			:	in		STD_LOGIC;
CK			: 	in  	STD_LOGIC;
rd_reg1 	: 	in  	STD_LOGIC_VECTOR (4 downto 0);-- Rs
rd_reg2 	: 	in  	STD_LOGIC_VECTOR (4 downto 0);-- Rt
wr_reg	 	: 	in  	STD_LOGIC_VECTOR (4 downto 0);-- Rd (in R-Type instruction, Rt in LW)
rd_data1 	: 	out 	STD_LOGIC_VECTOR (31 downto 0);-- Rs contents (or 0 if Rs==0)
rd_data2 	: 	out 	STD_LOGIC_VECTOR (31 downto 0);-- Rt contents (or 0 if Rr==0)
wr_data 	: 	in	 	STD_LOGIC_VECTOR (31 downto 0);-- contents to be written into Rd (or Rt)
Reg_Write 	: 	in  	STD_LOGIC;-- "0" means no register is written into
GPR_hold	: 	in  	STD_LOGIC-- "1" means no register is written into
	);
end GPR;

	
architecture Behavioral of GPR is

--signals used
signal  GPR_rd_data1 	: 	STD_LOGIC_VECTOR (31 downto 0);-- Rs contents
signal  GPR_rd_data2 	: 	STD_LOGIC_VECTOR (31 downto 0);-- Rt contents
signal  GPR_data_out1 	: 	STD_LOGIC_VECTOR (31 downto 0);-- Rs contents or 0 if Rs==0
signal  GPR_data_out2 	: 	STD_LOGIC_VECTOR (31 downto 0);-- Rt contents or 0 if Rr==0

signal  GPR_we		 	: 	STD_LOGIC;-- the we signal to the memory. made of a combination of Reg_Write and GPR_hold

-- components used
COMPONENT dual_port_memory_no_CK_read IS
GENERIC(
    width :  integer :=32;
    depth :  integer :=32
  );
PORT (
  wr_address    : in integer range depth-1 downto 0;
  wr_data       : in std_logic_vector(width-1 downto 0);
  wr_clk        : in std_logic;
  wr_en         : in std_logic;
  rd1_address   : in integer range depth-1 downto 0;
  rd1_data      : out std_logic_vector(width-1 downto 0);
  rd2_address   : in integer range depth-1 downto 0;
  rd2_data      : out std_logic_vector(width-1 downto 0)
   ); 
END COMPONENT;



begin 

GPR_we <= Reg_Write AND NOT GPR_hold; -- Disable write when GPR_hold is '1'

GPR_mem: dual_port_memory_no_CK_read 
  PORT MAP (
    wr_address    => conv_integer(wr_reg),
    wr_data       => wr_data,
    wr_clk        => CK,
    wr_en         => GPR_we,
    rd1_address   => conv_integer(rd_reg1),
    rd1_data      => GPR_rd_data1,
    rd2_address   => conv_integer(rd_reg2),
    rd2_data      => GPR_rd_data2
  );

-- Ensure that reading from register 0 always returns 0
rd_data1 <= (others => '0') when rd_reg1 = "00000" else GPR_rd_data1;
rd_data2 <= (others => '0') when rd_reg2 = "00000" else GPR_rd_data2;

end Behavioral;


