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
		X"10000011" WHEN X"00000000",
X"10000022" WHEN X"00000001",
X"00006121" WHEN X"00000002",
X"d0000010" WHEN X"00000003",
X"f0000004" WHEN X"00000004",
		
	
			(others => '0') WHEN OTHERS;			


	MCR <= IMCR;

end Behavioral;

