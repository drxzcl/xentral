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

	signal DR1EN: STD_LOGIC_VECTOR (15 downto 0);
	signal DR2EN: STD_LOGIC_VECTOR (15 downto 0);
	signal LDEN: STD_LOGIC_VECTOR (15 downto 0);
	
	signal ALUFLAGS: STD_LOGIC_VECTOR (3 downto 0);
	signal FLAGS: STD_LOGIC_VECTOR (7 downto 0);
	
begin
	
	--CODEROM : entity work.CODEROM port map(bus3,bus1,DR1EN);
	CONTROL : entity work.CONTROL port map(CLK,RESET,DR1,DR2,LD3,OP,bus1,FLAGS);

	RAM : entity work.SIMPLERAM port map(clk,LDEN(12),LDEN(13),DR1EN(13),bus3(7 downto 0),bus3,bus1);
	
	DEMUX1 : entity work.DEMUX16 port map(DR1,DR1EN);
	DEMUX2 : entity work.DEMUX16 port map(DR2,DR2EN);
	DEMUX3 : entity work.DEMUX16 port map(LD3,LDEN);
	
	ALU1 : entity work.ALU port map(bus1,bus2,OP,bus3,ALUFLAGS);
	
	CONST0 : entity work.CONST generic map(X"00000000") port map (DR1EN(15),bus1);
	CONST1 : entity work.CONST generic map(X"00000001") port map (DR2EN(15),bus2);
	--DEADBEEF : entity work.CONST generic map(X"DEADBEEF") port map (DR1EN(14),bus1);
	--BEEFDEAD : entity work.CONST generic map(X"BEEFDEAD") port map (DR2EN(14),bus2);
	
	R1 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(1),DR1EN(1),DR2EN(1));
	R2 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(2),DR1EN(2),DR2EN(2));
	R3 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(3),DR1EN(3),DR2EN(3));
	R4 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(4),DR1EN(4),DR2EN(4));
	R5 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(5),DR1EN(5),DR2EN(5));
	R6 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(6),DR1EN(6),DR2EN(6));
	R7 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(7),DR1EN(7),DR2EN(7));
	R8 : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(8),DR1EN(8),DR2EN(8));
	SP : entity work.reg1in2out port map (clk,bus3,bus1,bus2,LDEN(9),DR1EN(9),DR2EN(9));

process(clk)
begin
	if (rising_edge(clk)) THEN
			FLAGS(3 downto 0) <= ALUFLAGS;
		end if;
end process;

end Behavioral;

