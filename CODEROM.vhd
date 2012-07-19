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
		 X"1FFFFFF9"	WHEN X"00000000", -- Initialize SP
		 X"100000C1"	WHEN X"00000001", -- R1 <- 12
		 --X"0000A90C"	WHEN X"00000002", -- 
		 X"4000A100"	WHEN X"00000002", -- PUSH R1
		 X"50000002"	WHEN X"00000003", -- POP R2
		 X"f0000002"	WHEN X"00000004", -- JMP 2
			
		 -- Fill memory with counter using multi-clock instructions
--		 X"1FFFFFA1"	WHEN X"00000000", -- R1 <- -5
--		 X"30000110"	WHEN X"00000001", -- [R1] <- R1
--		 X"20000103"   WHEN X"00000002", -- R3 <- [R1]
--		 X"000051F2"	WHEN X"00000003", -- R2 <- R1 + 1
--		 X"0000A201"	WHEN X"00000005", -- R1 <- R2
--		 X"f0000001"	WHEN X"00000006", -- JMP 1

		
	
--		 -- Fill memory with counter		 
--		 X"1FFFFFA1"	WHEN X"00000000", -- R1 <- -5
--		 X"0000A10C"	WHEN X"00000001", -- MAR <- R1
--		 X"0000A10D"	WHEN X"00000002", -- MBR <- R1
--		 X"000051F2"	WHEN X"00000003", -- R2 <- R1 + 1
--		 X"0000A201"	WHEN X"00000005", -- R1 <- R2
--		 X"f0000001"	WHEN X"00000006", -- JMP 1
		
			(others => '0') WHEN OTHERS;			


	MCR <= IMCR;

end Behavioral;

