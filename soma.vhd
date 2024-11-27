library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Para manipulação de números inteiros e binários
entity soma is
    Port ( 
        seq       : in  STD_LOGIC_VECTOR(9 downto 0); -- Entrada de 10 bits
        soma_out  : out STD_LOGIC_VECTOR(3 downto 0)  -- Saída de 4 bits
    );
end soma;
architecture Behavioral of soma is
begin
    process(seq)
        variable count : integer := 0; -- Variável para contar os '1'
    begin
        count := 0; -- Reinicia a contagem
        for i in 0 to 9 loop
            if seq(i) = '1' then
                count := count + 1; -- Incrementa o contador
            end if;
        end loop;

        -- Converte o valor do contador para STD_LOGIC_VECTOR (binário de 4 bits)
        soma_out <= STD_LOGIC_VECTOR(to_unsigned(count, 4));
    end process;
end Behavioral;
