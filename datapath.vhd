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

component decod7seg is
    port (
    X:  in std_logic_vector(3 downto 0);
    Y:  out std_logic_vector(6 downto 0) 
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

signal end_game_interno, end_round_interno, clk_1, E5E4, R1R2, E1E2: std_logic; --1 bit
signal Tempo, Round, SaidaSoma, SomaDigitada, SaidaMuxHEX4_1: std_logic_vector(3 downto 0); -- 4 bits
signal SaidaDecodHEX2_1, SaidaDecodHEX2_2, SaidaMuxHEX2_2, SaidaMuxHEX3_1, SaidaDecodHex4: std_logic_vector(6 downto 0); -- 7 bits
signal SeqLevel, SaidaMuxHEX1_HEX0, SaidaRegHEX1_HEX0, mux1, mux2: std_logic_vector(7 downto 0); -- 8 bits
signal naosigned: unsigned(3 downto 0);
signal SeqDigitada, SelecionadaROM, SaidaComp : std_logic_vector(9 downto 0); -- 10 bits

begin
clk_1 <= CLOCK_50;
mux1 <= "000" & end_game_interno & not Round;
mux2 <= "1010" & SaidaSoma;
E5E4 <= E5 or E4;
R1R2 <= R1 xor R2;
E1E2 <= E1 or E2;
-- DIV: Div_Freq port map (CLOCK_50, R2, clk_1); -- Para teste no emulador, comentar essa linha e usar o CLK_1Hz

-- Contador de tempo
COUNTER_T: counter_time port map (
    Enable => E2, 
    Reset => R1, 
    CLOCK => CLK_1Hz, 
    load => SeqLevel(7 downto 4), 
    end_time => end_time, 
    tempo => Tempo
);

-- Contador de rodadas
COUNTER_R: counter0to10 port map (
    Enable => E3, 
    Reset => R2, 
    CLOCK => clk_1, 
    Round => Round, 
    end_round => end_round_interno
);

-- Registro para armazenar sequência digitada
REG_SEQ_DIGITADA: reg10bits port map (
    CLK => clk_1, 
    RST => R2, 
    enable => E2, 
    D => SW(9 downto 0), 
    Q => SeqDigitada
);

-- Registro para sequência selecionada na ROM
REG_SEQ_ROM: reg8bits port map (
    CLK => clk_1, 
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
    seq_reg => SelecionadaROM, 
    seq_mask => SaidaComp
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


MUX_HEX0_HEX1: mux2pra1_8bits port map (
    sel => E5,       -- Controle de seleção do mux
    x   => mux1, -- Primeira entrada de 8 bits
    y   => mux2,       -- Segunda entrada de 8 bits (sequência do nível)
    saida => SaidaMuxHEX1_HEX0     -- Saída do mux
);

-- Registro para sequência selecionada na ROM
REG_HEX0_HEX1: reg8bits port map (
    CLK => clk_1, 
    RST => R2, 
    enable => E5E4, 
    D => SaidaMuxHEX1_HEX0, 
    Q => SaidaRegHEX1_HEX0
);

DECOD_HEX1: decod7seg port map (
    X => SaidaRegHEX1_HEX0(7 downto 4),
    Y => HEX1
);

DECOD_HEX0: decod7seg port map (
    X => SaidaRegHEX1_HEX0(3 downto 0),
    Y => HEX0
);

DECOD_HEX2_1: decod7seg port map (
    X => Round,
    Y => SaidaDecodHEX2_1
);

DECOD_HEX2_2: decod7seg port map (
    X => SeqLevel(3 downto 0),
    Y => SaidaDecodHEX2_2
);


MUX_HEX2_1: mux2pra1_7bits port map (
    sel => R1R2,       -- Controle de seleção do mux
    x   => SaidaDecodHEX2_1,        -- Primeira entrada de 7 bits (pode ser ajustada ao seu projeto)
    y   => SaidaMuxHEX2_2,        -- Segunda entrada de 7 bits
    saida => HEX2       -- Saída do mux para o próximo estágio
);

MUX_HEX2_2: mux2pra1_7bits port map (
    sel => E1,       -- Controle de seleção do mux
    x   => SaidaDecodHEX2_2,        -- Primeira entrada de 7 bits (pode ser ajustada ao seu projeto)
    y   => "1111111",        -- Segunda entrada de 7 bits
    saida => SaidaMuxHEX2_2       -- Saída do mux para o próximo estágio
);

MUX_HEX3_1: mux2pra1_7bits port map (
    sel => E1,       -- Controle de seleção do mux
    x   => "0101011",        -- n
    y   => "1111111",        
    saida => SaidaMuxHEX3_1       -- Saída do mux para o próximo estágio
);

MUX_HEX3_2: mux2pra1_7bits port map (
    sel => R1R2,       -- Controle de seleção do mux
    x   => "0101111",       -- r
    y   => SaidaMuxHEX3_1,        -- Segunda entrada de 7 bits
    saida => HEX3       -- Saída do mux para o próximo estágio
);


MUX_HEX4_1: mux2pra1_4bits port map (
    sel => E2,       -- Controle de seleção do mux
    x   => Tempo,        -- Primeira entrada de 7 bits (pode ser ajustada ao seu projeto)
    y   => SeqLevel(7 downto 4),        -- Segunda entrada de 7 bits
    saida => SaidaMuxHex4_1       -- Saída do mux para o próximo estágio
);

DECOD_HEX4: decod7seg port map (
    X => SaidaMuxHex4_1,
    Y => SaidaDecodHex4
);

MUX_HEX4_2: mux2pra1_7bits port map (
    sel => E1E2,       -- Controle de seleção do mux
    x   => SaidaDecodHex4,        -- Primeira entrada de 7 bits (pode ser ajustada ao seu projeto)
    y   => "1111111",        -- Segunda entrada de 7 bits
    saida => HEX4       -- Saída do mux para o próximo estágio
);

MUX_HEX5: mux2pra1_7bits port map (
    sel => E1E2,       -- Controle de seleção do mux
    x   => "0000111",        -- Primeira entrada de 7 bits (pode ser ajustada ao seu projeto)
    y   => "1111111",        -- Segunda entrada de 7 bits
    saida => HEX5       -- Saída do mux para o próximo estágio
);

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
