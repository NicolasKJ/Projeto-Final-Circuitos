library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comp is
    Port ( 
        seq_user : in  STD_LOGIC_VECTOR(9 downto 0);
        seq_reg  : in  STD_LOGIC_VECTOR(9 downto 0);
        seq_mask : out STD_LOGIC_VECTOR(9 downto 0)
    );
end comp;

architecture Behavioral of comp is
begin
    process(seq_user, seq_reg)
    begin
        -- Comparar as duas sequências de 10 bits
        if seq_user = seq_reg then
            seq_mask <= (others => '1');  -- Se as sequências forem iguais, todos os bits são 1
        else
            seq_mask <= (others => '0');  -- Se não, todos os bits são 0
        end if;
    end process;
end Behavioral;
