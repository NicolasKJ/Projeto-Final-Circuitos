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
        if seq_rom(0) = seq_user(0) then
            seq_comparada(0) <= seq_user(0);
        else
            seq_comparada(0) <= '0';
        end if;

        if seq_rom(1) = seq_user(1) then
            seq_comparada(1) <= seq_user(1);
        else
            seq_comparada(1) <= '0';
        end if;

        if seq_rom(2) = seq_user(2) then
            seq_comparada(2) <= seq_user(2);
        else
            seq_comparada(2) <= '0';
        end if;

        if seq_rom(3) = seq_user(3) then
            seq_comparada(3) <= seq_user(3);
        else
            seq_comparada(3) <= '0';
        end if;

        if seq_rom(4) = seq_user(4) then
            seq_comparada(4) <= seq_user(4);
        else
            seq_comparada(4) <= '0';
        end if;
        
        if seq_rom(5) = seq_user(5) then
            seq_comparada(5) <= seq_user(5);
        else
            seq_comparada(5) <= '0';
        end if;
        
        if seq_rom(6) = seq_user(6) then
            seq_comparada(6) <= seq_user(6);
        else
            seq_comparada(6) <= '0';
        end if;
        
        if seq_rom(7) = seq_user(7) then
            seq_comparada(7) <= seq_user(7);
        else
            seq_comparada(7) <= '0';
        end if;
        
        if seq_rom(8) = seq_user(8) then
            seq_comparada(8) <= seq_user(8);
        else
            seq_comparada(8) <= '0';
        end if;
        
        if seq_rom(9) = seq_user(9) then
            seq_comparada(9) <= seq_user(9);
        else
            seq_comparada(9) <= '0';
        end if;

    end process;
end Comparar;