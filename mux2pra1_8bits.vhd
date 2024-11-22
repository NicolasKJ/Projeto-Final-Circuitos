library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2pra1_8bits is
    Port (
        sel : in STD_LOGIC;
        x, y : in STD_LOGIC_VECTOR(7 downto 0);
        saida : out STD_LOGIC_VECTOR(7 downto 0)
    );
end mux2pra1_8bits;

architecture Behavioral of mux2pra1_8bits is
begin
    process(sel, x, y)
    begin
        if sel = '0' then
            saida <= x;
        else
            saida <= y;
        end if;
    end process;
end Behavioral;
