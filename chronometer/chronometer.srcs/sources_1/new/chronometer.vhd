----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.08.2019 13:36:19
-- Design Name: 
-- Module Name: chronometer - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity chronometer is
Port (     clk              : in STD_LOGIC;                          
           ssBtn            : in STD_LOGIC;                         --start/stop button: start/stop the chronometer
           rstBtn           : in STD_LOGIC;                         --reset button: reset the chronometer
           lapBtn           : in STD_LOGIC;                         --lap button : stop the display but continue cont
           --ooSwt          : in STD_LOGIC;                         -- on/off switch 
           segment          : out STD_LOGIC_VECTOR (7 downto 0);    --set the number at the display, MBS is for the dot (bit 7)
           anode            : out STD_LOGIC_VECTOR (7 downto 0);    --on/off the displays
           led              : out std_logic_vector(2 downto 0);
           ledOverflow      : out std_logic
           );    
end chronometer;

architecture rtl of chronometer is

    signal delayFlag        : STD_LOGIC;
    signal overflowVec      : STD_LOGIC_VECTOR(6 downto 0);
    signal chronome         : std_logic_vector(31 downto 0);
    signal state            : std_logic_vector(1 downto 0);     -- estado do cronometro: 0-stop, 1-start/cronometrando, 2-lap

    component display7seg
        Port (     
                clk         : in STD_LOGIC;                             
                rst_n       : in STD_LOGIC;                             --reset signal: reset the counter
                value       : in STD_LOGIC_VECTOR (31 downto 0);        --values to show
                dot_i       : in STD_LOGIC_VECTOR (7 downto 0);         --dot's to show
                anode       : out STD_LOGIC_VECTOR (7 downto 0);        --on/off the displays
                segment     : out STD_LOGIC_VECTOR (6 downto 0);        --set the number at the display
                dot         : out STD_LOGIC                             --on/off the dot in the display
        ); 
    end component display7seg;

    
    component counter

        generic (
            -- size at bits of the value
            size            : integer := 4;
            -- module 10 == count from 0 to 9
            module          : integer := 10
        );
        
        port (
            clk             : in STD_LOGIC;
            rst_n           : in STD_LOGIC;                                     --reset signal: reset the counter
            countEn         : in STD_LOGIC;                                     --counter enable
            value           : out STD_LOGIC_VECTOR (size-1 downto 0);           --value of the count
            overflow        : out STD_LOGIC                                        --flag for the case of overflow/terminate case
        );

    end component counter;

    component delay
        generic (
            --clock frequency (100MHz -> 0,00000001‬s for cycle)
            CLK_FREQ            : integer := 100_000_000;

            --clock quantity of delay (10ms == 1000000 cycles at 100MHz == 100MHz /100)
                --f = 1/T
            DELAY_TIME          : integer := 100
        );
        
        port (
            clk                 : in STD_LOGIC;
            rst_n               : in STD_LOGIC;
            pulseOut            : out STD_LOGIC
        );

    end component delay;

    
begin

    idelay : delay
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            pulseOut    => delayFlag
        );
    
    idisplay : display7seg
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            value       => chronome,
            dot_i       => "10101011",
            anode       => anode,
            segment     => segment(6 downto 0),
            dot         => segment(7)
        );


    i100Hz : counter
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => delayFlag,
            value       => chronome(3 downto 0),
            overflow    => overflowVec(0)
        );
    
    i10Hz : counter
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(1),
            value       => chronome(7 downto 4),
            overflow    => overflowVec(2)
        );    

    i1Hz : counter
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(1),
            value       => chronome(11 downto 8),
            overflow    => overflowVec(2)
        );

    iDecimalSeg : counter
        generic map ( module => 5)
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(2),
            value       => chronome(15 downto 12),
            overflow    => overflowVec(3)
        );

    iMin : counter
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(3),
            value       => chronome(19 downto 16),
            overflow    => overflowVec(4)
        );

    iDecimalMin : counter
        generic map ( module => 5)
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(4),
            value       => chronome(23 downto 20),
            overflow    => overflowVec(5)
        );
    
    iHr : counter
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(5),
            value       => chronome(27 downto 24),
            overflow    => overflowVec(6)
        );

    iDecimalHr : counter
        generic map ( module => 5)
        port map (
            clk         => clk,
            rst_n       => rstBtn,
            countEn     => overflowVec(6),
            value       => chronome(31 downto 28),
            overflow    => ledOverflow
        );

    -- maquina de estados do cronometro
    process(ssBtn, lapBtn, rstBtn)
    begin
        if ssBtn='1' then
            if state="01" then
                state <= "00";
            elsif state="00" then
                state <= "01";
            end if;
        end if;
        
        if lapBtn='1' then
            state<="10";
        end if;
        
        if rstBtn='1' then
            state<="00";
        end if;
    end process;

    led <= "001" when (state="00") else
        "010" when (state="01") else
        "100" when (state="10") else
        "000";


end rtl;
