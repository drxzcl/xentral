----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:57:45 07/15/2012 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
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

use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity CONTROL is
    Port ( CLK : in STD_LOGIC;
			  RESET: in STD_LOGIC;
			  DR1 : out  STD_LOGIC_VECTOR (3 downto 0);
           DR2 : out  STD_LOGIC_VECTOR (3 downto 0);
           LD3 : out  STD_LOGIC_VECTOR (3 downto 0);
           OP : out  STD_LOGIC_VECTOR (3 downto 0);
           IMM : out  STD_LOGIC_VECTOR (31 downto 0);
           FLAGS: in  STD_LOGIC_VECTOR (7 downto 0);
			  SPINC: out STD_LOGIC; -- Control the inc/dec of the
			  SPDEC: out STD_LOGIC; -- stack pointer register.
			  NPC: in STD_LOGIC_VECTOR (31 downto 0)
			  );
end CONTROL;

architecture Behavioral of CONTROL is

signal IR: STD_LOGIC_VECTOR (31 downto 0);
signal IIR: STD_LOGIC_VECTOR (31 downto 0);
signal PC: STD_LOGIC_VECTOR (31 downto 0);
signal PHASE: STD_LOGIC_VECTOR (3 downto 0); -- for multiclock instructions

begin

	CODEROM : entity work.CODEROM port map(PC,IIR);

	
	
	-- Simply mirror parts of the IR to the driver signals
	LD3 <= IR(3 downto 0);
	DR2 <= IR(7 downto 4);
	DR1 <= IR(11 downto 8);
	OP <= IR(15 downto 12);	


process(clk)
begin
	if (rising_edge(clk)) THEN
		if (RESET = '1') THEN
			PC <= (others => '0');
			PHASE <= (others => '0');			
			SPINC <= '0';
			SPDEC <= '0';
		else 
			-- Make sure decrementers and stuff do not bleed
			case IIR(31 downto 28) is
				when X"0" =>
					-- Regular bus arbitration
					IR <= IIR;
					PC <= unsigned(PC) + 1;								
				when X"1" =>
					-- Immediate register load, signed value in IIR
					IMM <= SXT(IIR(27 downto 4), IMM'length); -- Sign extension 
					IR <= X"0000AB0" & IIR(3 downto 0);	-- IRR(3 downto 0) <- IMM. Don't drive bus 1 from the execution unit.										
					PC <= unsigned(PC) + 1;								
				when X"2" =>
					-- Indirect register load
					case PHASE is
						when X"0" =>
							-- Tranfer input register into MAR	
							IR <= X"0000A" & IIR(11 downto 8) & X"0C";
							PHASE <= unsigned(phase) + 1;
						when others =>
							-- Transfer MBR into output register
							IR <= X"0000AD0" & IIR(3 downto 0);							
							-- end of instruction, load the next instruction
							PHASE <= (others => '0');
							PC <= unsigned(PC) + 1;	
						end case;
				when X"3" =>
					-- Indirect register store
					-- (Store the contents of rN at the address in rM)
					case PHASE is
						when X"0" =>
							-- Tranfer dest register into MAR	
							IR <= X"0000B0" & IIR(7 downto 4) & X"C";	
							PHASE <= unsigned(phase) + 1;
						when others =>
							-- Transfer source register into MBR
							IR <= X"0000A" & IIR(11 downto 8) & X"0D";							
							-- end of instruction, load the next instruction
							PHASE <= (others => '0');
							PC <= unsigned(PC) + 1;	
						end case;
				when X"4" =>
					-- push
					-- Push whatever comes out of bus3
					case PHASE is
						when X"0" =>
							-- DEC SP, Tranfer SP into MAR
							IR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
							SPDEC <= '1';
						when others =>
							-- Transfer bus3 into MBR 
							IR <= X"0000" & IIR(15 downto 4) & X"D";	-- use operation and operands from instr.
							SPDEC <= '0';
							PHASE <= (others => '0');
							PC <= unsigned(PC) + 1;	
						end case;
				when X"5" =>
					-- pop
					-- pop top of stack into destination register
					case PHASE is
						when X"0" =>
							-- dec SP
							SPINC <= '1';
							IR <= X"00000000"; 
							PHASE <= unsigned(phase) + 1;
						when X"1" =>
							-- Tranfer SP into MAR
							SPINC <= '0';
							IR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
						when others =>
							-- Transfer MBR (D, bus1) into bus3
							IR <= X"0000AD0" & IIR(3 downto 0);	
							PHASE <= (others => '0');
							PC <= unsigned(PC) + 1;	
						end case;
				when X"6" =>
				-- CALL
					case PHASE is
						when X"0" =>
							-- DEC SP, Tranfer SP into MAR
							IR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
							SPDEC <= '1';
						when others =>
							-- Transfer PC into bus1 into MBR 
							-- JUMP!
							IR <= X"0000A00D";	-- use operation and operands from instr.
							IMM <= unsigned(PC)+1; -- Tristate the immediate value output							
							SPDEC <= '0';
							PHASE <= (others => '0');
							PC <= X"0" & IIR(27 downto 0);
						end case;
				when X"7" =>
					-- RET
					case PHASE is
						when X"0" =>
							-- dec SP
							SPINC <= '1';
							IR <= X"00000000"; 
							PHASE <= unsigned(phase) + 1;
						when X"1" =>
							-- Tranfer SP into MAR
							SPINC <= '0';
							IR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
						when X"2" =>
							-- Transfer MBR (D, bus1) into PC
							IR <= X"0000AD00";
							PHASE <= unsigned(phase) + 1;
						when others =>
						   -- JUMP
							PC <= NPC;	
							PHASE <= (others => '0');
						end case;						
				when X"b" =>
					-- JS
					if FLAGS(1) = '1' then
						IR <= (others => '0'); -- Tristate everything so execution unit state is preserved
						PC <= X"0" & IIR(27 downto 0);						
					end if;
				when X"c" =>
					-- JNS
					if FLAGS(1) = '0' then
						IR <= (others => '0'); -- Tristate everything so execution unit state is preserved
						PC <= X"0" & IIR(27 downto 0);						
					end if;
				when X"d" =>
					-- JZ
					if FLAGS(0) = '1' then
						IR <= (others => '0'); -- Tristate everything so execution unit state is preserved
						PC <= X"0" & IIR(27 downto 0);						
					end if;
				when X"e" =>
					-- JNZ
					if FLAGS(0) = '0' then
						IR <= (others => '0'); -- Tristate everything so execution unit state is preserved
						PC <= X"0" & IIR(27 downto 0);						
					end if;
				when X"f" =>
					-- Absolute jump!
					IR <= (others => '0'); -- Tristate everything so execution unit state is preserved
					PC <= X"0" & IIR(27 downto 0);
				when others =>
					null;
			end case;

		end if;
	end if;
end process;

end Behavioral;

