----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:11:55 07/14/2012 
-- Design Name: 
-- Module Name:    reg1in2out - Behavioral 
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

entity reg1in2out is
    Port ( CLK : in STD_LOGIC;
			  IN1 : in  STD_LOGIC_VECTOR (31 downto 0);
           OUT1 : out  STD_LOGIC_VECTOR (31 downto 0);
           OUT2 : out  STD_LOGIC_VECTOR (31 downto 0);
           LDEN : in  STD_LOGIC;
           DR1EN : in  STD_LOGIC;
           DR2EN : in  STD_LOGIC);
end reg1in2out;

architecture Behavioral of reg1in2out is

signal VALUE : STD_LOGIC_VECTOR (31 downto 0);
begin


	WITH DR1EN SELECT
    OUT1 <= VALUE WHEN '1',
		    (others => 'Z') WHEN OTHERS;

	WITH DR2EN SELECT
    OUT2 <= VALUE WHEN '1',
	      (others => 'Z') WHEN OTHERS;	

process(clk)
begin
	if (rising_edge(clk) and LDEN = '1') THEN
			VALUE <= IN1;
		end if;
end process;


end Behavioral;

