library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg4bits is
    port (
        CLK     : in std_logic;
        RST     : in std_logic; 
        enable  : in std_logic;                
        D       : in std_logic_vector(3 downto 0);  
        Q       : out std_logic_vector(3 downto 0)  
    );
end entity reg4bits;

architecture reg4bitsarc of reg4bits is
    signal Q_interno : std_logic_vector(3 downto 0) := "0000";
begin
    Q <= Q_interno;

    process(CLK)
    begin
        if (CLK'event and CLK = '1') then  
            if RST = '1' then
                Q_interno <= "0000";  
            elsif enable = '1' then
                Q_interno <= D; 
            end if;
        end if;
    end process;
end reg4bitsarc;