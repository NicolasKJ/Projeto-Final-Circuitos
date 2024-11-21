-- soma.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity soma is
    Port ( 
        seq       : in  STD_LOGIC_VECTOR(9 downto 0);
        soma_out  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end soma;

architecture Behavioral of soma is
begin
    process(seq)
    variable sum: std_logic_vector(10 downto 0); -- Variável para armazenar a soma
    begin
        -- Inicializa a soma
        sum := (others => '0');
        
        -- Soma dos bits da sequência
        sum := std_logic_vector(unsigned(seq) + 1); -- Soma simples
        
        -- A saída é os 4 bits menos significativos da soma
        soma_out <= sum(3 downto 0);
    end process;
end Behavioral;
