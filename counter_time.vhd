library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_time is
    Port ( 
        Enable : in STD_LOGIC;
        Reset : in STD_LOGIC;
        CLOCK : in STD_LOGIC;
        load : in STD_LOGIC_VECTOR(3 downto 0);  -- Limite de tempo (10 segundos por exemplo)
        end_time : out STD_LOGIC;
        tempo : out STD_LOGIC_VECTOR(3 downto 0)  -- Contador de tempo
    );
end counter_time;

architecture Behavioral of counter_time is
    signal count : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(CLOCK, Reset)
    begin
        if Reset = '1' then
            count <= (others => '0');
            end_time <= '0';
        elsif Enable = '1' then
            if count = load then
                end_time <= '1';  -- Sinaliza que o tempo acabou
                count <= (others => '0');  -- Reseta o contador
            else
                count <= count + 1;
                end_time <= '0';
            end if;
        end if;
    end process;

    tempo <= count;
end Behavioral;
