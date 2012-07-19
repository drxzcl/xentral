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
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

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
           DR2EN : in  STD_LOGIC;
			  
			  -- Signals to handle in-place increment/decrement.
			  -- If you are not going to use them, it's ok to leave them unconnected.
			  -- The synthesizer will get rid of them and the associated logic (adder/sub)
			  INC: in STD_LOGIC := '0'; 
			  DEC: in STD_LOGIC := '0'   					
			  );
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
	if rising_edge(clk) then
		if LDEN = '1' then
			VALUE <= IN1;		
		else
			if INC = '1' then
				VALUE <= unsigned(VALUE) + 1;
			else 
				if DEC = '1' then
					VALUE <= unsigned(VALUE) - 1;
				end if;
			end if;
		end if;
	end if;		
end process;


end Behavioral;

