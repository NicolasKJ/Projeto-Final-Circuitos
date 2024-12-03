library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_time is
    Port ( 
        Enable : in STD_LOGIC;
        Reset : in STD_LOGIC;
        CLOCK : in STD_LOGIC; -- Deve ser o clk_1
        load : in STD_LOGIC_VECTOR(3 downto 0); 
        end_time : out STD_LOGIC;             
        tempo : out STD_LOGIC_VECTOR(3 downto 0) --
    );
end counter_time;

architecture ContarTempo of counter_time is
    signal count : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 
begin
    process(CLOCK, Reset)
    begin
        if Reset = '1' then
            count <= "0000"; 
            end_time <= '0'; 
        elsif (CLOCK'event and CLOCK = '1') then 
            if Enable = '1' then
                if count = load then
                    end_time <= '1'; 
                    count <= "0000"; 
                else
                    count <= count + 1; 
                    end_time <= '0';
                end if;
            end if;
        end if;
    end process;

    tempo <= count;
end ContarTempo;