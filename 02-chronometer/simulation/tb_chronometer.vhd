----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2019 15:17:30
-- Design Name: 
-- Module Name: tb_chronometer - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_chronometer is
--  Port ( );
end tb_chronometer;

architecture Behavioral of tb_chronometer is
    
    component chronometer
        port (
            clk              : in STD_LOGIC;                          
            ssBtn            : in STD_LOGIC;                         --start/stop button: start/stop the chronometer
            rstSwt           : in STD_LOGIC;                         --reset switch: reset the chronometer
            lapBtn           : in STD_LOGIC;                         --lap button : stop the display but continue cont
            segment          : out STD_LOGIC_VECTOR (7 downto 0);    --set the number at the display, MBS is for the dot (bit 7)
            anode            : out STD_LOGIC_VECTOR (7 downto 0);    --on/off the displays
            led              : out std_logic_vector(2 downto 0);
            ledOverflow      : out std_logic_vector(7 downto 0)
        );  
    end component chronometer;
    
    signal          clk              : STD_LOGIC;                          
    signal          ssBtn            : STD_LOGIC;                         --start/stop button: start/stop the chronometer
    signal          rstSwt           : STD_LOGIC;                         --reset switch: reset the chronometer
    signal          lapBtn           : STD_LOGIC;                         --lap button : stop the display but continue cont
    signal          segment          : STD_LOGIC_VECTOR (7 downto 0);    --set the number at the display, MBS is for the dot (bit 7)
    signal          anode            : STD_LOGIC_VECTOR (7 downto 0);    --on/off the displays
    signal          led              :  std_logic_vector(2 downto 0);
    signal          ledOverflow      :  std_logic_vector(7 downto 0);
begin
    
    clk <= not clk after 5ns;
    
    process
    begin
        wait for 20ns;
        wait until clk'event and clk='1';
        rstSwt <= '1';
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        ssBtn <= '1';
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        ssBtn<='0';
        wait; 
    end process;

    duv: chronometer
        port map
            (
                clk => clk,
                rstSwt => rstSwt,
                lapBtn => lapBtn,
                ssBtn => ssBtn,
                segment => segment,
                anode => anode,
                led => led,
                ledOverflow => ledOverflow
            );
end Behavioral;
