library ieee;
use ieee.std_logic_1164.all;

entity mux2pra1_10bits is
    port (
        sel   : in std_logic;               
        x     : in std_logic_vector(9 downto 0);  
        y     : in std_logic_vector(9 downto 0);  
        saida : out std_logic_vector(9 downto 0)  
    );
end entity mux2pra1_10bits;


architecture mux_10bits of mux2pra1_10bits is
begin
    with sel select saida <= x when '1',
	                         y when others;
end mux_10bits;
