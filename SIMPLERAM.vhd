library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity SIMPLERAM is
  port (
    clock   : in  std_logic;
    LDADDRESS : in  std_logic;
    LDDATAIN  : in  std_logic;
    DRDATAOUT : in  std_logic;
    address : in  std_logic_vector;
    datain  : in  std_logic_vector;
    dataout : out std_logic_vector
  );
end entity SIMPLERAM;

architecture Behavioral of SIMPLERAM is

   type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);
   signal ram : ram_type;
   signal read_address : std_logic_vector(address'range);

begin


  RamProc: process(clock) is

  begin
    if rising_edge(clock) then
      if LDDATAIN = '1' then
        ram(to_integer(unsigned(read_address))) <= datain;
      end if;
		if LDADDRESS = '1' then
			read_address <= address;
		end if;
--		if DRDATAOUT = '1' then
--			dataout <= ram(to_integer(unsigned(read_address)));
--		else
--		    dataout <=(others => 'Z');
--		end if;
	end if;
  end process RamProc;


WITH DRDATAOUT SELECT
    dataout <= ram(to_integer(unsigned(read_address))) WHEN '1',
	 (others => 'Z') WHEN OTHERS;	
  
end architecture Behavioral;