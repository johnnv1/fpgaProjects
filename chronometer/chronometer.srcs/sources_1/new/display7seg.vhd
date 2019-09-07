----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.09.2019 13:49:50
-- Design Name: 
-- Module Name: display7seg - rtl
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

entity display7seg is
    Port (     
            clk         : in STD_LOGIC;                             --clock  
            rst_n       : in STD_LOGIC;                             --reset signal: reset the counter
            value       : in STD_LOGIC_VECTOR (31 downto 0);        --values to show
            dot_i       : in STD_LOGIC_VECTOR (7 downto 0);         --dot's to show
            anode       : out STD_LOGIC_VECTOR (7 downto 0);        --on/off the displays
            segment     : out STD_LOGIC_VECTOR (6 downto 0);        --set the number at the display
            dot         : out STD_LOGIC                             --on/off the dot in the display
    ); 
end display7seg;

architecture rtl of display7seg is
    
    signal counter      : STD_LOGIC_VECTOR(16 downto 0);
    signal s_anode      : STD_LOGIC_VECTOR(7  downto 0);
    signal show         : STD_LOGIC_VECTOR(3  downto 0);


begin

    process (clk)
    begin
        if(clk'event and clk='1') then
            counter <= counter + 1;
        end if;
    end process;

    process (clk)
    begin
        if(clk'event and clk='1') then
            if(rst_n='0') then
                s_anode <= "11111110";
            else
                if(counter="11111111111111111") then
                    s_anode <= s_anode(6 downto 0) & s_anode(7);
                end if;
            end if;
        end if;
    end process;

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
               
    show <= value(23 downto 20) when s_anode(7)='0' else
            value(19 downto 16) when s_anode(6)='0' else
            value(15 downto 12) when s_anode(5)='0' else
            value(11 downto 08) when s_anode(4)='0' else
            value(07 downto 04) when s_anode(3)='0' else
            value(03 downto 00) when s_anode(2)='0' else
            value(07 downto 04) when s_anode(1)='0' else
            value(03 downto 00);
            
    dot <=  dot_i(7) when s_anode(7)='0' else
            dot_i(6) when s_anode(6)='0' else
            dot_i(5) when s_anode(5)='0' else
            dot_i(4) when s_anode(4)='0' else
            dot_i(3) when s_anode(3)='0' else
            dot_i(2) when s_anode(2)='0' else
            dot_i(1) when s_anode(1)='0' else
            dot_i(0);
               
    anode <= s_anode;

end rtl;
