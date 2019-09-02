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
Port (     clk : in STD_LOGIC;                          --clock 100MHz 
           ssBtn : in STD_LOGIC;                        --start/stop button: start/stop the chronometer
           rstBtn : in STD_LOGIC;                       --reset button: reset the chronometer
           lapBtn : in STD_LOGIC;                       --lap button : stop the display but continue cont
           --ooSwt : in STD_LOGIC;                        -- on/off switch 
           segment : out STD_LOGIC_VECTOR (6 downto 0); --set the number at the display
           anode : out STD_LOGIC_VECTOR (7 downto 0);   --on/off the displays
           dot : out STD_LOGIC                          --on/off the dot in the display
           );    
end chronometer;

-- nexys 4 ddr tem 8 display
-- | dH | H | dm | m | ds | s | ms | dms |
-- dH : dezenas de horas
-- H : horas
-- dm : dezenas de minutos
-- m : minutos
-- ds : dezenas de segundos
-- s : segundos
-- ms : centenas de mili segundos
-- dms : dezenas de mili segundos

architecture rtl of chronometer is
    signal cont: std_logic_vector(16 downto 0);
    signal cont_ms: std_logic_vector(6 downto 0);
    signal show_dms: std_logic_vector(3 downto 0);   -- ate 16 pra contar as dezenas de milisegundos
    signal show_ms: std_logic_vector(3 downto 0);   -- ate 16 pra contar as centenas de milisegundos
    signal show_ds: std_logic_vector(3 downto 0);    -- até 16 pra contar quantos dezenas de segundos esta
    signal show_s: std_logic_vector(3 downto 0);    -- até 16 pra contar quantos unidades de segundos esta
    signal show_dm: std_logic_vector(3 downto 0);    -- até 16 pra contar quantos dezenas de minutos esta
    signal show_m: std_logic_vector(3 downto 0);    -- até 16 pra contar quantos unidades de minutos esta
    signal show_dh: std_logic_vector(3 downto 0);    -- até 16 pra contar quantas dezenas de horas esta
    signal show_h: std_logic_vector(3 downto 0);    -- até 16 pra contar quantas unidades de horas esta
    signal state: std_logic_vector(1 downto 0);     -- estado do cronometro: 0-stop, 1-start/cronometrando, 2-lap
    signal show: std_logic_vector(3 downto 0);
    signal s_anode: std_logic_vector(7 downto 0);
    
begin
    
    process (clk)
    begin
        if(clk'event and clk='1') then
            if(state="01" or state="10") then
                cont <= cont + 1;
            else
                cont <= "00000000000000000";
                s_anode <= "11111111";
            end if;
        end if;
    end process;
    
--        process (clk)
--    begin
--        if(clk'event and clk='1') then
--            if(ooSwt='0') then
--                s_anode <= "11111110";
--            else
--                -- acho que este if não é nescessario, copiado do data shifter
--                if(cont="11111111111111111") then
--                    s_anode <= s_anode(6 downto 0) & s_anode(7);
--                end if;
--            end if;
--        end if;
--    end process;
    
    process (clk)
    begin
        if(clk'event and clk='1') then
            -- conta 1 mili segundo
            if(cont >= 100000) then
                cont_ms <= cont_ms + 1;
                cont <= "00000000000000000";
            end if;
            
            -- conta dezenas mili segundos
            if(cont_ms > 9) then
                show_dms <= show_dms + 1;
                cont_ms <= "0000000";
                if(state="01") then
                    s_anode <= "11111110";
                end if;
            
            -- conta centenas de mili segundos
            elsif(show_dms > 9) then
                show_ms <= show_ms + 1;
                show_dms <= "0000";
                if(state="01") then
                    s_anode <= "11111101";
                end if;
            
            -- conta unidades segundo
            elsif(show_ms > 9) then
                show_s <= show_s + 1;
                show_ms <= "0000";
                if(state="01") then
                    s_anode <= "11111011";
                end if;
            
            -- conta dezenas de segundos
            elsif(show_s > 9) then
                show_ds <= show_ds + 1;
                show_s <= "0000";
                if(state="01") then
                    s_anode <= "11110111";
                end if;
            
            -- conta unidades de minutos
            elsif(show_ds > 5) then
                show_m <= show_m + 1;
                show_s <= "0000";
                if(state="01") then
                    s_anode <= "11101111";
                end if;
            
            -- conta dezenas de minutos
            elsif(show_m > 9) then
                show_dm <= show_dm + 1;
                show_m <= "0000";
                if(state="01") then
                    s_anode <= "11011111";
                end if;
            
            -- conta unidades de horas
            elsif(show_dm > 5) then
                show_h <= show_h + 1;
                show_dm <= "0000";
                if(state="01") then
                    s_anode <= "10111111";
                end if;
            
            -- conta dezenas das horas
            elsif(show_h > 9) then
                show_dh <= show_dh + 1;
                show_h <= "0000";
                if(state="01") then
                    s_anode <= "01111111";
                end if;
            end if;
        end if;
    end process;
    
    -- maquina de estados do cronometro
    state <= "00" when (state="01" and ssBtn='1') else
             "01" when (state="00" and ssBtn='1') else
             "10" when (lapBtn='1') else
             "00" when (rstBtn='1');
    
    -- dislay values
    segment <= "0111000" when show =x"F" else
               "0110000" when show =x"E" else
               "1000010" when show =x"D" else
               "0110001" when show =x"C" else
               "1100000" when show =x"B" else
               "0001000" when show =x"A" else
               "0000100" when show =x"9" else
               "0000000" when show =x"8" else
               "0001111" when show =x"7" else
               "0100000" when show =x"6" else
               "0100100" when show =x"5" else
               "1001100" when show =x"4" else
               "0000110" when show =x"3" else
               "0010010" when show =x"2" else
               "1001111" when show =x"1" else
               "0000001";
               
    show <= show_dh when s_anode(7)='0' else
            show_h when s_anode(6)='0' else
            show_dm when s_anode(5)='0' else
            show_m when s_anode(4)='0' else
            show_ds when s_anode(3)='0' else
            show_s when s_anode(2)='0' else
            show_ms when s_anode(1)='0' else
            show_dms;
            
    dot <= '0' when (s_anode(6)='0' or s_anode(4)='0' or s_anode(2)='0')
           else '1';
           
    anode <= s_anode;
end rtl;
