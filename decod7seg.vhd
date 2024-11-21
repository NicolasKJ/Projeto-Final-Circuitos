library IEEE;
use IEEE.Std_Logic_1164.all;

entity decod7seg is
port (X:  in std_logic_vector(3 downto 0);
      Y:  out std_logic_vector(6 downto 0) );
end decod7seg;

architecture behavior of decod7seg is
begin
    with X select
        Y <= "0000001" when "0000", -- 0
             "1001111" when "0001", -- 1
             "0010010" when "0010", -- 2
             "0000110" when "0011", -- 3
             "1001100" when "0100", -- 4
             "0100100" when "0101", -- 5
             "0100000" when "0110", -- 6
             "0001111" when "0111", -- 7
             "0000000" when "1000", -- 8
             "0000100" when "1001", -- 9
             "1110001" when "1010", -- t
             "1010100" when "1011", -- n
             "1010000" when "1100", -- r
             "0001000" when "1101", -- A
             "1111111" when others; -- Apaga
end behavior;