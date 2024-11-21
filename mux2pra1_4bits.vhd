library ieee;
use ieee.std_logic_1164.all;

entity mux2pra1_4bits is
    port (
        sel   : in std_logic;               -- Sinal de controle
        x     : in std_logic_vector(3 downto 0);  -- Entrada x (Round)
        y     : in std_logic_vector(3 downto 0);  -- Entrada y (Tempo)
        saida : out std_logic_vector(3 downto 0)  -- Saída (Contador de tempo ou rodadas)
    );
end entity mux2pra1_4bits;

-- Arquitetura do MUX 2x1 de 4 bits
architecture mux_4bits of mux2pra1_4bits is
begin
    process(sel, x, y)
    begin
        if sel = '0' then
            saida <= x;  -- Se sel for 0, a saída será x (Round)
        else
            saida <= y;  -- Se sel for 1, a saída será y (Tempo)
        end if;
    end process;
end architecture mux_4bits;
