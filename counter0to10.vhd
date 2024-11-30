library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter0to10 is
    Port (
        Enable: in  std_logic;
        Reset : in std_logic;
        CLOCK : in std_logic;
        Round : out std_logic_vector(3 downto 0);  
        end_round : out std_logic 
    );
end counter0to10;

architecture Contar of counter0to10 is
    signal count : std_logic_vector(3 downto 0) := "0000";

begin
    process(CLOCK, Reset)
    begin
    if Reset = '1' then
            count <= "0000";
            end_round <= '0';
    elsif Enable = '1' then
        if (CLOCK 'event and CLOCK = '1') then 
            if count = "1001" then 
                end_round <= '1';
                count <= "1010";

            else
                count <= count + 1;
                end_round <= '0';
            end if;
        end if;
    end if;
    end process;
    Round <= count;
end Contar;