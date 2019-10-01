----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.09.2019 14:50:41
-- Design Name: 
-- Module Name: counter - rtl
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

entity counter is

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
        overflow        : out STD_LOGIC                                     --flag for the case of overflow/terminate case
    );

end counter;

architecture rtl of counter is

    signal counter          : STD_LOGIC_VECTOR(size-1 downto 0);

begin

    process(clk)
    begin
        if(clk'event and clk='1') then
            if(rst_n = '0') then
                counter <= (others => '0');
            else
                if(countEn='1') then
                    counter <= counter + 1;
                    if(counter = (module-1)) then
                        counter <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process;

    value <=    counter;
    overflow <= '1' when (countEn='1' and (counter = (module-1))) else '0';
    
end rtl;
