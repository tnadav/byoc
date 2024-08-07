-- This module is the Fetch Unit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration for Fetch_Unit
entity Fetch_Unit is
Port (
    -- Clock and reset signals
    CK_25MHz        : in STD_LOGIC;
    RESET_in        : in STD_LOGIC;
    HOLD_in         : in STD_LOGIC;
    -- IMem signals
    MIPS_IMem_adrs  : out STD_LOGIC_VECTOR (31 downto 0); 
    MIPS_IMem_rd_data : in STD_LOGIC_VECTOR (31 downto 0);
    -- Readback signals
    rdbk0           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk1           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk2           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk3           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk4           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk5           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk6           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk7           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk8           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk9           : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk10          : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk11          : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk12          : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk13          : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk14          : out STD_LOGIC_VECTOR (31 downto 0);
    rdbk15          : out STD_LOGIC_VECTOR (31 downto 0)
);
end Fetch_Unit;

architecture Behavioral of Fetch_Unit is

-- Signal declarations
signal PC_reg, PC_plus_4, branch_adrs, jr_adrs, jump_adrs : STD_LOGIC_VECTOR(31 downto 0);
signal PC_mux_out, IR_reg, rdbk_vec1 : STD_LOGIC_VECTOR(31 downto 0);
signal opcode : STD_LOGIC_VECTOR(5 downto 0);
signal funct : STD_LOGIC_VECTOR(5 downto 0);
signal PC_source : STD_LOGIC_VECTOR(1 downto 0);

begin
    -- Connect PC_reg to IMem
    IMem_adrs <= PC_reg;

    -- PC Adder: increment PC by 4
    -- Placeholder for PC_plus_4 signal generation

    -- Instruction Register
    -- Placeholder for IR_reg signal (rename of IMem_rd_data)

    -- Immediate sign extension
    -- Placeholder for sext_imm signal

    -- Branch address
    -- Placeholder for branch_adrs signal

    -- Jump address
    -- Placeholder for jump_adrs signal

    -- JR address
    -- Placeholder for jr_adrs signal

    -- Delayed PC_plus_4 register
    -- Placeholder for PC_plus_4_pID signal

    -- Instruction decoder
    opcode <= IR_reg(31 downto 26);
    funct <= IR_reg(5 downto 0);

    -- PC source decoder
    -- Placeholder for PC_source signal

    -- Readback signals
    rdbk0 <= PC_reg;
    rdbk1 <= PC_plus_4;
    rdbk2 <= branch_adrs;
    rdbk3 <= jr_adrs;
    rdbk4 <= jump_adrs;
    rdbk5 <= PC_plus_4_pID;
    rdbk6 <= IR_reg;
    rdbk7 <= rdbk_vec1;  -- PC_source
    rdbk8 <= PC_mux_out;
    rdbk9 <= x"00000000";
    rdbk10 <= x"00000000";
    rdbk11 <= x"00000000";
    rdbk12 <= x"00000000";
    rdbk13 <= x"00000000";
    rdbk14 <= x"00000000";
    rdbk15 <= x"00000000";

    rdbk_vec1 <= x"0000000" & b"00" & PC_source;

end Behavioral;
