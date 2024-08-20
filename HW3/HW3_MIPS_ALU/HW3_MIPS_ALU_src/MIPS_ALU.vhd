--
-- 
-- This module is the MIPS ALU 
--  
--   
--
---------------------------------------------------------------------------------
library  IEEE ;
use  IEEE.STD_LOGIC_1164.ALL;
use  IEEE.STD_LOGIC_ARITH.ALL;
use  IEEE.STD_LOGIC_UNSIGNED.ALL;

-- *********************************************************************************************
-- *********************************************************************************************

entity MIPS_ALU is
Port(	
-- control inputs (determin ALU operation)
ALUOP		:  in STD_LOGIC_VECTOR(1 downto 0); -- 00=add, 01=sub, 10=by Function
Funct		:  in STD_LOGIC_VECTOR(5 downto 0); -- 32=ADD, 34=sub, 36=AND, 37=OR, 38=XOR, 42=SLT
-- data inputs & data control 
A_in		:  in STD_LOGIC_VECTOR(31 downto 0);
B_in		:  in STD_LOGIC_VECTOR(31 downto 0);
sext_imm	:  in STD_LOGIC_VECTOR(31 downto 0);
ALUsrcB		:  in STD_LOGIC;
-- data output
ALU_out		:  out STD_LOGIC_VECTOR(31 downto 0)
	) ;
end MIPS_ALU;
 

architecture  Behavioral  of  MIPS_ALU  is
		   
-- **********************************************************************************************
-- **********************************************************************************************


-- inner signals
-- =================
signal  ALU_cmd    :   STD_LOGIC_VECTOR  (2 downto 0) ; -- 000=AND, 001=OR, 010=ADD, 011=XOR, 110=sub, 111=slt, 100 & 101= not used for now
signal  ALU_A_in   :   STD_LOGIC_VECTOR  (31 downto 0);
signal  ALU_B_in   :   STD_LOGIC_VECTOR  (31 downto 0);
signal  ALU_output :   STD_LOGIC_VECTOR  (31 downto 0);



begin

process (ALUOP, Funct)
begin
    case ALUOP is
        when "01" =>
            ALU_cmd <= "110";
         when "10" =>
            case Funct is
                when "100000" =>
                    ALU_cmd <= "010";
                when "100010" =>
                    ALU_cmd <= "110";
                when "100100" =>
                    ALU_cmd <= "000";
                when "100101" =>
                    ALU_cmd <= "001";
                when "100110" =>
                    ALU_cmd <= "011";
                when "101010" =>
                    ALU_cmd <= "111";
                when others =>
                    ALU_cmd <= "110";
            end case;
         when others =>
            ALU_cmd <= "010";
           end case;
end process;

ALU_A_in <= A_in;

process (ALUsrcB, B_in, sext_imm)
begin
    if ALUsrcB = '0' then
        ALU_B_in <= B_in;
    else
        ALU_B_in <= sext_imm;
    end if;
end process;

process (ALU_cmd, ALU_A_in, ALU_B_in)
begin
	case ALU_cmd is
		when "000" =>
			ALU_output <= ALU_A_in and ALU_B_in;
		when "001" =>
			ALU_output <= ALU_A_in or ALU_B_in;
		when "010" =>
			ALU_output <= ALU_A_in + ALU_B_in;
		when "011" =>
			ALU_output <= ALU_A_in xor ALU_B_in;
		when "100" =>
			ALU_output <= ALU_A_in nand ALU_B_in;
		when "101" =>
			ALU_output <= ALU_A_in nor ALU_B_in;
		when "110" =>
			ALU_output <= ALU_A_in - ALU_B_in;
		when others =>
            if ALU_A_in(31) = ALU_B_in(31) then
                if ALU_A_in < ALU_B_in then -- This needs to be: (A-B)(33) (need to define a new vector for 33 bit)
				    ALU_output <= x"0000000" & "0001";
			    else
				    ALU_output <= x"00000000";
			    end if;
            else
                if ALU_A_in(31) = '1' then
                    ALU_output <= x"0000000" & "0001";
                else
                    ALU_output <= x"00000000";
                end if;
            end if;
			
		end case;
end process;

ALU_out <= ALU_output;

end  Behavioral;

-- **********************************************************************************************
-- **********************************************************************************************

