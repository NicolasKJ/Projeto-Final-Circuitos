library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8bits is
    port (
        CLK     : in std_logic;                -- Clock
        RST     : in std_logic;                -- Reset (síncrono)
        enable  : in std_logic;                -- Habilita ou desabilita o registro
        D       : in std_logic_vector(7 downto 0);  -- Entrada de dados (8 bits)
        Q       : out std_logic_vector(7 downto 0)  -- Saída (8 bits)
    );
end entity reg8bits;

architecture reg8bits_arch of reg8bits is
    signal Q_internal : std_logic_vector(7 downto 0); -- Sinal intermediário
begin
    -- Atribuição do sinal interno para a porta de saída
    Q <= Q_internal;

    process(CLK)
    begin
        if rising_edge(CLK) then  -- Verifica o flanco de subida do clock
            if RST = '1' then
                Q_internal <= (others => '0');  -- Reset síncrono: zera o registrador
            elsif enable = '1' then
                Q_internal <= D;  -- Armazena o valor de entrada
            end if;
        end if;
    end process;
end architecture reg8bits_arch;
