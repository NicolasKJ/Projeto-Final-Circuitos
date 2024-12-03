-- Datapath, fazendo a conexao entre cada componente

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datapath is
port (
-- Entradas de dados
SW: in std_logic_vector(9 downto 0);
CLOCK_50: in std_logic;
clk1: in std_logic;
-- Sinais de controle
R1, R2, E1, E2, E3, E4, E5: in std_logic;
-- Sinais de status
sw_erro, end_game, end_time, end_round: out std_logic;
-- Saidas de dados
HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0);
LEDR: out std_logic_vector(9 downto 0)
);
end datapath;

architecture arc of datapath is
--============================================================--
--                      COMPONENTS                            --
--============================================================--
-------------------DIVISOR DE FREQUENCIA------------------------

--comentado para funcionar no emulador

--component Div_Freq is
--	port (	    clk: in std_logic;
--				reset: in std_logic;
--				CLK_1Hz: out std_logic
--			);
--end component;

------------------------CONTADORES------------------------------

component counter_time is
port(Enable, Reset, CLOCK: in std_logic;
		load: in std_logic_vector(3 downto 0);
		end_time: out std_logic;
		tempo: out std_logic_vector(3 downto 0)
		);
end component;

component counter0to10 is
port(
    Enable, Reset, CLOCK: in std_logic;
	Round: out std_logic_vector(3 downto 0);
	end_round: out std_logic
	);
			
end component;

------------------- Registradores -------------------------

component reg4bits is 
port(
    CLK, RST, enable: in std_logic;
    D: in std_logic_vector(3 downto 0);
    Q: out std_logic_vector(3 downto 0)
    );
end component;

component reg8bits is 
port (
	CLK, RST, enable: in std_logic;
	D: in std_logic_vector(7 downto 0);
	Q: out std_logic_vector(7 downto 0)
);
end component;

component reg10bits is 
port(
	CLK, RST, enable: in std_logic;
	D: in std_logic_vector(9 downto 0);
	Q: out std_logic_vector(9 downto 0)
    );
end component;

----------------------- ROM  --------------------------


component ROM is
port(
    address : in std_logic_vector(3 downto 0);
    data : out std_logic_vector(9 downto 0) 
    );
end component;

---------------------MULTIPLEXADORES----------------------------


component mux2pra1_4bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(3 downto 0);
	saida: out std_logic_vector(3 downto 0)
    );
end component;

component mux2pra1_7bits is
port (sel: in std_logic;
		x, y: in std_logic_vector(6 downto 0);
		saida: out std_logic_vector(6 downto 0)
);
end component;

component mux2pra1_8bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(7 downto 0);
	saida: out std_logic_vector(7 downto 0)
    );
end component;

component mux2pra1_10bits is
port(
    sel: in std_logic;
	x, y: in std_logic_vector(9 downto 0);
	saida: out std_logic_vector(9 downto 0)
    );
end component;

------------------- Comparadores---------------------

component comp is
port (
    seq_user: in std_logic_vector(9 downto 0);
    seq_rom: in std_logic_vector(9 downto 0);
    seq_comparada: out std_logic_vector(9 downto 0)
    );
end component;

component comp_igual4 is
port(
    soma: in std_logic_vector(3 downto 0);
    status: out std_logic
    );
end component;

------------------- Decodificador ---------------------


component decod7seg is
    port (
    X:  in std_logic_vector(3 downto 0);
    Y:  out std_logic_vector(6 downto 0) 
    );
end component;

------------------- Somador ---------------------


component soma is
port(
    seq: in std_logic_vector(9 downto 0);
    soma_out: out std_logic_vector(3 downto 0)
    );
end component;

--============================================================--
--                      SIGNALS                               --
--============================================================--

signal end_game_interno, end_round_interno, clk_1, E5E4, R1R2, E1E2: std_logic; --1 bit
signal Tempo, Round, SaidaSoma, SomaDigitada, SaidaMuxHEX4_1: std_logic_vector(3 downto 0); -- 4 bits
signal SaidaDecodHEX2_1, SaidaDecodHEX2_2, SaidaMuxHEX2_2, SaidaMuxHEX3_1, SaidaDecodHex4: std_logic_vector(6 downto 0); -- 7 bits
signal SeqLevel, SaidaMuxHEX1_HEX0, SaidaRegHEX1_HEX0, mux1, mux2: std_logic_vector(7 downto 0); -- 8 bits
signal naosigned: unsigned(3 downto 0);
signal SeqDigitada, SelecionadaROM, SaidaComp : std_logic_vector(9 downto 0); -- 10 bits

-------------------------- Begin ----------------------------

begin
mux1 <= "000" & end_game_interno & not Round;
mux2 <= "1010" & SaidaSoma;
E5E4 <= E5 or E4;
R1R2 <= R1 xor R2;
E1E2 <= E1 or E2;
clk_1 <= clk1; -- clk 1 para counter time do emulador
-- Divisor de freq para DE2; comentado para funcionar no emulador
-- DIV: Div_Freq port map (CLOCK_50, R2, clk_1); -- Para teste no emulador, comentar essa linha e usar o CLK_1Hz

