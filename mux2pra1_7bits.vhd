library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2pra1_7bits is
    Port (
        sel : in STD_LOGIC;
        x, y : in STD_LOGIC_VECTOR(6 downto 0);
        saida : out STD_LOGIC_VECTOR(6 downto 0)
    );
end mux2pra1_7bits;

architecture mux7bits of mux2pra1_7bits is
begin
    with sel select saida <= x when '1',
	                         y when others;
end mux7bits;
