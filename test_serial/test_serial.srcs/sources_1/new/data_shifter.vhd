----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.09.2019 14:44:36
-- Design Name: 
-- Module Name: data_shifter - Behavioral
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

entity data_shifter is
    Port ( clk : in STD_LOGIC;
           button : in STD_LOGIC;
           value : in STD_LOGIC_VECTOR (7 downto 0);
           segment : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0);
           dot : out STD_LOGIC;
           rst_n : in STD_LOGIC);
end data_shifter;

architecture rtl of data_shifter is
    signal shift_out : std_logic_vector(23 downto 0);
    signal s_anode: std_logic_vector(7 downto 0);
    signal cont: std_logic_vector(16 downto 0);
    signal show: std_logic_vector(3 downto 0);
    signal state: std_logic;    -- estados: shiftado ou n?o shiftado

begin

    process(clk)
    -- este process ? um grupo de ff que realiza o shifter
    begin
        if(clk'event and clk='1') then
            if(button = '1' and state ='0') then
                state <= '1';
                shift_out <= shift_out(15 downto 0) & value; -- & ? para concatenar o valor
            else
                if(button = '0') then
                    state <= '0';
                end if;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if(clk'event and clk='1') then
            cont <= cont + 1;
        end if;
    end process;

    process (clk)
    begin
        if(clk'event and clk='1') then
            if(rst_n='0') then
                s_anode <= "11111110";
            else
                if(cont="11111111111111111") then
                    s_anode <= s_anode(6 downto 0) & s_anode(7);
                end if;
            end if;
        end if;
    end process;
    
    
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
    show <= shift_out(23 downto 20) when s_anode(7)='0' else
            shift_out(19 downto 16) when s_anode(6)='0' else
            shift_out(15 downto 12) when s_anode(5)='0' else
            shift_out(11 downto 8) when s_anode(4)='0' else
            shift_out(7 downto 4) when s_anode(3)='0' else
            shift_out(3 downto 0) when s_anode(2)='0' else
            value(7 downto 4) when s_anode(1)='0' else
            value(3 downto 0);
    
    dot <= '0' when (s_anode(6)='0' or s_anode(4)='0' or s_anode(2)='0')
           else '1';
    anode <= s_anode;
    
    
    
end rtl;

