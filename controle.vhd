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
	signal EA, PE: State := Start; 						-- PE: proximo estado, EA: estado atual 

begin


-- FSM usando dois process a ser feito pel@ alun@

end architecture;