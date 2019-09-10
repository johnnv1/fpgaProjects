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
           rstSwt           : in STD_LOGIC;                         --reset switch: reset the chronometer
           lapBtn           : in STD_LOGIC;                         --lap button : stop the display but continue cont
           --ooSwt            : in STD_LOGIC;                         -- on/off switch 
           segment          : out STD_LOGIC_VECTOR (7 downto 0);    --set the number at the display, MBS is for the dot (bit 7)
           anode            : out STD_LOGIC_VECTOR (7 downto 0);    --on/off the displays
           led              : out std_logic_vector(2 downto 0);
           ledOverflow      : out std_logic_vector(7 downto 0)
           );    
end chronometer;

architecture rtl of chronometer is

    signal delayFlag        : STD_LOGIC;
    signal overflowVec      : STD_LOGIC_VECTOR(6 downto 0);
    signal chronome         : std_logic_vector(31 downto 0);
    type states is (P0, P1, R0, R1, LAP);    -- parado e btn em 1, parado e btn em 0, run e btn em 1, parado e btn em 0
    signal current_state    : states;
    signal running          : STD_LOGIC;
    
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
            rst_n       => rstSwt,
            pulseOut    => delayFlag
        );
    
    idisplay : display7seg
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            value       => chronome,
            dot_i       => "10101011",
            anode       => anode,
            segment     => segment(6 downto 0),
            dot         => segment(7)
        );


    i100Hz : counter
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => running,
            value       => chronome(3 downto 0),
            overflow    => overflowVec(0)
        );
    
    i10Hz : counter
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(0),
            value       => chronome(7 downto 4),
            overflow    => overflowVec(1)
        );    

    i1Hz : counter
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(1),
            value       => chronome(11 downto 8),
            overflow    => overflowVec(2)
        );

    iDecimalSeg : counter
        generic map ( module => 6)
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(2),
            value       => chronome(15 downto 12),
            overflow    => overflowVec(3)
        );

    iMin : counter
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(3),
            value       => chronome(19 downto 16),
            overflow    => overflowVec(4)
        );

    iDecimalMin : counter
        generic map ( module => 6)
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(4),
            value       => chronome(23 downto 20),
            overflow    => overflowVec(5)
        );
    
    iHr : counter
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(5),
            value       => chronome(27 downto 24),
            overflow    => overflowVec(6)
        );

    iDecimalHr : counter
        generic map ( module => 6)
        port map (
            clk         => clk,
            rst_n       => rstSwt,
            countEn     => overflowVec(6),
            value       => chronome(31 downto 28),
            overflow    => ledOverflow(7)  -- use open
        );

    -- maquina de estados do cronometro
--    process(ssBtn, lapBtn, rstBtn)
--    begin
--        if ssBtn='1' then
--            if state="01" then
--                state <= "00";
--            elsif state="00" then
--                state <= "01";
--            end if;
--        end if;
        
--        if lapBtn='1' then
--            state<="10";
--        end if;
        
--        if rstBtn='1' then
--            state<="00";
--        end if;
--    end process;
    process(clk)
    begin
        if(clk'event and clk='1') then
            if(rstSwt = '0') then
                current_state <= P0;
            else
                case current_state is
                    when P1 =>
                        if ssBtn='0' then
                            current_state <= P0;
                        end if;
                    when R0 =>
                        if ssBtn='0' then
                            current_state <= R1;
                        end if;
                    when R1 =>
                        if ssBtn='1' then
                            current_state <= P1;
                        end if;
                    when others =>  -- P0
                        if ssBtn='1' then
                            current_state <= R0;
                        end if;
                end case;
            end if;
        end if;
    end process;

    running <= '1' when ((current_state= R0 or current_state=R1) and delayFlag ='1') else
                '0';
                    
    led <= "001" when (current_state=P0 or current_state= P1) else
        "010" when (current_state=R1 or current_state=R1) else
        "100" when (current_state=LAP) else
        "000";
    
    ledOverflow(6 downto 0) <= overflowVec(6 downto 0);
end rtl;
