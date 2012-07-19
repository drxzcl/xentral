----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:17:40 07/19/2012 
-- Design Name: 
-- Module Name:    DRIVESEL - Behavioral 
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

entity DRIVESEL is Port ( 
	sel : in  STD_LOGIC_VECTOR (3 downto 0);
	output : out STD_LOGIC_VECTOR (31 downto 0);
	input0 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input1 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input2 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input3 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input4 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input5 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input6 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input7 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input8 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input9 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input10 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input11 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input12 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input13 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input14 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000";
	input15 : in STD_LOGIC_VECTOR (31 downto 0):= X"00000000");
end DRIVESEL;

architecture Behavioral of DRIVESEL is
begin

WITH sel SELECT
		output <= 
			input0	WHEN X"0",
			input1	WHEN X"1",
			input2	WHEN X"2",
			input3	WHEN X"3",
			input4	WHEN X"4",
			input5	WHEN X"5",
			input6	WHEN X"6",
			input7	WHEN X"7",
			input8	WHEN X"8",
			input9	WHEN X"9",
			input10	WHEN X"a",
			input11	WHEN X"b",
			input12	WHEN X"c",
			input13	WHEN X"d",
			input14	WHEN X"e",
			input15	WHEN X"f",
			x"DEADBEEF" when others;

end Behavioral;

