library ieee;
use ieee.std_logic_1164.all;

entity mux2pra1_10bits is
    port (
        sel   : in std_logic;               -- Sinal de controle
        x     : in std_logic_vector(9 downto 0);  -- Entrada x (SeqDigitada)
        y     : in std_logic_vector(9 downto 0);  -- Entrada y (SeqLevel)
        saida : out std_logic_vector(9 downto 0)  -- Saída (Sequência Selecionada)
    );
end entity mux2pra1_10bits;

-- Arquitetura do MUX 2x1 de 10 bits
architecture mux_10bits of mux2pra1_10bits is
begin
    process(sel, x, y)
    begin
        if sel = '0' then
            saida <= x;  -- Se sel for 0, a saída será x (SeqDigitada)
        else
            saida <= y;  -- Se sel for 1, a saída será y (SeqLevel)
        end if;
    end process;
end architecture mux_10bits;