library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp is
    Port (
        seq_rom  : in  STD_LOGIC_VECTOR(9 downto 0);
        seq_user : in  STD_LOGIC_VECTOR(9 downto 0);
        seq_comparada : out STD_LOGIC_VECTOR(9 downto 0)
    );
end comp;

architecture Comparar of comp is
begin
    process(seq_rom, seq_user)
     begin
        
        seq_comparada <= seq_rom and seq_user;
        
    end process;
end Comparar;