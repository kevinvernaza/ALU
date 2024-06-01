library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu1 is
  port (
    A, B : in std_logic_vector(7 downto 0);
    ALU_sel : in std_logic_vector(2 downto 0);
    NZVC : out std_logic_vector(3 downto 0);
    result : out std_logic_vector(7 downto 0)
  );
end alu1;

architecture arch_alu of alu1 is
begin
  ALU_PROCESS : process (A, B, ALU_sel)
    variable Sum_uns : unsigned(8 downto 0);
    variable Sub_uns : signed(8 downto 0); -- Use signed for proper overflow detection
    variable and_uns : unsigned(7 downto 0);
    variable or_uns  : unsigned(7 downto 0);
  begin
    if (ALU_sel = "000") then
      -- Sum Calculation
      Sum_uns := unsigned('0' & A) + unsigned('0' & B);
      result <= std_logic_vector(Sum_uns(7 downto 0));
      
      -- Negative Flag (N)
      NZVC(3) <= Sum_uns(7);

      -- Zero Flag (Z)
      if (Sum_uns(7 downto 0) = x"00") then
        NZVC(2) <= '1';
      else
        NZVC(2) <= '0';
      end if;

      -- Overflow Flag (V)
      if ((A(7) = '0' and B(7) = '0' and Sum_uns(7) = '1') or
          (A(7) = '1' and B(7) = '1' and Sum_uns(7) = '0')) then
        NZVC(1) <= '1';
      else
        NZVC(1) <= '0';
      end if;

      -- Carry Flag (C)
      NZVC(0) <= Sum_uns(8);

    elsif (ALU_sel = "001") then
      -- Rest Calculation
      Sub_uns := signed('0' & A) - signed('0' & B);
      result <= std_logic_vector(Sub_uns(7 downto 0));

      -- Negative Flag (N)
      NZVC(3) <= Sub_uns(7);

      -- Zero Flag (Z)
      if (Sub_uns(7 downto 0) = x"00") then
        NZVC(2) <= '1';
      else
        NZVC(2) <= '0';
      end if;

      -- Overflow Flag (V)
      if ((A(7) = '0' and B(7) = '1' and Sub_uns(7) = '1') or
          (A(7) = '1' and B(7) = '0' and Sub_uns(7) = '0')) then
        NZVC(1) <= '1';
      else
        NZVC(1) <= '0';
      end if;

      -- Carry Flag (C) (adjusted for subtraction)
      if (unsigned(A) < unsigned(B)) then
        NZVC(0) <= '1';
      else
        NZVC(0) <= '0';
      end if;

    elsif (ALU_sel = "010") then
      -- And Calculation
      and_uns := unsigned(A) and unsigned(B);
      result <= std_logic_vector(and_uns);

    elsif (ALU_sel = "011") then
      -- Or Calculation
      or_uns := unsigned(A) or unsigned(B);
      result <= std_logic_vector(or_uns);

    end if;
  end process;
end arch_alu;