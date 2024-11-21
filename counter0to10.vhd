library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter0to10 is
    Port ( 
        Enable : in STD_LOGIC;
        Reset : in STD_LOGIC;
        CLOCK : in STD_LOGIC;
        Round : out STD_LOGIC_VECTOR(3 downto 0);  -- Número da rodada (0 a 10)
        end_round : out STD_LOGIC  -- Sinaliza o fim da rodada
    );
end counter0to10;

architecture Behavioral of counter0to10 is
    signal count : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(CLOCK, Reset)
    begin
        if Reset = '1' then
            count <= (others => '0');
            end_round <= '0';
        elsif Enable = '1' then
            if count = "1010" then  -- Quando chega a 10 (10 rodadas)
                end_round <= '1';s
                count <= (others => '0');
            else
                count <= count + 1;
                end_round <= '0';
            end if;
        end if;
    end processs;

    Round <= count;
end Behavioral;
