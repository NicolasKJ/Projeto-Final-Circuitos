library ieee;
use ieee.std_logic_1164.all;

entity controle is
port
(
BTN1, BTN0, clock_50: in std_logic;
sw_erro, end_game, end_time, end_round: in std_logic;
R1, R2, E1, E2, E3, E4, E5: out std_logic
);
end entity;

architecture arc of controle is
	type State is (Start, Setup, Play, Count_Round, Check, Waits, Result); --Aqui temos os estados
	signal EA, PE: State; 		-- PE: proximo estado, EA: estado atual 
begin	
    process(clock_50, BTN0, BTN1)
    begin
        if BTN0 = '0' then
            EA <= Start; -- Reset para o estado inicial
        elsif (clock_50'event AND clock_50 = '1') then 
                EA <= PE; 
            end if;
    end process;

	process(EA, BTN1, BTN0, sw_erro, end_game, end_time, end_round)
	begin
		case EA is
			when Start => 
				R1 <= '1';
				R2 <= '1';
				E1 <= '0';
				E2 <= '0';
				E3 <= '0';
				E4 <= '0';
				E5 <= '0';
				if (BTN1'event and BTN1 = '0') then
					    PE <= Setup;
				elsif (BTN0 = '0') then
				        PE <= Start;

				end if;
				
			when Setup =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '1';
				E2 <= '0';
				E3 <= '0';
				E4 <= '0';
				E5 <= '0';
				if (BTN1'event and BTN1 = '0') then
					PE <= Play;
				end if;
			
			when Play =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '0';
				E2 <= '1';
				E3 <= '0';
				E4 <= '0';
				E5 <= '0';
				if (BTN1'event and BTN1 = '0') and (end_time = '0') then
					PE <= Count_Round;
				elsif (end_time = '1') then
					PE <= Result;
				end if;
			
			when Count_Round =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '0';
				E2 <= '0';
				E3 <= '1';
				E4 <= '0';
				E5 <= '0';
				PE <= Check;
		
			when Check =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '0';
				E2 <= '0';
				E3 <= '0';
				E4 <= '0';
				E5 <= '0';
				if (sw_erro = '0') or (end_round = '1') or (end_game = '1') then
					PE <= Result;
				else
					PE <= Waits;
				end if;
			
			when Waits =>
				R1 <= '1';
				R2 <= '0';
				E1 <= '0';
				E2 <= '0';
				E3 <= '0';
				E4 <= '1';
				E5 <= '0';
				if (BTN1'event and BTN1 = '0') then
					PE <= Play;
				end if;
			
			when Result =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '0';
				E2 <= '0';
				E3 <= '0';
				E4 <= '0';
				E5 <= '1';
				if (BTN1'event and BTN1 = '0') then
					PE <= Start;
				end if;
        end case;
    end process;


end arc;