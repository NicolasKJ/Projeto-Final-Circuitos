library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity soma is
    Port ( 
        seq       : in  STD_LOGIC_VECTOR(9 downto 0);
        soma_out  : out STD_LOGIC_VECTOR(3 downto 0)  
    );
end soma;
architecture somar of soma is
begin
    soma_out <= "000" & seq(0) + seq(1) + seq(2) + seq(3) + seq(4) + seq(5) + seq(6) + seq(7) + seq(8) + seq(9);
    
    
    
    
end somar;
