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

-- ALU Control Logic: Determines the ALU command (ALU_cmd) based on the ALU operation code (ALUOP)
-- and the function code (Funct) for R-type instructions.
-- The process is triggered by any change in ALUOP or Funct signals.
process (ALUOP, Funct)
begin
    case ALUOP is
        when "01" => -- When ALUOP="01", the ALU performs substraction
            ALU_cmd <= "110"; -- A - B
         when "10" => -- When ALUIP="10", the ALU operation is defermined by Funct
            case Funct is
                when "100000" => -- ADD
                    ALU_cmd <= "010"; -- A + B
                when "100010" => -- SUB
                    ALU_cmd <= "110"; -- A - B
                when "100100" => -- AND
                    ALU_cmd <= "000"; -- A and B
                when "100101" => -- OR
                    ALU_cmd <= "001"; -- A or B
                when "100110" => -- XOR
                    ALU_cmd <= "011"; -- A xor B
                when "101010" => -- SLT
                    ALU_cmd <= "111"; -- 1 if A<B, 0 if not
                when others =>
                    ALU_cmd <= "110";
            end case;
         when others => -- When ALUOP="00", the ALU performs addition
            ALU_cmd <= "010"; -- A + B
           end case;
end process;

ALU_A_in <= A_in;

-- ALU Input Selection for B Operand: Determines the source for the second ALU operand (ALU_B_in).
-- This process is triggered by any change in the ALUsrcB signal, B_in, or sext_imm.
process (ALUsrcB, B_in, sext_imm)
begin
    if ALUsrcB = '0' then
        -- If ALUsrcB is '0', the second ALU operand (ALU_B_in) is taken directly from register B_in.
        ALU_B_in <= B_in;
    else
        -- If ALUsrcB is '1', the second ALU operand (ALU_B_in) is taken from the sign-extended immediate value (sext_imm).
        ALU_B_in <= sext_imm;
    end if;
end process;

-- ALU Operations: Performs the arithmetic or logic operation based on the ALU command (ALU_cmd).
-- The process is triggered by changes in ALU_cmd, ALU_A_in, or ALU_B_in signals.
-- The result of the operation is stored in ALU_output.
process (ALU_cmd, ALU_A_in, ALU_B_in)
begin
	case ALU_cmd is
		when "000" => -- A and B
			ALU_output <= ALU_A_in and ALU_B_in;
		when "001" => -- A or B
			ALU_output <= ALU_A_in or ALU_B_in;
		when "010" => -- A + B
			ALU_output <= ALU_A_in + ALU_B_in;
		when "011" => -- A xor B
			ALU_output <= ALU_A_in xor ALU_B_in;
		when "100" => -- A nand B
			ALU_output <= ALU_A_in nand ALU_B_in;
		when "101" => -- A nor B
			ALU_output <= ALU_A_in nor ALU_B_in;
		when "110" => -- A - B
			ALU_output <= ALU_A_in - ALU_B_in;
		when others => -- ALU_cmd = "111" -> SLT
            -- Check the sign bits of ALU_A_in and ALU_B_in.
            if ALU_A_in(31) = ALU_B_in(31) then
                -- If both operands have the same sign, compare their values directly.

                if ALU_A_in < ALU_B_in then
				    ALU_output <= x"0000000" & "0001";
			    else
				    ALU_output <= x"00000000";
			    end if;
            else
                -- If the operands have different signs, determine which is negative.

                if ALU_A_in(31) = '1' then
                    -- If ALU_A_in is negative, then A < B, set ALU_output to 1
                    ALU_output <= x"0000000" & "0001";
                else
                    -- If ALU_B_in is negative, then A > B, set ALU_output to 0
                    ALU_output <= x"00000000";
                end if;
            end if;
			
		end case;
end process;

ALU_out <= ALU_output;

end  Behavioral;

-- **********************************************************************************************
-- **********************************************************************************************

