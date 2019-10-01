----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.09.2019 14:13:18
-- Design Name: 
-- Module Name: delay - rtl
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.all;

entity delay is
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

end delay;

architecture rtl of delay is

    --number of cycles to delay
    constant CYCLES         : integer := (CLK_FREQ/DELAY_TIME);
    --number of bits for cont to number of cycles
    constant NR_BITS        : integer := integer(ceil(log2(real(CYCLES))));

    signal counter          : STD_LOGIC_VECTOR(NR_BITS-1 downto 0);

begin

    process(clk)
    begin
        if(clk'event and clk='1') then
            if(rst_n = '0') then
                counter <= (others => '0');
            else
                counter <= counter + 1;
                if(counter = (CYCLES+1)) then
                    counter <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    pulseOut <= '1' when (counter = (CYCLES-1)) else '0';

end rtl;
