library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity soma is
    Port ( 
        seq       : in  STD_LOGIC_VECTOR(9 downto 0); -- Entrada de 10 bits
        soma_out  : out STD_LOGIC_VECTOR(3 downto 0)  -- Saída de 4 bits
    );
end soma;

architecture Behavioral of soma is
    signal partial_sums: std_logic_vector(10 downto 0); -- Sinais intermediários
    signal carries: std_logic_vector(10 downto 0);     -- Transportes intermediários
begin
    process(seq)
        variable count: std_logic_vector(10 downto 0); -- Soma final dos 1's
    begin
        -- Inicializa os sinais
        partial_sums(0) <= seq(0); -- O primeiro bit é copiado diretamente
        carries(0) <= '0'; -- Não há transporte no primeiro bit

        -- Lógica de soma hierárquica usando half-adders e full-adders
        for i in 1 to 9 loop
            -- Half-Adder para o próximo bit
            partial_sums(i) <= seq(i) XOR partial_sums(i-1);
            carries(i) <= seq(i) AND partial_sums(i-1);
        end loop;

        -- Adiciona os transportes acumulados ao final
        partial_sums(10) <= carries(9);

        -- Converte o resultado final para 4 bits (LSBs)
        count := partial_sums;
        soma_out <= count(3 downto 0);
    end process;
end Behavioral;
