library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comp_igual4 is
    Port ( 
        soma   : in  STD_LOGIC_VECTOR(3 downto 0);
        status : out STD_LOGIC
    );
end comp_igual4;

architecture Comparar of comp_igual4 is
begin
    process(soma)
    begin
     
        if soma = "0100" then
            status <= '1';  
        else
            status <= '0';  
        end if;
    end process;
end Comparar;
