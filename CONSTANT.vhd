----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:27:38 07/12/2012 
-- Design Name: 
-- Module Name:    CONSTANT - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONST is
	 Generic (C : STD_LOGIC_VECTOR := x"DEADBEEF");
    Port (  DREN: in STD_LOGIC;
				R : out  STD_LOGIC_VECTOR (31 downto 0));
end CONST;

architecture Behavioral of CONST is
begin
	WITH DREN SELECT
    R <= C WHEN '1',
			(others => 'Z') WHEN OTHERS;
end Behavioral;

