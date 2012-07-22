----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:27:29 07/11/2012 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port ( A,B : in STD_LOGIC_VECTOR (31 downto 0);
           OP : in  STD_LOGIC_VECTOR (3 downto 0);
           R : out  STD_LOGIC_VECTOR (31 downto 0);
           ALUFLAGS : out STD_LOGIC_VECTOR(3 downto 0)
           );
end ALU;

architecture Behavioral of ALU is
signal RR: STD_LOGIC_VECTOR (32 downto 0); -- extra bit for carry
begin      
   WITH OP SELECT
      RR <= '0'&A and '0'&B    WHEN X"0",
         '0'&A or '0'&B       WHEN X"1",
         '0'&A xor '0'&B      WHEN X"2",
         '0'&A nand '0'&B   WHEN X"3",
         '0'&A nor '0'&B      WHEN X"4",
         unsigned('0'&A) + unsigned('0'&B)       WHEN X"5",
         unsigned('0'&A) - unsigned('0'&B)       WHEN X"6",
         not '0'&A       WHEN X"7",
         '0'&A          WHEN X"A",
         '0'&B         WHEN X"B",
         (others => '0') WHEN OTHERS;   
   -- Output
   R <= RR(31 downto 0);
   -- Flags
   ALUFLAGS(1) <= RR(31); -- SIGN
   ALUFLAGS(2) <= RR(32); -- CARRY
   WITH RR(31 downto 0) SELECT ALUFLAGS(0) -- ZERO
      <= '1' WHEN X"00000000",
         '0' WHEN OTHERS;
   
end Behavioral;

