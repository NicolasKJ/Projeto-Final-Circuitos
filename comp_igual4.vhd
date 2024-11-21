library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comp_igual4 is
    Port ( 
        soma   : in  STD_LOGIC_VECTOR(3 downto 0);
        status : out STD_LOGIC
    );
end comp_igual4;

architecture Behavioral of comp_igual4 is
begin
    process(soma)
    begin
        -- Verifica se soma é igual a 4 (100 em binário)
        if soma = "0100" then
            status <= '1';  -- Se for igual a 4, status é 1
        else
            status <= '0';  -- Caso contrário, status é 0
        end if;
    end process;
end Behavioral;
