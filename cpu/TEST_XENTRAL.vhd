--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:40:08 07/12/2012
-- Design Name:   
-- Module Name:   C:/Dev/fpga/xentral/TEST_XENTRAL.vhd
-- Project Name:  xentral
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: XENTRAL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY TEST_XENTRAL IS
END TEST_XENTRAL;
 
ARCHITECTURE behavior OF TEST_XENTRAL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT XENTRAL
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			
			bus1: inout STD_LOGIC_VECTOR (31 downto 0);
			bus2: inout STD_LOGIC_VECTOR (31 downto 0);
			bus3: inout STD_LOGIC_VECTOR (31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   
	--BiDirs
	signal bus1:  STD_LOGIC_VECTOR (31 downto 0);
	signal bus2:  STD_LOGIC_VECTOR (31 downto 0);
	signal bus3:  STD_LOGIC_VECTOR (31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: XENTRAL PORT MAP (
          clk => clk,
          reset => reset,
          bus1 => bus1,
          bus2 => bus2,
          bus3 => bus3
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;
		reset <= '0';

      wait;
   end process;

END;
