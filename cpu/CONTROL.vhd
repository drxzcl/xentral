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
			  CONTR: out STD_LOGIC_VECTOR (31 downto 0);
           IMM : out  STD_LOGIC_VECTOR (31 downto 0);
           FLAGS: in  STD_LOGIC_VECTOR (7 downto 0);
			  SPINC: out STD_LOGIC; -- Control the inc/dec of the
			  SPDEC: out STD_LOGIC; -- stack pointer register.
			  NPC: in STD_LOGIC_VECTOR (31 downto 0);
			  CODEROM_ADDRESS: out STD_LOGIC_VECTOR(31 downto 0);
			  CODEROM_INSTRUCTION: in STD_LOGIC_VECTOR(31 downto 0)
			  );
end CONTROL;

architecture Behavioral of CONTROL is

--signal CONTR: STD_LOGIC_VECTOR (31 downto 0);
signal IR: STD_LOGIC_VECTOR (31 downto 0);
signal PC: STD_LOGIC_VECTOR (31 downto 0);
signal PHASE: STD_LOGIC_VECTOR (3 downto 0); -- for multiclock instructions

begin

	--CODEROM : entity work.CODEROM port map(PC,IR);
	CODEROM_ADDRESS <= PC;
	IR <= CODEROM_INSTRUCTION;

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
			case IR(31 downto 28) is
				when X"0" =>
					-- Regular bus arbitration
					CONTR <= IR;
					PC <= unsigned(PC) + 1;								
				when X"1" =>
					-- Immediate register load, signed value in IR
					IMM <= SXT(IR(27 downto 4), IMM'length); -- Sign extension 
					CONTR <= X"0000AB0" & IR(3 downto 0);	-- IRR(3 downto 0) <- IMM. 										
					PC <= unsigned(PC) + 1;								
				when X"2" =>
					-- Indirect register load
					case PHASE is
						when X"0" =>
							-- Tranfer bottom ALU operation into MAR	
							CONTR <= X"0000" & IR(15 downto 4) & X"C";	
							PHASE <= unsigned(phase) + 1;
						when others =>
							-- Transfer MBR + top ALU into output register
							CONTR <= X"0000" & IR(27 downto 24) & X"D" & IR(19 downto 16) & IR(3 downto 0);							
							-- end of instruction, load the next instruction
							PHASE <= (others => '0');
							PC <= unsigned(PC) + 1;	
						end case;
				when X"3" =>
					-- Indirect register store
					-- (Store the contents of rN at the address in rM)
					case PHASE is
						when X"0" =>
							-- Tranfer bottom ALU operation into MAR	
							CONTR <= X"0000" & IR(15 downto 4) & X"C";	
							PHASE <= unsigned(phase) + 1;
						when others =>
							-- Transfer top ALU operation into MBR
							CONTR <= X"0000" & IR(27 downto 16) & X"D";							
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
							CONTR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
							SPDEC <= '1';
						when others =>
							-- Transfer bus3 into MBR 
							CONTR <= X"0000" & IR(15 downto 4) & X"D";	-- use operation and operands from instr.
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
							CONTR <= X"00000000"; 
							PHASE <= unsigned(phase) + 1;
						when X"1" =>
							-- Tranfer SP into MAR
							SPINC <= '0';
							CONTR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
						when others =>
							-- Transfer MBR (D, bus1) into bus3
							CONTR <= X"0000AD0" & IR(3 downto 0);	
							PHASE <= (others => '0');
							PC <= unsigned(PC) + 1;	
						end case;
				when X"6" =>
				-- CALL
					case PHASE is
						when X"0" =>
							-- DEC SP, Tranfer SP into MAR
							CONTR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
							SPDEC <= '1';
						when others =>
							-- Transfer PC into bus1 into MBR 
							-- JUMP!
							CONTR <= X"0000AB0D";	-- use operation and operands from instr.
							IMM <= unsigned(PC)+1; -- Tristate the immediate value output							
							SPDEC <= '0';
							PHASE <= (others => '0');
							PC <= X"0" & IR(27 downto 0);
						end case;
				when X"7" =>
					-- RET
					case PHASE is
						when X"0" =>
							-- dec SP
							SPINC <= '1';
							CONTR <= X"00000000"; 
							PHASE <= unsigned(phase) + 1;
						when X"1" =>
							-- Tranfer SP into MAR
							SPINC <= '0';
							CONTR <= X"0000A90C"; 
							PHASE <= unsigned(phase) + 1;
						when X"2" =>
							-- Transfer MBR (D, bus1) into PC
							CONTR <= X"0000AD00";
							PHASE <= unsigned(phase) + 1;
						when others =>
						   -- JUMP
							PC <= NPC;	
							PHASE <= (others => '0');
						end case;
				when X"d" =>
					-- Conditional relative jump
					CONTR <= (others => '0'); -- Tristate everything so execution unit state is preserved
					-- Wait a cycle to allow the execution unit to catch up.
					case PHASE is
						when X"0" =>
							PHASE <= unsigned(phase) + 1;
						when others =>
							PHASE <= (others => '0');
							case IR(27 downto 24) is
								when X"0" =>
									-- JS
									if FLAGS(1) = '1' then							
										PC <= PC + SXT(IR(23 downto 0), PC'length);
									else
										PC <= PC + 1;
									end if;
								when X"1" =>
									-- JNS
									if FLAGS(1) = '0' then
										PC <= PC + SXT(IR(23 downto 0), PC'length);
									else
										PC <= PC + 1;
									end if;
								when X"2" =>
									-- JZ
									if FLAGS(0) = '1' then
										PC <= PC + SXT(IR(23 downto 0), PC'length);
									else
										PC <= PC + 1;
									end if;
								when X"3" =>
									-- JNZ
									if FLAGS(0) = '0' then
										PC <= PC + SXT(IR(23 downto 0), PC'length);
									else
										PC <= PC + 1;
									end if;
								when others =>
									null;
							end case;
						end case;
				when X"e" =>
					-- Indexed jump
					-- Jump to the address on BUS3.
					-- Transfer bus3 into NPC 
					CONTR <= X"0000" & IR(15 downto 4) & X"0";	-- use operation and operands from instr.
					PC <= NPC;											
				when X"f" =>
					-- Absolute jump!
					CONTR <= (others => '0'); -- Tristate everything so execution unit state is preserved
					-- Since we only have 28 bits available for the address, take over the high nibble from PC
					PC(27 downto 0) <= IR(27 downto 0);
				when others =>
					null;
			end case;
		end if;
	end if;
end process;

end Behavioral;

