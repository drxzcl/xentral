----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:41:34 07/14/2012 
-- Design Name: 
-- Module Name:    DEMUX16 - Behavioral 
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

entity DEMUX16 is
    Port ( sel : in  STD_LOGIC_VECTOR (3 downto 0);
           demuxout : out  STD_LOGIC_VECTOR (15 downto 0));
end DEMUX16;

architecture Behavioral of DEMUX16 is

begin
	WITH sel SELECT
    demuxout <= 
			"0000000000000001" WHEN X"0",
			"0000000000000010" WHEN X"1",
			"0000000000000100" WHEN X"2",
			"0000000000001000" WHEN X"3",
			"0000000000010000" WHEN X"4",
			"0000000000100000" WHEN X"5",
			"0000000001000000" WHEN X"6",
			"0000000010000000" WHEN X"7",
			"0000000100000000" WHEN X"8",
			"0000001000000000" WHEN X"9",
			"0000010000000000" WHEN X"A",
			"0000100000000000" WHEN X"B",
			"0001000000000000" WHEN X"C",
			"0010000000000000" WHEN X"D",
			"0100000000000000" WHEN X"E",
			"1000000000000000" WHEN X"F",
			"0000000000000000" WHEN OTHERS; -- To shut up the synthesizer.
end Behavioral;

