library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

--library unisim;-- to be removed for Modelsim simulation
--use unisim.vcomponents.all;-- to be removed for Modelsim simulation

entity Clock_Driver is
port
 (
  CK_100MHz_IN			: in  std_logic ;
  CK_25MHz_OUT			: out std_logic
  );
end Clock_Driver;

architecture clock_divider of Clock_Driver is

SIGNAL  ck_in_signal : STD_LOGIC;
SIGNAL  cntr_signal : STD_LOGIC_vector (1 downto 0) :="00";
SIGNAL  ck_out_signal : STD_LOGIC;
 
begin

ck_in_signal	<=	CK_100MHz_IN; -- 100 MHz in
CK_25MHz_OUT	<=	ck_out_signal; -- 25MHz out

process(ck_in_signal)
begin
	if ck_in_signal'event and ck_in_signal='1' then
		cntr_signal	<=	cntr_signal + 1;
	end if;
end process;


--CK_OUT_BUFG_INST : BUFG
--port map (I => cntr_signal(1),
--          O => ck_out_signal );
ck_out_signal	<=	cntr_signal(1); -- a straight connection instead of BUFG for Modelsim silulation 
  
end clock_divider;