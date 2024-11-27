library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp is
    Port (
        seq_reg  : in  STD_LOGIC_VECTOR(9 downto 0);
        seq_user : in  STD_LOGIC_VECTOR(9 downto 0);
        seq_mask   : out STD_LOGIC_VECTOR(9 downto 0)
    );
end comp;

architecture Behavioral of comp is
begin
    process(seq_reg, seq_user)
    begin
        seq_mask <= (others => '0');
        for i in 0 to 9 loop
            if seq_reg(i) = seq_user(i) then
                seq_mask(i) <= seq_user(i);
            else
                seq_mask(i) <= '0';
            end if;
        end loop;
    end process;
end Behavioral;
