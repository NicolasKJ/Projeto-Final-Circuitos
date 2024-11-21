-- Datapath, fazendo a conexao entre cada componente

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datapath is
port (
-- Entradas de dados
SW: in std_logic_vector(9 downto 0);
CLOCK_50, CLK_1Hz: in std_logic;
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

component Div_Freq is
	port (	    clk: in std_logic;
				reset: in std_logic;
				CLK_1Hz: out std_logic
			);
end component;

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

-------------------ELEMENTOS DE MEMORIA-------------------------

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

----------------------DECODIFICADOR-----------------------------

DECOD_HEX0: decod7seg port map(
    X => CounterTMux, -- Conectado ao contador de tempo (ou outro sinal de 4 bits)
    Y => HEX0
);

DECOD_HEX1: decod7seg port map(
    X => Round, -- Conectado ao contador de rodadas
    Y => HEX1
);

DECOD_HEX2: decod7seg port map(
    X => Level_time, -- Conectado ao nível de tempo (4 bits)
    Y => HEX2
);

DECOD_HEX3: decod7seg port map(
    X => Level_code, -- Código do nível
    Y => HEX3
);

-------------------COMPARADORES E SOMA--------------------------

component comp is
port (
    seq_user: in std_logic_vector(9 downto 0);
    seq_reg: in std_logic_vector(9 downto 0);
    seq_mask: out std_logic_vector(9 downto 0)
    );
end component;

component comp_igual4 is
port(
    soma: in std_logic_vector(3 downto 0);
    status: out std_logic
    );
end component;

component soma is
port(
    seq: in std_logic_vector(9 downto 0);
    soma_out: out std_logic_vector(3 downto 0)
    );
end component;

--============================================================--
--                      SIGNALS                               --
--============================================================--

signal selMux23, selMux45, end_game_interno, end_round_interno, clk_1, enableRegFinal: std_logic; --1 bit
signal Round, Level_time, Level_code, SaidaCountT, SomaDigitada, SomaSelDig, CounterTMux: std_logic_vector(3 downto 0); -- 4 bits
signal decMuxCode, decMuxRound, muxMux2, muxMux3, decMux4, Tempo, t, r, n: std_logic_vector(6 downto 0); -- 7 bits
signal SomaSelDig_estendido,SeqLevel, RegFinal, valorfin_vector, MuxSelDig: std_logic_vector(7 downto 0); -- 8 bits
signal N_unsigned: unsigned(3 downto 0);
signal SeqDigitada, ComparaSelDig, SelecionadaROM, EntradaLEDS: std_logic_vector(9 downto 0); -- 10 bits

begin


DIV: Div_Freq port map (CLOCK_50, R2, clk_1); -- Para teste no emulador, comentar essa linha e usar o CLK_1Hz

------------------------CONTADORES------------------------------

-- Contador de tempo
COUNTER_T: counter_time port map (
    Enable => E1, 
    Reset => R1, 
    CLOCK => clk_1, 
    load => "1010", -- Exemplo: configura limite de 10 segundos
    end_time => end_time, 
    tempo => Tempo
);

-- Contador de rodadas
COUNTER_R: counter0to10 port map (
    Enable => E2, 
    Reset => R2, 
    CLOCK => clk_1, 
    Round => Round, 
    end_round => end_round_interno
);


-------------------ELEMENTOS DE MEMORIA-------------------------

-- Registro para armazenar sequência digitada
REG_SEQ_DIGITADA: reg10bits port map (
    CLK => clk_1, 
    RST => R1, 
    enable => E3, 
    D => SW, 
    Q => SeqDigitada
);

-- Registro para sequência selecionada na ROM
REG_SEQ_ROM: reg10bits port map (
    CLK => clk_1, 
    RST => R1, 
    enable => E4, 
    D => SelecionadaROM, 
    Q => SeqLevel
);

-- ROM para sequência de nível
ROM_SEQ: ROM port map (
    address => Round, 
    data => SelecionadaROM
);


---------------------MULTIPLEXADORES----------------------------

-- MUX para selecionar entre sequência digitada e sequência da ROM
MUX_SEQ: mux2pra1_10bits port map (
    sel => selMux23, 
    x => SeqDigitada, 
    y => SeqLevel, 
    saida => ComparaSelDig
);

-- MUX para selecionar entre rodadas ou tempo
MUX_DISPLAY: mux2pra1_4bits port map (
    sel => selMux45, 
    x => Round, 
    y => Tempo, 
    saida => CounterTMux
);


-------------------COMPARADORES E SOMA--------------------------

-- Comparador de sequência
COMPARADOR_SEQ: comp port map (
    seq_user => SeqDigitada, 
    seq_reg => SeqLevel, 
    seq_mask => EntradaLEDS
);

-- Somador para calcular bits digitados
SOMADOR_BITS: soma port map (
    seq => SeqDigitada, 
    soma_out => SomaDigitada
);

-- Comparador para verificar igualdade
COMPARADOR_IGUAL: comp_igual4 port map (
    soma => SomaDigitada, 
    status => end_game_interno
);

        
---------------------DECODIFICADORES----------------------------

Decodificadores para displays
    DECOD_DISPLAY_TEMPO: decod7seg port map (
        X => CounterTMux,
        Y => HEX0
    );

    DECOD_DISPLAY_RODADA: decod7seg port map (
        X => Round,
        Y => HEX1
    );

    DECOD_DISPLAY_TEMPO_CONF: decod7seg port map (
        X => SW(7 downto 4), -- Tempo configurado
        Y => HEX2
    );

    DECOD_DISPLAY_SEQ: decod7seg port map (
        X => SW(3 downto 0), -- Sequência configurada
        Y => HEX3
    );
        
---------------------ATRIBUICOES DIRETAS---------------------

-- LEDs exibem a sequência da ROM
LEDR <= SeqLevel;

-- Sinal de fim de jogo
end_game <= end_game_interno;

-- Sinal de fim de rodada
end_round <= end_round_interno;

end arc;
