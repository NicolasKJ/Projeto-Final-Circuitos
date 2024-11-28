library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2pra1_8bits is
    Port (
        sel : in STD_LOGIC;
        x, y : in STD_LOGIC_VECTOR(7 downto 0);
        saida : out STD_LOGIC_VECTOR(7 downto 0)
    );
end mux2pra1_8bits;

architecture mux8bits of mux2pra1_8bits is
begin
    with sel select saida <= x when '1',
	                         y when others;
end mux8bits;
