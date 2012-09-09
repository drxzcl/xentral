----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:24:49 07/11/2012 
-- Design Name: 
-- Module Name:    XENTRAL - Behavioral 
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

--library std, work;
--use std.standard.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XENTRAL is
    Port ( clk : in  STD_LOGIC;
			  reset: in STD_LOGIC;
				bus1: inout STD_LOGIC_VECTOR (31 downto 0);
				bus2: inout STD_LOGIC_VECTOR (31 downto 0);
				bus3: inout STD_LOGIC_VECTOR (31 downto 0)
			);
end XENTRAL;

architecture Behavioral of XENTRAL is

	signal DR1: STD_LOGIC_VECTOR (3 downto 0);
	signal DR2: STD_LOGIC_VECTOR (3 downto 0);
	signal LD3: STD_LOGIC_VECTOR (3 downto 0);
	signal OP: STD_LOGIC_VECTOR (3 downto 0);


	signal CONTR: STD_LOGIC_VECTOR (31 downto 0);

	signal LDEN: STD_LOGIC_VECTOR (15 downto 0);
	
	signal ALUFLAGS: STD_LOGIC_VECTOR (3 downto 0);
	signal FLAGS: STD_LOGIC_VECTOR (7 downto 0);
	
	signal SPINC: STD_LOGIC; -- Stack pointer INC/DEC
	signal SPDEC: STD_LOGIC;
	
	-- All driver signals
	signal R1O, R2O, R3O, R4O, R5O, R6O, R7O, R8O, SPO,RAMO,IMMO: STD_LOGIC_VECTOR (31 downto 0);
	
	-- RAM read enable (to avoid sim. read/writes)
	signal RAMREADEN: STD_LOGIC;
	
begin
	CONTROL : entity work.CONTROL port map(CLK,RESET,CONTR,IMMO,FLAGS,SPINC,SPDEC,bus3);

	-- Simply mirror parts of the CONTR to the driver signals
	LD3 <= CONTR(3 downto 0);
	DR2 <= CONTR(7 downto 4);
	DR1 <= CONTR(11 downto 8);
   OP <= CONTR(15 downto 12);	
	
	ALU1 : entity work.ALU port map(bus1,bus2,OP,bus3,ALUFLAGS);
	
	R1 : entity work.reg1in2out port map (clk,bus3,R1O,LDEN(1));
	R2 : entity work.reg1in2out port map (clk,bus3,R2O,LDEN(2));
	R3 : entity work.reg1in2out port map (clk,bus3,R3O,LDEN(3));
	R4 : entity work.reg1in2out port map (clk,bus3,R4O,LDEN(4));
	R5 : entity work.reg1in2out port map (clk,bus3,R5O,LDEN(5));
	R6 : entity work.reg1in2out port map (clk,bus3,R6O,LDEN(6));
	R7 : entity work.reg1in2out port map (clk,bus3,R7O,LDEN(7));
	R8 : entity work.reg1in2out port map (clk,bus3,R8O,LDEN(8));
	SP : entity work.reg1in2out port map (clk,bus3,SPO,LDEN(9),SPINC,SPDEC);

	-- Only read memory when it's being read from the bus.
	-- This prevents read/write conflicts when the synthesizer
	-- implement RAM with single-port block ram.
	WITH DR1 SELECT
		RAMREADEN <= 
			'1' when x"D",
			'0' when others;
		
	RAM : entity work.SIMPLERAM port map(clk,LDEN(12),LDEN(13),RAMREADEN,bus3(7 downto 0),bus3,RAMO);
	
	DRIVESEL1: entity work.DRIVESEL port map(DR1,bus1,
			X"00000000",
			R1O,R2O,R3O,R4O,R5O,R6O,R7O,R8O,
			SPO,
			X"00000000",
			IMMO,
			X"00000000",
			RAMO,
			X"00000000",
			X"00000000"			
			);

	DRIVESEL2: entity work.DRIVESEL port map(DR2,bus2,
			X"00000000",
			R1O,R2O,R3O,R4O,R5O,R6O,R7O,R8O,
			SPO,
			X"00000000",
			X"00000000",
			X"00000000",
			X"00000000",
			X"00000000",
			X"00000001"			
			);

	DECODE3 : entity work.DECODE16 port map(LD3,LDEN);	

	FLAGS(7 downto 4) <= x"0";  -- Tie unused flags to ground to prevent Us from throwing the sim for a loop.

process(clk)
begin
	if (rising_edge(clk)) THEN
			FLAGS(3 downto 0) <= ALUFLAGS;
		end if;
end process;

end Behavioral;

