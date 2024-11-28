library ieee;
use ieee.std_logic_1164.all;

entity mux2pra1_4bits is
    port (
        sel   : in std_logic;           
        x     : in std_logic_vector(3 downto 0);  
        y     : in std_logic_vector(3 downto 0);  
        saida : out std_logic_vector(3 downto 0)  
    );
end entity mux2pra1_4bits;

architecture mux_4bits of mux2pra1_4bits is
begin
    with sel select saida <= x when '1',
	                         y when others;
end mux_4bits;
