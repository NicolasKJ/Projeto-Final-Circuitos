entity reg10bits is
    port (
        CLK     : in std_logic;                -- Clock
        RST     : in std_logic;                -- Reset (síncrono)
        enable  : in std_logic;                -- Habilita ou desabilita o registro
        D       : in std_logic_vector(9 downto 0);  -- Entrada de dados (10 bits)
        Q       : out std_logic_vector(9 downto 0)  -- Saída (10 bits)
    );
end entity reg10bits;

architecture reg10bits_arch of reg10bits is
    signal previous_CLK : std_logic := '0';
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            Q <= (others => '0');  -- Resetar a saída para 0 se o reset for acionado
        else
            previous_CLK <= CLK;
            if enable = '1' then
                if CLK = '1' and previous_CLK = '0' then
                    Q <= D;  -- Armazenar o valor de D na saída Q quando o flanco de subida ocorrer
                end if;
            end if;
        end if;
    end process;
end architecture reg10bits_arch;
