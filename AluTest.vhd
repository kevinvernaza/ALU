library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AluTest is

   port (
	      A, B : in std_logic_vector(7 downto 0);
		   ALU_sel : in std_logic_vector(2 downto 0);
		   NZVC : out std_logic_vector(3 downto 0);
		   deco1, deco2, deco3, deco4 : out std_logic_vector(6 downto 0));
end aluTest;

architecture arch_AluTest of AluTest is

component alu1 is
  port (
        A, B    : in std_logic_vector(7 downto 0);
		  ALU_sel : in std_logic_vector(2 downto 0);
		  NZVC    : out std_logic_vector(3 downto 0);
		  result  : out std_logic_vector(7 downto 0)); 
end component; 

component Displays7Seg4bits is
   port  (
	abcd : in std_logic_vector(3 downto 0) ;
	salida: out std_logic_vector(6 downto 0));
end component;

signal senalB, senalResult : std_logic_vector(7 downto 0);
signal senalB1, senalB2, senalResult1, senalResult2 : std_logic_vector( 3 downto 0);

   begin 
	
	   senalB <= B;
	
	   paso1 : alu1 port map (A => A, B => B, Alu_sel => Alu_sel, NZVC => NZVC, result => senalResult);
		
		senalB1     <= senalB(7 downto 4);
		senalB2      <= senalB(3 downto 0);
		senalResult1 <= senalResult(7 downto 4);
		senalResult2 <= senalResult(3 downto 0);
		
		paso2 : displays7Seg4bits port map (abcd => senalB1, salida =>deco1);
		paso3 : displays7Seg4bits port map (abcd => senalB2, salida =>deco2);
		paso4 : displays7Seg4bits port map (abcd => senalResult1, salida =>deco3);
		paso5 : displays7Seg4bits port map (abcd => senalResult2, salida =>deco4);


end arch_AluTest;