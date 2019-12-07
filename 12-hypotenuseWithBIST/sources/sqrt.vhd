----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2019 22:58:03
-- Design Name: 
-- Module Name: sqrt - Behavioral
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

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2019 22:36:38
-- Design Name: 
-- Module Name: square - Behavioral
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

library ieee; 
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_unsigned.ALL;

entity sqrt is port( 
clock      : in std_logic;  
rst_n      : in std_logic;
data_in    : in std_logic_vector(7 downto 0);
out_flag : out std_logic; 
data_out   : out std_logic_vector(3 downto 0)); 
end sqrt;

architecture behavioral of sqrt is

signal part_done  : std_logic := '0';
signal part_count : integer := 3; 
signal result     : std_logic_vector(4 downto 0) := "00000"; 
signal partialq   : std_logic_vector(5 downto 0) := "000000";

begin   
    part_done_1: process(clock, data_in, part_done)  
    begin
        if(clock'event and clock='1')then
            out_flag <= '0';
            if(rst_n ='0') then
                data_out <= (others => '0');
                part_done <= '0';
                part_count <= 3;
                result <= "00000";
                partialq <= "000000";
            elsif(part_done='0')then
                if(part_count>=0)then
                    partialq(1 downto 0)  <= data_in((part_count*2)+ 1 downto part_count*2);
                    part_done <= '1';    else
                    data_out <= result(3 downto 0);
                    out_flag <= '1';    
                end if;    
                part_count <= part_count - 1;
                elsif(part_done='1')then
                    if((result(3 downto 0) & "01") <= partialq)then
                        result   <= result(3 downto 0) & '1';
                        partialq(5 downto 2) <= partialq(3 downto 0) - (result(1 downto 0)&"01");    
                    else 
                        result   <= result(3 downto 0) & '0';
                        partialq(5 downto 2) <= partialq(3 downto 0);                     
                    end if;   
                    part_done  <= '0';
                end if;
            end if;  
        end process;   
    end behavioral;