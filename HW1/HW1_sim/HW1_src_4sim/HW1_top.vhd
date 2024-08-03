----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Danny Seidner
-- 
-- Create Date:    10:00:00 25/3/2017 
-- Design Name: 
-- Module Name:    HW1_top - Behavioral 
-- Project Name: 
---
-- Description: 
-- This is a counter that 2 MSBs select which 7seg LED will be lit and the next 4 selects 
-- the digit to be displayed. Thus we expect the each LED to display all digits 
-- from 0 to F and then the next LED is doing that, and so on. 
-- The counter gets a CK from the clock_diveder that divides the input clock of 50MHz or
-- from a manual clock from a pushbutton. 
-- One of the switches on the board serves as "on/off" by clearing the counters when off.
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--- Uncomment the following library declaration if using
--- arithmetic functions with Signed or Unsigned values
---use IEEE.NUMERIC_STD.ALL;

--- Uncomment the following library declaration if instantiating
--- any Xilinx primitives in this code.
---library UNISIM;
---use UNISIM.VComponents.all;


--- The inputs & outputs to the board signals
--- ===========================================
entity HW1_top is
    Port ( CK 			: in  STD_LOGIC;
		   switches 	: in  STD_LOGIC_VECTOR (3 downto 0);
		   pushbutton	: in  STD_LOGIC;
           sevenseg_out : out STD_LOGIC_VECTOR (6 downto 0);
           anodes_out 	: out STD_LOGIC_VECTOR (7 downto 0));
end HW1_top;

architecture Behavioral of HW1_top is

--- all components used:
--- =====================
component ck_divider is
		Port 		( 	CK_in	:	in		STD_LOGIC;
						clr		: 	in  	STD_LOGIC;
						CK_out	: 	out  	STD_LOGIC);
end component;

component counter_7bits is
		Port 		( 	CK_in	:	in		STD_LOGIC;
						clr		: 	in  	STD_LOGIC;
						cntr_out	: 	out  	STD_LOGIC_VECTOR (6 downto 0));
end component;

component mux_2to1 is
    Port ( in0 	 		: in   STD_LOGIC;
		   in1 	 		: in   STD_LOGIC;
		   sel 	 		: in   STD_LOGIC;
           out_y			: out  STD_LOGIC);
end component;

component  decoder_7seg is
    Port ( digit_data : in  STD_LOGIC_VECTOR (3 downto 0);
           sevenseg : out   STD_LOGIC_VECTOR (6 downto 0));
end component;


component  decoder_3to8 is
    Port ( in_no 	 : in   STD_LOGIC_VECTOR (2 downto 0);
           out_lines : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

-- signals connecting the componenst & inputs
-- ==============================================

signal cntr_CK 		: STD_LOGIC;
signal osc_CK 		: STD_LOGIC;
signal manual_CK 	: STD_LOGIC;
--signal CK_sel	 	: STD_LOGIC;


signal digit_val 	: STD_LOGIC_VECTOR(3 downto 0);
signal digit_no 	: STD_LOGIC_VECTOR(2 downto 0);

signal reset		: STD_LOGIC;

--signal anodes 	: STD_LOGIC_VECTOR(3 downto 0);


-- description of the components connections & some extra logic
-- =============================================================
begin

reset <= not(switches(0)); -- rightmost switch should be "on" for the circuit to work. If "off" the counter is stuck on 0000
manual_CK <= pushbutton;-- manual CK comes from pushbutton

	
	OSC_CLK	:	ck_divider
		port map(
			CK_in => CK, 
			clr => reset, 
			CK_out => osc_CK );
			
	
	CNTR_CLK	:	mux_2to1     -- selects between manual_CK and osc_CK
		port map(
			in0 => osc_CK, 
			in1 => manual_CK, 
			sel => switches(1),
			out_y => cntr_CK );
			
	
	display_cntr: counter_7bits
		port map(
			CK_in => cntr_CK,
			clr	  => reset,
			cntr_out(3 downto 0) => digit_val,
			cntr_out(6 downto 4) => digit_no );

	
	Digit_Decoder	:	decoder_7seg
		port map(
			digit_data => digit_val, 
			sevenseg => sevenseg_out );

			
   DIGIT_No_Decoder	:	decoder_3to8
		port map(
			in_no => digit_no,
			out_lines => anodes_out );


end  Behavioral;







