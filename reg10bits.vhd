library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg10bits is
    port (
        CLK     : in std_logic;                -- Clock
        RST     : in std_logic;                -- Reset (síncrono)
        enable  : in std_logic;                -- Habilita ou desabilita o registro
        D       : in std_logic_vector(9 downto 0);  
        Q       : out std_logic_vector(9 downto 0)  
    );
end entity reg10bits;

architecture reg10bits_arch of reg10bits is
    signal Q_internal : std_logic_vector(9 downto 0); -- Sinal intermediário
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
end architecture reg10bits_arch;
