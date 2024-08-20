--
-- single_port_memory no CK for read
--
-- Created:
--          by - Danny Seidner, 31/8/2013
--
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY single_port_memory_no_CK_read IS
GENERIC(
    width_in_bits :  integer :=32;
    depth :  integer :=32
  );
PORT (
  wr_address    : in integer range depth-1 downto 0;
  wr_data       : in std_logic_vector(width_in_bits-1 downto 0);
  wr_clk        : in std_logic;
  wr_en         : in std_logic;
  rd_address	: in integer range depth-1 downto 0;
  rd_data		: out std_logic_vector(width_in_bits-1 downto 0)
   ); 
END ENTITY single_port_memory_no_CK_read;

--
ARCHITECTURE single_port_memory OF single_port_memory_no_CK_read IS
type Memory_Type is array ((depth-1) downto 0) of std_logic_vector((width_in_bits-1) downto 0);   
shared variable  Memory_array : Memory_Type := (others => (others =>'0')); -- reset initial value to be 0


BEGIN


Memory_wrdata: PROCESS (wr_clk)
begin 
if wr_clk'event and wr_clk = '1' then
   if wr_en = '1' then
      Memory_array(wr_address) := wr_data;
   end if;
end if ;
end process Memory_wrdata;


Memory_rddata : PROCESS (rd_address,wr_clk) -- need to add wr_clk, otherwise 
                                              -- if we leave rd_address constant, 
                                              -- we won't see changes in rd data even
                                              -- we write new data (in simulation)											  
begin
   rd1_data <= Memory_array(rd_address);
end process Memory_rddata;



END ARCHITECTURE single_port_memory;

 



