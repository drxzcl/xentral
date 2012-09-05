----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:25:41 07/16/2012 
-- Design Name: 
-- Module Name:    CODEROM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CODEROM is
    Port ( MAR : in  STD_LOGIC_VECTOR (31 downto 0);
           MCR : out  STD_LOGIC_VECTOR (31 downto 0)
			  			  
			  );
end CODEROM;

architecture Behavioral of CODEROM is
signal IMCR : STD_LOGIC_VECTOR (31 downto 0);
begin
WITH MAR SELECT
		IMCR <= 
		X"1ffffff9" WHEN X"00000000",
X"1f0f0f01" WHEN X"00000001",
X"10f0f0f2" WHEN X"00000002",
X"10000013" WHEN X"00000003",
X"0000a107" WHEN X"00000004",
X"00006178" WHEN X"00000005",
X"d300000a" WHEN X"00000006",
X"00005737" WHEN X"00000007",
X"00006178" WHEN X"00000008",
X"d2000007" WHEN X"00000009",
X"00006178" WHEN X"0000000a",
X"d1000005" WHEN X"0000000b",
X"00006718" WHEN X"0000000c",
X"d0000003" WHEN X"0000000d",
X"1aaaaaa1" WHEN X"0000000e",
X"f000000e" WHEN X"0000000f",
X"1bbbbbb1" WHEN X"00000010",
X"f0000010" WHEN X"00000011",
		
	
			(others => '0') WHEN OTHERS;			


	MCR <= IMCR;

end Behavioral;