-- Contador de tempo
COUNTER_T: counter_time port map (
    Enable => E2, 
    Reset => R1, 
    CLOCK => clk_1, 
    load => SeqLevel(7 downto 4), 
    end_time => end_time, 
    tempo => Tempo
);

-- Contador de rodadas
COUNTER_R: counter0to10 port map (
    Enable => E3, 
    Reset => R2, 
    CLOCK => CLOCK_50, 
    Round => Round, 
    end_round => end_round_interno
);

-- Registro para armazenar sequência digitada
REG_SEQ_DIGITADA: reg10bits port map (
    CLK => CLOCK_50, 
    RST => R2, 
    enable => E2, 
    D => SW(9 downto 0), 
    Q => SeqDigitada
);

-- Registro para sequência selecionada na ROM
REG_SEQ_ROM: reg8bits port map (
    CLK => CLOCK_50, 
    RST => R2, 
    enable => E1, 
    D => SW(7 downto 0), 
    Q => SeqLevel
);

-- ROM para sequência de nível
ROM_SEQ: ROM port map (
    address => SeqLevel(3 downto 0), 
    data => SelecionadaROM
);


-- Comparador de sequência
COMPARADOR_SEQ: comp port map (
    seq_user => SeqDigitada, 
    seq_rom => SelecionadaROM, 
    seq_comparada => SaidaComp
);

-- Somador para calcular bits digitados
SOMADOR_BITS: soma port map (
    seq => SaidaComp, 
    soma_out => SaidaSoma
);

-- Comparador para verificar igualdade
COMPARADOR_IGUAL: comp_igual4 port map (
    soma => SaidaSoma, 
    status => end_game_interno
);

-- Somador para calcular bits digitados
SOMADOR_BITS2: soma port map (
    seq => SeqDigitada, 
    soma_out => SomaDigitada
);


-- Comparador para verificar igualdade
COMPARADOR_IGUAL2: comp_igual4 port map (
    soma => SomaDigitada, 
    status => sw_erro
);

-- Mux dos HEX0 e HEX1
MUX_HEX0_HEX1: mux2pra1_8bits port map (
    sel => E5,       
    x   => mux1, 
    y   => mux2,       
    saida => SaidaMuxHEX1_HEX0     
);

-- Reg dos HEX0 e HEX1
REG_HEX0_HEX1: reg8bits port map (
    CLK => CLOCK_50, 
    RST => R2, 
    enable => E5E4, 
    D => SaidaMuxHEX1_HEX0, 
    Q => SaidaRegHEX1_HEX0
);

-- Decod HEX1
DECOD_HEX1: decod7seg port map (
    X => SaidaRegHEX1_HEX0(7 downto 4),
    Y => HEX1
);

-- Decod HEX0
DECOD_HEX0: decod7seg port map (
    X => SaidaRegHEX1_HEX0(3 downto 0),
    Y => HEX0
);

-- Um decod HEX2
DECOD_HEX2_1: decod7seg port map (
    X => Round,
    Y => SaidaDecodHEX2_1
);

-- Outro decod HEX2
DECOD_HEX2_2: decod7seg port map (
    X => SeqLevel(3 downto 0),
    Y => SaidaDecodHEX2_2
);

-- Um mux do HEX2
MUX_HEX2_1: mux2pra1_7bits port map (
    sel => R1R2,       
    x   => SaidaDecodHEX2_1,        
    y   => SaidaMuxHEX2_2,        
    saida => HEX2       
);

-- Outro mux do HEX2
MUX_HEX2_2: mux2pra1_7bits port map (
    sel => E1,       
    x   => SaidaDecodHEX2_2,        
    y   => "1111111",        
    saida => SaidaMuxHEX2_2       
);

-- Um mux do HEX3
MUX_HEX3_1: mux2pra1_7bits port map (
    sel => E1,       
    x   => "0101011",        -- n
    y   => "1111111",        
    saida => SaidaMuxHEX3_1       
);

-- Outro mux do HEX3
MUX_HEX3_2: mux2pra1_7bits port map (
    sel => R1R2,       
    x   => "0101111",       -- r
    y   => SaidaMuxHEX3_1,        
    saida => HEX3       
);

-- Um Mux do HEX4
MUX_HEX4_1: mux2pra1_4bits port map (
    sel => E2,      
    x   => Tempo,        
    y   => SeqLevel(7 downto 4),        
    saida => SaidaMuxHex4_1       
);

-- Decod HEX4
DECOD_HEX4: decod7seg port map (
    X => SaidaMuxHex4_1,
    Y => SaidaDecodHex4
);

-- Outro Mux do HEX4
MUX_HEX4_2: mux2pra1_7bits port map (
    sel => E1E2,       
    x   => SaidaDecodHex4,        
    y   => "1111111",        
    saida => HEX4      
);

-- Mux do HEX5
MUX_HEX5: mux2pra1_7bits port map (
    sel => E1E2,       
    x   => "0000111",        
    y   => "1111111",        
    saida => HEX5       
);

-- Mux dos leds
MUX_LEDS: mux2pra1_10bits port map (
    sel => E5, 
    y => "0000000000", 
    x => SelecionadaROM, 
    saida => LEDR
);


-- Sinal de fim de jogo
end_game <= end_game_interno;

-- Sinal de fim de rodada
end_round <= end_round_interno;

end arc;
